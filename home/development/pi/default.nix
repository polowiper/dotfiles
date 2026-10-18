{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  baseUrl = "https://api.commandcode.ai/provider/v1";

  # Snapshot of GET /provider/v1/models (needs no credentials), committed next to
  # this file. Refresh it with ./refresh-commandcode-models.sh, then rebuild.
  #
  # This is read at *evaluation* time, not fetched during the build: Nix builds
  # have no network, and a fixed-output fetch would need its hash bumped every
  # time CommandCode adds a model. Committing the snapshot keeps the build
  # hermetic and the diff reviewable.
  #
  # Pi defaults an undeclared `contextWindow` to 128000, so hardcoding model IDs
  # silently capped the 1M-context models at 128k. Deriving from the snapshot
  # keeps the real `context_length` in sync.
  commandCodeModels = (builtins.fromJSON (builtins.readFile ./commandcode-models.json)).data;

  # The endpoint advertises which API each model speaks: Claude models expose
  # only /messages, everything else /chat/completions. The two sets are disjoint.
  toModel = model: {
    id = model.id;
    name = model.name;
    contextWindow = model.context_length;
  };

  modelsFor = endpoint:
    map toModel (
      builtins.filter (model: builtins.elem endpoint model.supported_endpoints) commandCodeModels
    );
in {
  programs.pi-coding-agent = {
    enable = true;

    # Packages available on the wrapped `pi` binary's PATH. `nodejs` provides the
    # npm/npx that pi uses to install the npm packages below. `yt-dlp` is needed
    # by pi-web-access for extracting frames from YouTube videos (xdg-utils and
    # ffmpeg are already provided by ./xdg.nix and the system config).
    extraPackages = [
      pkgs.nodejs
      pkgs.yt-dlp
    ];

    settings = {
      theme = "nebula";
      # Pinned declaratively: ~/.pi/agent/settings.json is a read-only
      # nix-store symlink, so pi cannot persist a model selected with
      # /model. Without these, startup falls back to the automatic default
      # (first provider in pi's built-in list with auth, else the first
      # available model), which changes between sessions.
      defaultProvider = "commandcode-openai";
      defaultModel = "deepseek/deepseek-v4.1-flash";
      packages = [
        "npm:pi-nebula"
        "npm:pi-web-access"
        "npm:pi-subagents"
        "npm:pi-mcp-adapter"
        "npm:pi-plan"
      ];
      # pi-mcp-adapter replaces the built-in MCP support; disable the built-in
      # explicitly so both do not run. The adapter still reads mcp.json below.
      extensions = ["-builtin:mcp"];
    };

    models = {
      providers = {
        # Claude models: /messages only, so they need the Anthropic API.
        commandcode = {
          inherit baseUrl;
          api = "anthropic-messages";
          models = modelsFor "/messages";
        };

        # Everything else speaks /chat/completions.
        commandcode-openai = {
          inherit baseUrl;
          api = "openai-completions";
          models = modelsFor "/chat/completions";
        };
      };
    };
  };
  home.file.".config/pi/web-search.json".source = jsonFormat.generate "pi-web-search.json" {
    searchRouting = {
      providers = [
        "exa"
        "anysearch"
        "keenable"
      ];
      fallbackOn = [
        "transient"
        "quota"
        "network"
        "invalid-response"
      ];
    };
  };

  # MCP servers, migrated from opencode.nix.
  # pi reads these from `<configDir>/mcp.json` (default `~/.pi/agent/mcp.json`).
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json".source =
    jsonFormat.generate "pi-agent-mcp.json"
    {
      mcpServers =
        {
          httptoolkit = {
            command = "${pkgs.httptoolkit}/share/httptoolkit/resources/httptoolkit-mcp";
          };
        }
        // lib.optionalAttrs config.my.ida-mcp.enable {
          # Official Hex-Rays IDA MCP server, provided by the `ida-pro` flake
          # input and only enabled when the modding category is imported. It
          # exposes the
          # `stdio` subcommand; `--agent` is just a label used in the session
          # dashboard. A single server can share multiple databases via IDA
          # Nexus, so there is no port/RPC second-instance equivalent.
          ida = {
            command = "ida-mcp";
            args = [
              "stdio"
              "--agent=pi"
            ];
          };
        };
    };
}
