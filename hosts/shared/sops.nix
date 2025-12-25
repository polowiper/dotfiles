{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  environment.systemPackages = with pkgs; [
    sops
  ];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "eduroam_id" = {};
      "eduroam_pswd" = {};
      "vpn_id" = {};
    };
    age.keyFile = "/home/polo/.config/sops/age/keys.txt";
  };
}
