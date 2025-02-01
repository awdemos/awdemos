# repo2txt: Repository Content Dumper for LLM Prompts

## Overview
repo2txt is a powerful tool designed to dump the contents of a Git repository into a single file, optimizing it for use in Retrieval-Augmented Generation (RAG) systems or as part of prompts for Large Language Models (LLMs). By consolidating your codebase into one file, you can more easily pass context to an LLM or integrate it into a RAG pipeline.
This document is improved documentaiton for dmeo purposes.

## Features
- Dumps entire repository content into a single file
- Respects .gitignore patterns to exclude unnecessary files
- Generates a tree-like directory structure for easy navigation
- Includes file contents for all non-excluded files
- Customizable file type filtering
- Standalone binary for easy deployment and use

## Use Cases
- **RAG Systems**: Use the dumped content as a knowledge base for retrieval-augmented generation, allowing LLMs to access and reference your codebase accurately.
- **LLM Prompts**: Include relevant parts of your codebase in prompts to give LLMs more context about your project structure and implementation details.
- **Code Analysis**: Quickly get an overview of your entire project in a single file, making it easier to analyze or search through your codebase.
- **Documentation**: Generate comprehensive documentation that includes both the structure and content of your project.

## Installation

### Building from Source
```bash
# Create clean environment and install dependencies
python3 -m venv build-env
source build-env/bin/activate
pip install --upgrade pip wheel
pip install pyinstaller

# Generate single-file binary with optimized settings
pyinstaller --onefile \
  --name repo2txt \
  --add-data "exclude.txt:." \
  --clean \
  --strip \
  --noconfirm \
  dump.py
```

### System-wide Installation (for Bluefin or other immutable operating systems)
```bash
sudo cp dist/repo2txt /var/usrlocal/bin/
sudo ln -s /var/usrlocal/bin/repo2txt /usr/local/bin/
```

## Usage
```bash
./dist/repo2txt <start_path> <output_file> [exclusion_file] [file_extensions...]
```

Example:
```bash
./dist/repo2txt /path/to/repo output.txt exclude.txt .py .js .html
```

This command will scan the repository, exclude files matching patterns in exclude.txt, and only include .py, .js, and .html files in the output.

## Output Format
The output file will contain:
1. A tree-like representation of your directory structure
2. The contents of each included file, preceded by its relative path

Example:
```
Directory Structure:
-------------------
/ 
├── .env.local
├── package.json
├── next.config.js
├── tsconfig.json
├── public/
│   └── images/
│       ├── astro.png
│       └── astro-logo.svg
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── tools/
...

File Contents:
--------------
File: .env.local
--------------------------------------------------
Content of .env.local:
API_KEY=your_api_key_here
...

File: package.json
--------------------------------------------------
Content of package.json:
{
  "name": "your-project",
  "version": "1.0.0",
  ...
}
...
```

## Benefits for LLM Integration
- **Contextual Understanding**: Provides the entire codebase structure and content for better project comprehension.
- **Improved Code Generation**: Enables more accurate and context-aware code suggestions.
- **Enhanced Debugging**: Offers full context for more precise problem identification and solution suggestions.
- **Architecture Analysis**: Allows LLMs to provide insights on your project's architecture and suggest improvements.
- **Documentation Generation**: Use the dumped content to ask LLMs to generate or improve project documentation.

## Best Practices
- Be mindful of sensitive information. Use .gitignore or the exclusion file to omit sensitive data.
- For large repositories, consider dumping only relevant sections to stay within LLM token limits.
- When using the dumped content in LLM prompts, clearly specify which parts of the codebase are relevant to your question or task.

## Contributing
Contributions to improve repo2txt are welcome! Please submit issues or pull requests on our GitHub repository.

## Enterprise Deployment Considerations
- **Multi-arch builds**: Use a Dockerized build chain for cross-platform compatibility.
- **Signature verification**: Implement code signing during CI/CD pipeline.
- **Observability**: Add a Prometheus metrics endpoint using `prometheus-client`.

For production deployments, consider containerizing the binary in a scratch Docker image:

```Dockerfile
FROM gcr.io/distroless/base-debian11
COPY --from=builder /app/dist/repo2txt /
CMD ["/repo2txt"]
```

This comprehensive documentation now covers all the key aspects of repo2txt, including its purpose, features, installation, usage, and best practices for LLM integration.
