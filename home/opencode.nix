{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."opencode/opencode.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "provider": {
          "commandcode": {
            "npm": "@ai-sdk/anthropic",
            "name": "Command Code (Claude)",
            "options": {
              "baseURL": "https://api.commandcode.ai/provider/v1"
            },
            "models": {
              "claude-sonnet-5": { "name": "Claude Sonnet 5" },
              "claude-sonnet-4-6": { "name": "Claude Sonnet 4.6" },
              "claude-fable-5": { "name": "Claude Fable 5" },
              "claude-opus-5": { "name": "Claude Opus 5" },
              "claude-opus-4-8": { "name": "Claude Opus 4.8" },
              "claude-opus-4-7": { "name": "Claude Opus 4.7" },
              "claude-haiku-4-5-20251001": { "name": "Claude Haiku 4.5" }
            }
          },
          "commandcode-openai": {
            "npm": "@ai-sdk/openai-compatible",
            "name": "Command Code (OpenAI / OSS)",
            "options": {
              "baseURL": "https://api.commandcode.ai/provider/v1"
            },
            "models": {
              "deepseek/deepseek-v4-pro": { "name": "DeepSeek V4 Pro" },
              "deepseek/deepseek-v4-flash": { "name": "DeepSeek V4 Flash" },
              "gpt-5.6-sol": { "name": "GPT-5.6 Sol" },
              "gpt-5.6-terra": { "name": "GPT-5.6 Terra" },
              "gpt-5.6-luna": { "name": "GPT-5.6 Luna" },
              "gpt-5.5": { "name": "GPT-5.5" },
              "gpt-5.4": { "name": "GPT-5.4" },
              "gpt-5.3-codex": { "name": "GPT-5.3 Codex" },
              "gpt-5.4-mini": { "name": "GPT-5.4 Mini" },
              "moonshotai/Kimi-K3": { "name": "Kimi K3" },
              "moonshotai/Kimi-K2.7-Code": { "name": "Kimi K2.7 Code" },
              "zai-org/GLM-5.2": { "name": "GLM 5.2" },
              "MiniMaxAI/MiniMax-M3": { "name": "MiniMax M3" },
              "xiaomi/mimo-v2.5-pro": { "name": "MiMo V2.5 Pro" },
              "Qwen/Qwen3.8-Max": { "name": "Qwen 3.8 Max" },
              "google/gemini-3.6-flash": { "name": "Gemini 3.6 Flash" },
              "google/gemini-3.5-flash": { "name": "Gemini 3.5 Flash" },
              "nvidia/nemotron-3-ultra-550b-a55b": { "name": "Nemotron 3 Ultra" },
              "xai/grok-4.5": { "name": "Grok 4.5" }
            }
          }
        },
        "mcp": {
          "ida-pro": {
            "type": "local",
            "command": [
              "ida-pro-mcp"
            ]
          },
          "ida-pro-2": {
            "type": "local",
            "command": [
              "ida-pro-mcp", "--ida-rpc", "http://127.0.0.1:13338"
            ]
          },
          "httptoolkit": {
            "type": "local",
            "command": [
              "${pkgs.httptoolkit}/share/httptoolkit/resources/httptoolkit-mcp"
            ]
          }
        }
      }
    '';
  };
}
