{
  pkgs,
  config,
  ...
}: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -x PATH ${pkgs.coreutils}/bin $PATH
        set -x EDITOR nvim
        set -x VISUAL nvim
        set fish_greeting ""
      '';
      functions = {
        vpn = ''
          sudo ${pkgs.openconnect}/bin/openconnect \
            --user="$(cat ${config.sops.secrets."vpn_id".path})" \
            --passwd-on-stdin \
            --verbose \
            vpn.grenet.fr
        '';
        nd = ''
            function nd --description "nix develop"
              if test (count $argv) -gt 0
                  set language $argv[1]
                  set path "$HOME/nix-devshells/$language"

                  if test -d "$path"
                      echo "Found directory: $path"
                      nix develop "$path" -c fish
                  else
                      echo "$path not found. Running nix develop without a path."
                      nix develop -c fish
                  end
              else
                  nix develop -c $SHELL
              end
          end
        '';
        homelab_vpn = ''
          function vpntoggle --description "Toggle the Andromeda WireGuard VPN"
              if nmcli -t connection show Andromeda | string match -q "GENERAL.STATE:activated"
                  nmcli connection down Andromeda
              else
                  nmcli connection up Andromeda
              end
          end
        '';
      };

      shellAliases = {
        ll = "ls -l";
        la = "ls -la";

        #GIT STUFF
        ga = "git add";
        gc = "git commit";
        gd = "git diff";
        gl = "git log";
        gp = "git push origin main";
        gs = "git status";

        #ETC
        sl = "ls"; # FUCK SL
        rm = "${pkgs.srm}/bin/srm";
        c = "clear";
        cd = "z";
        nv = "nvim";
        f = "${pkgs.yazi-unwrapped}/bin/yazi";
        n = "${pkgs.fastfetch}/bin/fastfetch";

        # Nix
        ns = "nh os switch";
        hs = "nh home switch -t --impure";
        nlu = "nix flake lock --update-input";

        # Modern yuunix, uwu <3
        cat = "${pkgs.bat}/bin/bat";
        df = "${pkgs.duf}/bin/duf";
        tree = "${pkgs.eza}/bin/eza --git --icons --tree";
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    carapace = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
