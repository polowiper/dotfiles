{config, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "${config.var.gitUserName}";
      user.email = "${config.var.gitEmail}";
      init.defaultBranch = "main";
      color.ui = true;
      core.editor = "${config.home.sessionVariables.EDITOR}";
      credential.helper = "store";
      github.user = config.var.gitUserName;
      push.autoSetupRemote = true;
      help.autocorrect = 10;
    };

    # Files/Dirs that should not be tracked by Git.
    # This is nice because you won't have to manually add them to a .gitignore file. In some cases, like this dotfiles repo, you
    # wont need to create the .gitignore file at all, keeping things clean and simple.
    # They will be written to Git's config directory at: ~/.config/git/ignore
    ignores = [
      "target/"
      ".cache/"
      ".idea/"
      "*.elc"
      ".~lock*"
      "auto-save-list"
      "result"
      "result-*"

      # Web dev stuff
      "node_modules/"

      # Direnv stuff
      ".envrc"
      ".direnv/"

      # My TO-DO list
      ".TODO.md"
    ];
  };
}
