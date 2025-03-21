import os
from dotenv import load_dotenv
import chainlit as cl

import pandas as pd
from langchain_community.vectorstores import FAISS
from langchain_openai.embeddings import OpenAIEmbeddings
from langchain_core.documents import Document
from langchain_community.document_loaders import DirectoryLoader
from langchain_community.document_loaders import BSHTMLLoader
from langchain_community.document_loaders import DirectoryLoader, PyPDFLoader, TextLoader, UnstructuredMarkdownLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_qdrant import QdrantVectorStore
from qdrant_client import QdrantClient
from qdrant_client.http.models import Distance, VectorParams
from langchain.retrievers.contextual_compression import ContextualCompressionRetriever
from langchain_cohere import CohereRerank
from langchain.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain.chat_models import init_chat_model
from langchain_core.rate_limiters import InMemoryRateLimiter
from langgraph.graph import START, StateGraph, END
from typing_extensions import List, TypedDict
from langchain_core.documents import Document
from langchain_core.messages import HumanMessage
from langchain_core.tools import tool
from langgraph.prebuilt import ToolNode
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from typing import TypedDict, Annotated
from langchain_core.documents import Document

#Load API Keys
load_dotenv()

#Load downloaded html pages of the book Genesis in Bible
path = "data/"
loaders = {
    "*.pdf": PyPDFLoader,
    "*.txt": TextLoader,
    "*.md": UnstructuredMarkdownLoader,
    "*.html": BSHTMLLoader
}

loader = DirectoryLoader(path, glob="**/*.*", loader_cls=lambda file_path: loaders[next(pattern for pattern in loaders if file_path.endswith(pattern))](file_path))
docs = loader.load()
docs = loader.load()

#Text Splitter
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size = 750,
    chunk_overlap = 100
)

split_documents = text_splitter.split_documents(docs)
len(split_documents)

#fine tuned embedding model
huggingface_embeddings = HuggingFaceEmbeddings(model_name="kcheng0816/finetuned_arctic_genesis")

#vector datastore
client = QdrantClient(":memory:")
client.create_collection(
    collection_name="mixed_documents",
    vectors_config=VectorParams(size=1024, distance=Distance.COSINE),
)

vector_store = QdrantVectorStore(
    client=client,
    collection_name="mixed_documents",
    embedding=huggingface_embeddings,
)

_ = vector_store.add_documents(documents=split_documents)

#Retrieve
retriever = vector_store.as_retriever(search_kwargs={"k": 5})


def retrieve_adjusted(state):
  compressor = CohereRerank(model="rerank-v3.5")
  compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor, base_retriever=retriever, search_kwargs={"k": 5}
  )
  retrieved_docs = compression_retriever.invoke(state["question"])
  return {"context" : retrieved_docs}

#RAG prompt
RAG_PROMPT = """\
You are a helpful assistant who answers questions based on provided context. You must only use the provided context, and cannot use your own knowledge.

### Question
{question}

### Context
{context}
"""
rag_prompt = ChatPromptTemplate.from_template(RAG_PROMPT)


#llm for RAG
rate_limiter = InMemoryRateLimiter(
    requests_per_second=1,  # <-- make a request once every 1 seconds!!
    check_every_n_seconds=0.1,  # Wake up every 100 ms to check whether allowed to make a request,
    max_bucket_size=10,  # Controls the maximum burst size.
)
llm = init_chat_model("gpt-4o-mini", rate_limiter=rate_limiter)


def generate(state):
  docs_content = "\n\n".join(doc.page_content for doc in state["context"])
  messages = rag_prompt.format_messages(question=state["question"], context=docs_content)
  response = llm.invoke(messages)
  return {"response" : response.content}

#Build RAG graph
class State(TypedDict):
  question: str
  context: List[Document]
  response: str

graph_builder = StateGraph(State).add_sequence([retrieve_adjusted, generate])
graph_builder.add_edge(START, "retrieve_adjusted")
graph = graph_builder.compile()


@tool
def ai_rag_tool(question: str) -> str:
    """Useful for when you need to answer questions about the loaded documents"""
    response = graph.invoke({"question": question})
    return {
        "message": [HumanMessage(content=response["response"])],
        "context": response["context"]
    }

tool_belt = [
    ai_rag_tool
]

#llm for agent reasoning
llm = init_chat_model("gpt-4o", temperature=0, rate_limiter=rate_limiter)
llm_with_tools = llm.bind_tools(tool_belt)



#Build an agent graph
class AgentState(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]
    context:List[Document]


def call_mode(state):
    messages = state["messages"]
    response = llm_with_tools.invoke(messages)
    return {
        "messages": [response],
        "context": state.get("context",[])
    }

tool_node = ToolNode(tool_belt)

def should_continue(state):
    last_message = state["messages"][-1]

    if last_message.tool_calls:
        return "action"
    
    return END


uncompiled_graph = StateGraph(AgentState)

uncompiled_graph.add_node("agent", call_mode)
uncompiled_graph.add_node("action", tool_node)

uncompiled_graph.set_entry_point("agent")

uncompiled_graph.add_conditional_edges(
    "agent",
    should_continue
)

uncompiled_graph.add_edge("action", "agent")

# Compile the graph.
compiled_graph = uncompiled_graph.compile()


#user interface
@cl.on_chat_start
async def on_chat_start():
   cl.user_session.set("graph", compiled_graph)



@cl.on_message
async def handle(message: cl.Message):
    graph = cl.user_session.get("graph")
    state = {"messages": [HumanMessage(content=message.content)]}
    response = await graph.ainvoke(state)
    await cl.Message(content=response["messages"][-1].content).send()
