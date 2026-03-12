{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.modelsim;

  # Layer 2: Get the wrappers for individual ModelSim binaries
  modelsimWrappers = pkgs.callPackage ./modelsim-wrappers.nix {};
in {
  options.programs.modelsim = {
    enable = mkEnableOption "ModelSim FPGA simulator (free ASE version)";

    acceptEula = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Accept the Intel ModelSim End User License Agreement.

        The .run installer automatically accepts the EULA during extraction.
        Set to false to explicitly opt-out (though this is rarely needed).

        By enabling this module, you acknowledge acceptance of Intel's EULA.
      '';
    };

    licenseFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        License file content for ModelSim-PE (Premium Edition).

        Leave null to use ModelSim-ASE (free auto-evaluating version).

        If provided, this content will be written to ~/.config/modelsim/license.dat
         and the SALT_LICENSE_SERVER environment variable will be set accordingly.

        This is typically multi-line content from your ModelSim-PE license file.
      '';
      example = ''
        # Example ModelSim-PE license file
        LICENSE line1
        LICENSE line2
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure acceptEula is true (or fail with clear message)
    assertions = [
      {
        assertion = cfg.acceptEula;
        message = "ModelSim EULA acceptance required: set programs.modelsim.acceptEula = true";
      }
    ];

    # Add the ModelSim command wrappers to home packages with high priority
    # This overrides the versions provided by Quartus Prime Lite
    # Our wrappers properly set up the FHS environment for ModelSim
    home.packages = [
      (lib.hiPrio modelsimWrappers)
    ];

    # Write license file if provided
    home.file.".config/modelsim/license.dat" = mkIf (cfg.licenseFile != null) {
      text = cfg.licenseFile;
    };

    # Set SALT_LICENSE_SERVER environment variable if license is configured
    home.sessionVariables = mkIf (cfg.licenseFile != null) {
      SALT_LICENSE_SERVER = "${config.home.homeDirectory}/.config/modelsim/license.dat";
    };
  };
}
