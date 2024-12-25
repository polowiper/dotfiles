{pkgs, ...}:
{
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
        nd = ''
          function nd --description "nix develop"
            if test (count $argv) -gt 0
                set language $argv[1]
                set path "$HOME/nix-devshells/$language"

                if test -d "$path"
                    echo "Found directory: $path"
                    nix develop "$path" -c $SHELL
                else
                    echo "$path not found. Running nix develop without a path."
                    nix develop -c $SHELL
                end
            else
                nix develop -c $SHELL
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
          c = "clear";
          cd = "z";
          nv = "nvim";
          f = "${pkgs.yazi-unwrapped}/bin/yazi";
          n = "${pkgs.nitch}/bin/nitch";

          # Nix
          ns = "nh os switch";
          hs = "nh home switch";
          nlu = "nix flake lock --update-input";

          # Modern yuunix, uwu <3
          cat = "${pkgs.bat}/bin/bat";
          df = "${pkgs.duf}/bin/duf";
          find = "${pkgs.fd}/bin/fd";
          grep = "${pkgs.ripgrep}/bin/rg";
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
