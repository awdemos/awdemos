#%% Initial setup
# Install required packages in single cell
# pip install langchain langchain-openai crewai duckduckgo-search dotenv
# print("Packages installed. Please restart kernel if required.")

#%% Configuration and imports
from dotenv import load_dotenv
from typing import List, Dict, Any
from langchain_community.tools import DuckDuckGoSearchRun
from langchain_openai import OpenAI
from crewai import Agent, Task, Crew, Process

# Environment setup
if not load_dotenv():
    raise EnvironmentError("Could not load .env file")
    
# Constants
VERBOSE_LEVEL = 2  # Control logging verbosity (0-2)
LLM_TEMPERATURE = 0.0  # Control model creativity

#%% Core components
def create_llm() -> OpenAI:
    """Configure and return the LLM with error handling"""
    try:
        return OpenAI(temperature=LLM_TEMPERATURE)
    except Exception as e:
        raise RuntimeError("Failed to initialize LLM") from e

def create_agents(llm: OpenAI) -> Dict[str, Agent]:
    """Create and configure CrewAI agents with proper separation of concerns"""
    search_tool = DuckDuckGoSearchRun()
    
    return {
        "researcher": Agent(
            role="Senior Research Analyst",
            goal="Uncover cutting-edge developments in AI and data science",
            backstory=(
                "As a lead analyst at a top tech think tank, you specialize in "
                "identifying emerging trends and distilling complex data into "
                "actionable insights with a focus on AI innovation."
            ),
            tools=[search_tool],
            verbose=True,
            allow_delegation=False,
            llm=llm
        ),
        "writer": Agent(
            role="Tech Content Strategist",
            goal="Craft compelling content on tech advancements",
            backstory=(
                "Award-winning content strategist renowned for transforming "
                "technical concepts into engaging narratives for tech-savvy audiences."
            ),
            verbose=True,
            allow_delegation=True,
            llm=llm
        )
    }

def create_tasks(agents: Dict[str, Agent]) -> List[Task]:
    """Define clear, maintainable tasks with proper documentation"""
    return [
        Task(
            description=(
                "Conduct comprehensive analysis of 2024 AI advancements.\n"
                "- Identify key trends and breakthrough technologies\n"
                "- Analyze potential industry impacts\n"
                "- Provide full analysis report with supporting data"
            ),
            agent=agents["researcher"],
            expected_output="Comprehensive analysis report in Markdown format"
        ),
        Task(
            description=(
                "Develop engaging blog post from research insights\n"
                "- Highlight significant AI advancements\n"
                "- Maintain accessible tone for tech-savvy audience\n"
                "- Avoid AI-generated sounding language\n"
                "- Minimum 4 paragraphs with supporting examples"
            ),
            agent=agents["writer"],
            expected_output="Polished blog post in Markdown format"
        )
    ]

#%% Execution flow
def main():
    """Orchestrate the CrewAI workflow with proper error handling"""
    try:
        llm = create_llm()
        agents = create_agents(llm)
        tasks = create_tasks(agents)
        
        crew = Crew(
            agents=list(agents.values()),
            tasks=tasks,
            process=Process.sequential,
            verbose=VERBOSE_LEVEL
        )
        
        result = crew.kickoff()
        
        # Save output with timestamp
        from datetime import datetime
        filename = f"ai_analysis_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        with open(filename, "w") as f:
            f.write(result)
            
        print(f"✅ Analysis complete! Output saved to {filename}")
        print("-" * 50)
        print(result[:500] + "...")  # Preview first 500 characters
        
    except Exception as e:
        print(f"❌ Execution failed: {str(e)}")
        raise

if __name__ == "__main__":
    main()

