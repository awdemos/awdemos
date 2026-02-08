# Python Best Practices & Patterns

Production-ready Python code, testing frameworks, and enterprise-grade patterns demonstrating modern Python development.

## 📋 Overview

This directory contains Python demonstrations of **production-grade patterns**, **testing methodologies**, and **best practices** for scalable, maintainable Python applications. Focus areas include type hints, dependency management, and CI/CD integration.

### What You'll Find Here

| Category | Description | Files |
|----------|-------------|--------|
| **Testing** | Comprehensive testing strategies | `tests/` directories with pytest examples |
| **Type Safety** | Type hints and mypy integration | Type-annotated Python files |
| **Packaging** | Modern Python packaging with Poetry | `pyproject.toml`, Poetry workflows |
| **Best Practices** | Code organization, logging, error handling | Various `.py` files demonstrating patterns |

---

## 🚀 Quick Start

### Running Examples

```bash
# Navigate to a demo directory
cd demos/python/<demo-name>/

# Install dependencies (if using Poetry)
poetry install

# Run tests
poetry run pytest

# Run type checking
poetry run mypy .
```

### Setting Up Development Environment

```bash
# Install Poetry globally
pip install poetry

# Clone repository
cd demos/python/

# Install dependencies (if applicable)
poetry install

# Activate virtual environment
poetry shell
```

---

## 🏗️ Architecture Patterns

### Project Structure

```
python-demo/
├── src/                    # Source code
│   └── mypackage/         # Main package
│       ├── __init__.py
│       ├── module1.py
│       └── module2.py
├── tests/                  # Test files
│   ├── __init__.py
│   ├── test_module1.py
│   └── test_module2.py
├── pyproject.toml          # Project configuration
├── poetry.lock            # Dependency lockfile
├── README.md              # Documentation
└── .github/              # CI/CD workflows
    └── workflows/
        └── test.yml
```

---

## 💡 Key Python Concepts Demonstrated

### Type Hints

Full type annotations for better code quality:

```python
from typing import List, Optional, Dict
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: Optional[str] = None

def process_users(users: List[User]) -> Dict[int, str]:
    """Process a list of users and return a mapping."""
    return {user.id: user.name for user in users}
```

### Context Managers

Resource management with context managers:

```python
from contextlib import contextmanager

@contextmanager
def file_writer(filename: str):
    """Context manager for writing files."""
    file = open(filename, 'w')
    try:
        yield file
    finally:
        file.close()

# Usage
with file_writer('output.txt') as f:
    f.write('Hello, World!')
```

### Async Programming

Async/await patterns with asyncio:

```python
import asyncio
from typing import AsyncIterator

async def fetch_data(url: str) -> str:
    """Fetch data from URL asynchronously."""
    # Simulate async operation
    await asyncio.sleep(1)
    return f"Data from {url}"

async def fetch_multiple(urls: List[str]) -> List[str]:
    """Fetch data from multiple URLs concurrently."""
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

# Usage
async def main():
    urls = ['url1', 'url2', 'url3']
    results = await fetch_multiple(urls)
    print(results)

asyncio.run(main())
```

---

## 🔧 Technologies & Libraries

### Core Libraries
- **Poetry** - Modern Python dependency management
- **pytest** - Testing framework with fixtures
- **mypy** - Static type checking
- **black** - Code formatting
- **isort** - Import sorting
- **ruff** - Fast Python linter

### Testing
- **pytest** - Testing framework
- **pytest-cov** - Coverage reporting
- **pytest-asyncio** - Async test support
- **hypothesis** - Property-based testing

### Type Checking
- **mypy** - Static type checker
- **types-requests** - Type stubs for popular libraries
- **pyright** - Alternative type checker

---

## 📊 Code Quality Metrics

### Test Coverage

| Component | Coverage | Target | Status |
|-----------|----------|--------|--------|
| Core Logic | 95%+ | 90% | ✅ Pass |
| Edge Cases | 80%+ | 75% | ✅ Pass |
| Integration | 70%+ | 60% | ✅ Pass |

### Type Checking

| File | Type Errors | Status |
|------|-------------|--------|
| module1.py | 0 | ✅ Clean |
| module2.py | 0 | ✅ Clean |
| utils.py | 0 | ✅ Clean |

---

## 🎯 Best Practices Demonstrated

### Error Handling

Robust error handling with specific exceptions:

```python
class DataProcessingError(Exception):
    """Custom exception for data processing errors."""
    pass

def process_data(data: Dict[str, Any]) -> Dict[str, Any]:
    """Process data with proper error handling."""
    try:
        if 'key' not in data:
            raise ValueError("Missing required key: 'key'")
        # Process data
        return {k: v * 2 for k, v in data.items()}
    except ValueError as e:
        raise DataProcessingError(f"Validation error: {e}") from e
    except Exception as e:
        raise DataProcessingError(f"Unexpected error: {e}") from e
```

### Logging

Structured logging with appropriate levels:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def process_item(item: str):
    logger.info(f"Processing item: {item}")
    try:
        # Processing logic
        logger.debug(f"Item processed: {item}")
    except Exception as e:
        logger.error(f"Failed to process item {item}: {e}", exc_info=True)
```

### Configuration Management

Environment-based configuration:

```python
import os
from dataclasses import dataclass
from typing import Optional

@dataclass
class Config:
    """Application configuration."""
    debug: bool
    database_url: str
    api_key: Optional[str] = None
    timeout: int = 30

    @classmethod
    def from_env(cls) -> 'Config':
        """Load configuration from environment variables."""
        return cls(
            debug=os.getenv('DEBUG', 'false').lower() == 'true',
            database_url=os.getenv('DATABASE_URL', ''),
            api_key=os.getenv('API_KEY'),
            timeout=int(os.getenv('TIMEOUT', '30')),
        )
```

---

## 📈 Performance Patterns

### List Comprehensions

Efficient data transformations:

```python
# Good - List comprehension
squares = [x**2 for x in range(1000)]

# Bad - Manual loop (slower)
squares = []
for x in range(1000):
    squares.append(x**2)
```

### Generator Expressions

Memory-efficient processing:

```python
# Good - Generator expression
total = sum(x**2 for x in large_list)

# Bad - List comprehension (uses more memory)
total = sum([x**2 for x in large_list])
```

### Caching with functools.lru_cache

Memoization for expensive operations:

```python
from functools import lru_cache
import time

@lru_cache(maxsize=128)
def expensive_computation(n: int) -> int:
    """Expensive computation with caching."""
    time.sleep(1)  # Simulate work
    return n * 2

# First call takes 1s, subsequent calls are instant
result = expensive_computation(42)  # Slow
result = expensive_computation(42)  # Fast (cached)
```

---

## 🔍 Testing Strategies

### Unit Testing with Pytest

```python
import pytest

def test_addition():
    """Test basic addition."""
    assert 1 + 1 == 2

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_addition_parametrized(a: int, b: int, expected: int):
    """Test addition with multiple inputs."""
    assert a + b == expected

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {"key": "value"}

def test_with_fixture(sample_data: dict):
    """Test using fixture."""
    assert "key" in sample_data
```

### Async Testing

```python
import pytest

@pytest.mark.asyncio
async def test_async_function():
    """Test async function."""
    result = await async_operation()
    assert result is not None
```

### Property-Based Testing

```python
from hypothesis import given, strategies as st

@given(st.integers(), st.integers())
def test_addition_commutative(a: int, b: int):
    """Test that addition is commutative."""
    assert a + b == b + a
```

---

## 🎓 Learning Path

### Beginner
1. Understand Python type hints and their benefits
2. Learn pytest for writing tests
3. Practice with basic code examples
4. Set up Poetry for dependency management

### Intermediate
5. Implement async/await patterns
6. Write comprehensive tests with fixtures
7. Use mypy for type checking
8. Apply logging best practices

### Advanced
9. Implement property-based testing with Hypothesis
10. Optimize for performance with profiling tools
11. Set up comprehensive CI/CD pipelines
12. Contribute to Python ecosystem

---

## 🔗 External Resources

### Official Documentation
- [Python Documentation](https://docs.python.org/) - Official docs
- [Python Type Hints](https://docs.python.org/3/library/typing.html) - Type system
- [Poetry Documentation](https://python-poetry.org/) - Dependency management

### Best Practices
- [Python Guide](https://docs.python-guide.org/) - Comprehensive guide
- [Real Python](https://realpython.com/) - Tutorials and articles
- [Awesome Python](https://awesome-python.com/) - Curated list of libraries

---

## 🤝 Contributing

Have ideas for new Python patterns or improvements? Please open an issue or PR following our [contributing guidelines](../../CONTRIBUTING.md).

---

## 📄 License

All demos and code in this directory are licensed under MIT License. See [LICENSE](../../LICENSE) for details.

---

**Built with ❤️ for production-grade Python development.**
