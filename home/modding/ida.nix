# IDA Pro 9.4 (Hex-Rays) plus the official ida-mcp server.
#
# The package itself lives in ../../pkgs/ida-pro and is exposed as
# `packages.<system>.ida-pro` in flake-modules/packages.nix.
{inputs, pkgs, ...}: {
  # Mark the IDA MCP server as available so home/development/pi emits it.
  my.ida-mcp.enable = true;

  home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ida-pro
  ];
}
