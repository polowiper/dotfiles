# IDA Pro MCP Plugin

This directory (`ida_mcp/`) is the **core IDA plugin package** for `ida-pro-mcp`. It runs inside IDA Pro's Python interpreter and exposes IDA's functionality via a JSON-RPC HTTP server.

Alongside it, the **MCP proxy server** (`server.py` one directory up) translates the MCP protocol into JSON-RPC calls to this plugin.

## Architecture

```
Opencode  ──stdio──▶  server.py (proxy)  ──HTTP──▶  IDA GUI (plugin on :13337)
```

Two pieces:

| Piece | File(s) | Runs in | What it does |
|-------|---------|---------|-------------|
| **IDA Plugin** | `ida_mcp/` + `ida_mcp.py` | IDA's Python (inside IDA) | Exposes 75+ IDA tools via a local HTTP JSON-RPC server on port `:13337` |
| **Proxy server** | `../server.py` | Any Python 3.11+ | Translates MCP stdio/HTTP to JSON-RPC calls to the IDA plugin |

### Files in this directory

- `api_*.py` — Tool implementations (analysis, core, debug, memory, modify, types, stack, etc.)
- `rpc.py` — Shared `MCP_SERVER` singleton and `@tool`/`@resource` decorators
- `sync.py` — `@idasync` decorator (routes IDA SDK calls to the main thread)
- `http.py` — HTTP request handler for the plugin's JSON-RPC server
- `discovery.py` — Instance registration/auto-discovery for the proxy
- `zeromcp/` — Vendored lightweight MCP protocol implementation
- `framework.py` — IDA plugin framework (plugin_t registration, menu items)
- `compat.py` — Cross-IDA-version compatibility shims
- `utils.py` — Shared helpers (pagination, filtering, address parsing)

### Headless mode

There's also a headless variant using `idalib` (no IDA GUI needed):

```
Opencode  ──stdio──▶  idalib-mcp (supervisor)  ──subprocess──▶  idalib-worker (idalib_server.py)
```

This runs IDA headlessly via `idapro.open_database()`. All tools from `ida_mcp/` are available.

## Installing the IDA plugin

The plugin (`ida_mcp.py` loader + `ida_mcp/` package) must be in IDA's plugin search path before IDA is started.

### Option 1: Symlink into `~/.idapro/plugins/`

```bash
mkdir -p ~/.idapro/plugins
ln -sf /home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp.py ~/.idapro/plugins/ida_mcp.py
ln -sf /home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp  ~/.idapro/plugins/ida_mcp
```

### Option 2: Use `--install` (requires working Python venv)

```bash
# From within a devenv:
uv run ida-pro-mcp --install
# Or using the venv directly:
/home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp/.devenv/state/venv/bin/ida-pro-mcp --install
```

### Verification

Start IDA Pro. You should see `MCP plugin ready to use` in the output and `Edit > Plugins > MCP Configuration` in the menu. The HTTP server auto-starts on port 13337.

### NixOS integration (optional)

To embed the MCP plugin directly into the IDA Pro Nix build (so symlinks aren't needed):

```bash
# Symlink the MCP plugin files into the nixos config's plugins directory
ln -sf /home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp.py /home/polo/nixos/home/ida_pro/plugins/ida_mcp.py
ln -sf /home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp    /home/polo/nixos/home/ida_pro/plugins/ida_mcp
```

Nix follows symlinks when `import`ing paths (`${./plugins}/ida_mcp.py`), so the build will bundle them. The `ida.nix` already uses `cp -r` in the install phase to copy subdirectories.

After that, rebuild: `nixos-rebuild switch` or `home-manager switch`.

## Setting up the MCP proxy for Opencode

The opencode config is managed by Home Manager in `/home/polo/nixos/home/opencode.nix`. After a `home-manager switch`, it writes to `~/.config/opencode/opencode.jsonc`:

```json
{
  "mcp": {
    "ida-pro": {
      "type": "local",
      "command": [
        "/home/polo/ida-pro-mcp/src/ida_pro_mcp/ida_mcp/.devenv/state/venv/bin/ida-pro-mcp"
      ]
    }
  }
}
```

This uses the `devenv`-managed venv which has all dependencies pre-installed. The path is stable because both the `ida-pro-mcp` source tree and the `.nix-profile` Python it points to are at fixed locations.

### Why not `uv run`?

`uv` is available system-wide (via `devenv` system package), but `uv run <pkg>` re-syncs dependencies on every launch. The venv entrypoint avoids this overhead.

## Updating

When the `ida-pro-mcp` source is updated, re-sync the venv:

```bash
cd /home/polo/ida-pro-mcp
uv sync
```

Then restart opencode to pick up any changes.

If the venv breaks or you want a fresh install:

```bash
cd /home/polo/ida-pro-mcp
rm -rf src/ida_pro_mcp/ida_mcp/.devenv/state/venv
uv sync
```

## Flow summary

1. Start IDA Pro → plugin autostarts HTTP server on `127.0.0.1:13337`
2. Launch opencode → Home Manager config spawns `ida-pro-mcp` as stdio MCP server
3. `server.py` (proxy) auto-discovers the IDA instance and proxies tool calls to the plugin
