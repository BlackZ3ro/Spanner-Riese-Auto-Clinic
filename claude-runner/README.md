# Claude Runner (Node + Python)

This directory adds two simple Dockerized runners (Node.js and Python) that call a Claude-compatible API endpoint and optionally commit the generated output back to the repository.

Features
- Dockerfile for Node.js runner
- Dockerfile for Python runner
- Simple sample client that sends a prompt to a Claude-compatible API endpoint (configured via env)
- start scripts that, if you provide GITHUB_TOKEN and GITHUB_BRANCH, will commit the generated claude_output.md back to the repo

Important environment variables
- CLAUDE_API_KEY - your Anthropic/Claude API key
- CLAUDE_API_URL - optional, default: https://api.anthropic.com/v1/complete (change if your account uses a different endpoint)
- GITHUB_TOKEN - Personal Access Token with repo permissions (used only if you want the container to push changes back to this repo)
- GITHUB_REPO - owner/repo (default: BlackZ3ro/Spanner-Riese-Auto-Clinic)
- GITHUB_BRANCH - branch to push updates to (default: claude/runner)

How to get an API key
1. Sign into your Anthropic/Claude account.
2. Navigate to API keys or developer settings and create a new API key.
3. Set CLAUDE_API_KEY in your environment or CI secrets.

How to run locally (Node)

1. cd claude-runner/node
2. docker build -t claude-node-runner .
3. docker run --rm -e CLAUDE_API_KEY="$CLAUDE_API_KEY" -e GITHUB_TOKEN="$GITHUB_TOKEN" -e GITHUB_REPO="BlackZ3ro/Spanner-Riese-Auto-Clinic" -e GITHUB_BRANCH="claude/runner" claude-node-runner

How to run locally (Python)

1. cd claude-runner/python
2. docker build -t claude-py-runner .
3. docker run --rm -e CLAUDE_API_KEY="$CLAUDE_API_KEY" -e GITHUB_TOKEN="$GITHUB_TOKEN" -e GITHUB_REPO="BlackZ3ro/Spanner-Riese-Auto-Clinic" -e GITHUB_BRANCH="claude/runner" claude-py-runner
