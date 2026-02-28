<!--
meta:
  title: "repo2txt - Repository Dumper for LLM Prompts & RAG Systems"
  description: "repo2txt dumps Git repository contents into a single file optimized for LLM prompts and RAG systems. Supports .gitignore, file filtering, and tree structure generation."
  keywords: "repo2txt, LLM RAG tool, repo to text converter, Git repository dumper, LLM context dump, codebase to text, RAG knowledge base"
  author: "Drew"
  type: "technical-tool"
  canonical: "https://awdemos.github.io/demos/docs/Repo2txt.html"

og:
  title: "repo2txt - Repository Dumper for LLM Prompts & RAG Systems"
  description: "Dump Git repository contents into a single file optimized for LLM prompts and RAG systems. Free, open-source, respects .gitignore."
  type: "article"
  url: "https://awdemos.github.io/demos/docs/Repo2txt.html"
  image: "https://awdemos.github.io/demos/docs/og-repo2txt.png"

twitter:
  card: "summary_large_image"
  title: "repo2txt - Repository Dumper for LLM Prompts & RAG Systems"
  description: "Dump Git repository contents into a single file optimized for LLM prompts and RAG systems."
  image: "https://awdemos.github.io/demos/docs/og-repo2txt.png"
-->

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "repo2txt",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Linux, macOS, Windows",
  "description": "repo2txt dumps contents of a Git repository into a single file, optimized for use in Retrieval-Augmented Generation (RAG) systems or as part of prompts for Large Language Models (LLMs).",
  "featureList": ["Repository content dumping", ".gitignore support", "Tree structure generation", "File type filtering", "Standalone binary"],
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "author": {
    "@type": "Person",
    "name": "Drew",
    "knowsAbout": ["RAG Systems", "LLM Integration", "Git Tools", "Python Development", "DevOps"]
  },
  "about": [
    {"@type": "Thing", "name": "RAG Systems"},
    {"@type": "Thing", "name": "Large Language Models"},
    {"@type": "Thing", "name": "Git Repository Management"},
    {"@type": "Thing", "name": "Codebase Analysis"}
  ],
  "keywords": "repo2txt, LLM RAG tool, repo to text converter, Git repository dumper, LLM context dump, codebase to text"
}
</script>

---

**Quick Summary**: repo2txt consolidates entire Git repositories into a single text file optimized for LLM context and RAG systems. Ideal for developers who need to feed codebase context to AI assistants or build knowledge bases for retrieval-augmented generation.

---

## Comparison: repo2txt vs Similar Tools

| Feature | repo2txt | git ls-files | grep -r | gpt-repo-extractor |
|---------|-----------|--------------|----------|---------------------|
| **Output Format** | Structured tree + file contents | File paths only | File contents only | JSON format |
| **.gitignore Support** | ✅ Yes | ❌ No | ❌ No | ⚠️ Partial |
| **File Filtering** | ✅ Custom extensions | ⚠️ Limited | ✅ Glob patterns | ❌ No |
| **Tree Structure** | ✅ Visual tree | ❌ No | ❌ No | ✅ Yes |
| **Performance** | Fast (binary) | Fast | Slow on large repos | Medium |
| **LLM Optimized** | ✅ Yes | ❌ No | ❌ No | ✅ Yes |
| **Standalone Binary** | ✅ Yes | N/A (built-in) | N/A (built-in) | ❌ Requires Python |
| **Privacy** | ✅ Runs locally | ✅ Runs locally | ✅ Runs locally | ⚠️ May call APIs |

**Why repo2txt?**
- Combines the best of both worlds: structured tree view + full file contents
- Optimized specifically for LLM context limits and token efficiency
- Respects .gitignore to exclude sensitive data automatically
- Runs as a standalone binary with no dependencies after build
- Perfect for RAG knowledge bases and LLM code review workflows

---


# repo2txt: Repository Content Dumper for LLM Prompts

## Overview
repo2txt is a powerful tool designed to dump the contents of a Git repository into a single file, optimizing it for use in Retrieval-Augmented Generation (RAG) systems or as part of prompts for Large Language Models (LLMs). By consolidating your codebase into one file, you can more easily pass context to an LLM or integrate it into a RAG pipeline.
This document is improved documentaiton for demo purposes.

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

---

## FAQ - Common Questions

### Q: Is repo2txt safe for private repositories?
**A:** Yes, repo2txt runs entirely locally on your machine. No data is sent to external servers. The output file stays on your filesystem.

### Q: How do I handle large repositories that exceed LLM token limits?
**A:** Use file extension filtering feature to dump only relevant file types. For example, include only `.ts`, `.tsx`, and `.md` files for a TypeScript project to stay within context windows.

### Q: Can I use repo2txt for sensitive codebases?
**A:** Absolutely. Since it runs locally and respects .gitignore, you can safely dump production code. Just ensure your .gitignore excludes any truly sensitive files like `.env` or secrets.

### Q: What's the difference between repo2txt and git ls-files?
**A:** git ls-files only lists file paths. repo2txt provides both directory tree structure AND actual file contents, formatted specifically for LLM consumption.

### Q: How do I integrate repo2txt into a CI/CD pipeline?
**A:** Build the binary, then run `repo2txt . repo-dump.txt exclude.txt` as a step in your pipeline. The dump.txt can be stored in your knowledge base or fed to an LLM for automated code review.

### Q: Can repo2txt handle monorepos?
**A:** Yes, repo2txt can handle any Git repository structure. For monorepos, run it on the root directory and it will recursively dump all subdirectories.

### Q: What file types should I include for best LLM results?
**A:** Depends on your goal:
- For code review: `.ts`, `.js`, `.py`, `.go`, `.rs`, `.java`, `.cpp`, `.h`
- For documentation: `.md`, `.rst`, `.txt`
- For configuration: `.json`, `.yaml`, `.yml`, `.toml`, `.env.example`

---

**Last Updated:** January 2026

[← Back to Main Documentation](index.md)
