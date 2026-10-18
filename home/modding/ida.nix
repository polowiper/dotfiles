# IDA Pro 9.4 (Hex-Rays), declarative plugin management and the official
# ida-mcp server.
#
# The package and the plugin manager come from the `ida-pro` flake input (see
# ../../flake.nix). Its `homeManagerModules.default` is the same
# `programs.ida-pro` module as `nixosModules.default`, except that it installs
# into `home.packages` instead of `environment.systemPackages`.
{
  inputs,
  ...
}: {
  imports = [inputs.ida-pro.homeManagerModules.default];

  # Mark the IDA MCP server as available so home/development/pi emits it.
  my.ida-mcp.enable = true;

  # Declarative plugin management; plugins are resolved from the official
  # Hex-Rays repository pinned by the `ida-pro` input. `hcli`, wired to this
  # IDA installation, is installed as well (programs.ida-pro.hcli.enable).
  programs.ida-pro = {
    enable = true;
    plugins = [
      "diaphora"
    ];
  };
}
