# Reverse-engineering / binary-exploitation tooling.
{
  pkgs,
  inputs,
  ...
}: let
  # pwndbg's flake applies a Darwin-only overlay through the deprecated
  # `stdenv.isDarwin` alias, and its build helpers read the deprecated
  # `stdenv.isDarwin`/`stdenv.isLinux` aliases. Re-expose those aliases from
  # `hostPlatform` and instantiate the package directly so that evaluating it
  # no longer prints deprecation warnings.
  hostAliases = [
    "isDarwin"
    "isLinux"
    "isSunOS"
    "isCygwin"
    "isBSD"
    "isFreeBSD"
    "isOpenBSD"
    "isi686"
    "isx86_32"
    "isx86_64"
    "is32bit"
    "is64bit"
    "isAarch32"
    "isAarch64"
    "isMips"
    "isBigEndian"
  ];
  fixStdenv = s:
    s
    // builtins.listToAttrs (
      map (name: {
        inherit name;
        value = builtins.getAttr name s.hostPlatform;
      })
      hostAliases
    )
    // {
      override = args: fixStdenv (s.override args);
    };
  # pwndbg 8.0.0 ships a capstone sdist that unconditionally builds a
  # `fuzz_disasm` target which does not link. Patch the target out of the
  # default build until it is fixed upstream.
  pwndbgCapstonePatch = pkgs.writeText "pwndbg-capstone-fuzz.patch" (
    builtins.concatStringsSep "\n" [
      "--- a/nix/pyenv.nix"
      "+++ b/nix/pyenv.nix"
      "@@ -207,6 +207,13 @@"
      "           nativeBuildInputs = old.nativeBuildInputs ++ ["
      "             cmake"
      "           ];"
      "+          # capstone's sdist unconditionally adds a `fuzz_disasm` executable"
      "+          # that does not link without a libFuzzer main. Keep it out of the"
      "+          # default build target."
      "+          postPatch = (old.postPatch or \"\") + ''"
      "+            substituteInPlace src/CMakeLists.txt \\"
      "+              --replace-fail 'add_executable(fuzz_disasm ' 'add_executable(fuzz_disasm EXCLUDE_FROM_ALL '"
      "+          '';"
      "         }"
      "       )"
      "     ) { };"
      ""
    ]
  );
  pwndbgSrc = pkgs.applyPatches {
    name = "pwndbg-patched";
    src = inputs.pwndbg.outPath;
    patches = [pwndbgCapstonePatch];
  };
  pwndbg = import "${pwndbgSrc}/nix/pwndbg.nix" {
    pkgs = pkgs.extend (_final: prev: {stdenv = fixStdenv prev.stdenv;});
    inputs =
      inputs.pwndbg.inputs
      // {
        self = pwndbgSrc;
      };
    groups = ["gdb"];
  };
in {
  home.packages = with pkgs; [
    binutils
    # `hcli` comes from `programs.ida-pro` (home/modding/ida.nix), which
    # installs it wrapped with IDADIR so `hcli plugin install` targets the
    # right IDA. Installing plain `pkgs.hcli` here too would collide in
    # `home-manager-path`.
    scrcpy
    android-tools
    apktool
    ghex
    httptoolkit-server
    httptoolkit
    wireshark
    ripgrep
    pwndbg
    unicorn
    capstone
    # python3Packages.qiling
    gdb
  ];
}
