This is an AI generated format of the messages made by Cobra in the Z.AI Discord #faq server.
I share this in the hope that it is useful for someone in the future.
If this article helped you it is my extreme hope that you can be extra kind to someone today in return.

***

## 1. When things break: always test the raw API

If a tool times out, says “1113 Insufficient balance”, or behaves weirdly, assume it is **endpoint or API‑key misconfiguration**, not your account being broken. [docs.z](https://docs.z.ai/api-reference/api-code)

Use this minimal `curl` as a litmus test:

```bash
curl -X POST "https://api.z.ai/api/coding/paas/v4/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Accept-Language: en-US,en" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "glm-4.7",
    "messages": [
      {
        "role": "user",
        "content": "Hello, write me 5 words"
      }
    ],
    "temperature": 1.0,
    "stream": true
  }'
```

If this works but your client does not, the problem is **client configuration**, not the key or quota. [docs.z](https://docs.z.ai/guides/develop/http/introduction)

***

## 2. GLM Coding Plan: endpoints, models, and confusion

GLM Coding Plan runs on a **different stack** than the generic Z.ai API. Messing up the endpoint is the #1 reason for “1113” or truncated responses. [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)

### Correct Coding Plan endpoints

For tools that support custom base URLs, use:

- **Claude Code / Anthropic‑style clients**:  
  `https://api.z.ai/api/anthropic`  
  (models: `glm-4.7`, `glm-5`, `glm-4.5-air`, etc.) [docs.z](https://docs.z.ai/devpack/quick-start)

- **Other tools (Cursor, Clawbot, Crush, etc.)**:  
  `https://api.z.ai/api/coding/paas/v4`  
  (model id: `glm-4.7`) [docs.z](https://docs.z.ai/guides/develop/http/introduction)

### Common wrong endpoints (avoid these for Coding Plan)

- `https://api.z.ai/api/paas/v4`  
- `https://open.bigmodel.cn/api/paas/v4`

These will reject your Coding Plan key or treat it as regular API traffic, often returning “1113 Insufficient balance” even if your balance is fine. [docs.z](https://docs.z.ai/api-reference/api-code)

***

## 3. Key / account issues: quick checklist

When you see:

```json
{"error":{"code":"1113","message":"Insufficient balance or no resource package. Please recharge."}}
```

Check:

1. **Endpoint is correct for your client**  
   - Z.ai Coding endpoint for tools that support it. [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)
2. **Key is valid**  
   - Regenerate from Z.ai Console if in doubt. [docs.z](https://docs.z.ai/api-reference/api-code)
3. **Subscription is active**  
   - GLM Coding Plan must be subscribed and active. [docs.z](https://docs.z.ai/api-reference/api-code)
4. **No network restrictions**  
   - You are not blocked by region or firewall; try from another network. [docs.z](https://docs.z.ai/api-reference/api-code)

If `curl` works but your IDE or agent does not, the error is **in the client config**, not the account. [docs.z](https://docs.z.ai/devpack/quick-start)

***

## 4. Claude Code / Anthropic‑style config

For Claude Code and similar tools, configure `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN` to Z.ai:

```jsonc
// ~/.claude/settings.json or CLI env
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your_api_key",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_MODEL": "glm-5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5",
    "MAX_MCP_OUTPUT_TOKENS": "50000",
    "DISABLE_COST_WARNINGS": "1",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  }
}
```

This routes all Claude‑style calls through Z.ai’s GLM stack instead of Anthropic. [docs.z](https://docs.z.ai/devpack/quick-start)

***

## 5. GLM‑4.7 vs GLM‑5: trade‑offs and quotas

- **GLM‑4.7**  
  - The default “coding” workhorse; very fast, stable, and widely tested.  
  - Has higher quota and fewer automatic throttling rules than GLM‑5. [docs.z](https://docs.z.ai/api-reference/api-code)

- **GLM‑5**  
  - Newer, more capable reasoning, but subject to **newer automatic quota limits**.  
  - If you find your queries suddenly slow or get quota errors, consider falling back to `glm-4.7` where possible. [docs.z](https://docs.z.ai/api-reference/api-code)

If you’re on a budget or in a heavy‑usage flow, prefer `glm-4.7` unless you explicitly need GLM‑5’s reasoning depth. [docs.z](https://docs.z.ai/api-reference/api-code)

***

## 6. Popular tool configurations (Z.ai + GLM‑4.7)

### Cursor / Kilo‑Code CLI

- Provider: **Z AI**  
- Endpoint: `https://api.z.ai/api/coding/paas/v4`  
- Model: `glm-4.7`  
- Ensure the model name is **UPPERCASE** in some clients. [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)

### Crush CLI

```jsonc
// ~/.config/crush/providers.json (Linux/macOS)
{
  "base_url": "https://api.z.ai/api/coding/paas/v4",
  "api_key": "your_zai_api_key"
}
```

This overrides the generic OpenAI‑style provider with Z.ai Coding Plan. [github](https://github.com/charmbracelet/crush/issues/1079)

### VS Code: OAI‑Compatible / Cline

```jsonc
{
  "oaicopilot.baseUrl": "https://api.z.ai/api/coding/paas/v4",
  "oaicopilot.models": [
    {
      "id": "glm-4.7",
      "owned_by": "zai-coding",
      "temperature": 0.7,
      "top_p": 0.95,
      "max_tokens": 4096,
      "thinking": { "type": "enabled" },
      "capabilities": ["chat", "edit", "tools"]
    }
  ]
}
```

This routes Copilot‑style calls through the Coding Plan endpoint. [docs.z](https://docs.z.ai/guides/develop/http/introduction)

### Zed Editor

```jsonc
"language_models": {
  "openai_compatible": {
    "Z_AI": {
      "api_url": "https://api.z.ai/api/coding/paas/v4",
      "available_models": [
        {
          "name": "glm-4.7",
          "display_name": "glm-4.7",
          "max_tokens": 200000,
          "capabilities": {
            "tools": true,
            "images": false,
            "parallel_tool_calls": true,
            "prompt_cache_key": true
          }
        },
        {
          "name": "glm-4.6",
          "display_name": "glm-4.6",
          "max_tokens": 200000,
          "capabilities": {
            "tools": true,
            "images": false,
            "parallel_tool_calls": true,
            "prompt_cache_key": true
          }
        }
      ]
    }
  }
}
```

This exposes both `glm-4.7` and `glm‑4.6` as first‑class providers in Zed. [zhipu-32152247.mintlify](https://zhipu-32152247.mintlify.app/guides/develop/http/introduction)

***

## 7. Plugins, MCPs, and agent‑style workflows

Z.ai exposes a set of **MCP servers** and plugins that plug into agents like Claude Code, OpenClaw, and Eigent. These let you do web search, file‑system automation, and browser‑style actions without leaving your agent.

### Web / Vision MCPs (Claude Code / OpenClaw)

- **Vision MCP server**  
  Browser automation on the desktop, integrated with GLM Coding Plan. [docs.z](https://docs.z.ai/api-reference/api-code)

- **Web‑search / Web‑reader MCPs**  
  Add:

  ```bash
  claude mcp add -s user -t http web-search-prime \
    https://api.z.ai/api/mcp/web_search_prime/mcp \
    --header "Authorization: Bearer your_api_key"

  claude mcp add -s user -t http web-reader \
    https://api.z.ai/api/mcp/web_reader/mcp \
    --header "Authorization: Bearer your_api_key"
  ```

  These let agents fetch and read web pages via Z.ai’s MCP layer. [docs.z](https://docs.z.ai/api-reference/api-code)

### OpenClaw / Clawbot / Moltbot

- Set `profile: "full"` in `~/.openclaw/openclaw.json` to enable tools that might otherwise truncate responses. [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)
- Configure `base_url` to `https://api.z.ai/api/coding/paas/v4` for Z.ai Coding Plan. [docs.z](https://docs.z.ai/guides/develop/http/introduction)

### Eigent (open‑source desktop agent)

- Eigent is explicitly designed to work with GLM Coding Plan, using MCPs for browser and terminal automation. [docs.z](https://docs.z.ai/api-reference/api-code)
- It exposes a “cowork agent” model that runs on your desktop and can drive CLIs, editors, and browsers without deep API plumbing. [docs.z](https://docs.z.ai/api-reference/api-code)

***

## 8. Pricing, quotas, and “truncated” messages

- GLM Coding Plan pricing increased in early 2026; first‑purchase discounts were removed, and Lite/Max plans got more expensive. [docs.z](https://docs.z.ai/api-reference/api-code)
- Existing subscribers keep their old rates, but new users face higher prices. [docs.z](https://docs.z.ai/api-reference/api-code)

If messages seem “truncated”:

- **Check whether tools are enabled** in your client config (e.g., `profile: "full"` in OpenClaw). [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)
- If tools are disabled, agents may fall back to shorter, non‑tool‑using responses even when they could use agents. [docs.z](https://docs.z.ai/api-reference/api-code)

***

## 9. Practical workflow for you (DevOps / platform‑AI engineer)

Given your stack (Linux, Rust, Neovim, Pulumi, Zed, etc.), a robust setup looks like:

- **CLI / scripts**:  
  - Use `curl` + `glm-4.7` on `https://api.z.ai/api/coding/paas/v4` for ad‑hoc AI‑assisted infra or code generation. [docs.z](https://docs.z.ai/guides/develop/http/introduction)
- **IDEs (Zed / VS Code)**:  
  - Wire Z.ai as an OpenAI‑compatible provider with `glm-4.7`, `max_tokens: 200000`, and tools enabled. [zhipu-32152247.mintlify](https://zhipu-32152247.mintlify.app/guides/develop/http/introduction)
- **Agents (OpenClaw, Eigent, Clawbot)**:  
  - Point them to GLM Coding Plan endpoints and use MCPs for web‑search, file operations, and shell automation. [answeroverflow](https://www.answeroverflow.com/m/1459789839590232236)

This keeps your AI stack API‑portable, open‑tool‑oriented, and avoids depending on any one big‑tech vendor.

