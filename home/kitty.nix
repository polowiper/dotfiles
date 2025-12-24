{config, ...}: {
  home.sessionVariables.TERMINAL = "kitty";


  programs.kitty = {
    enable = true;
    # Font is handled by stylix
    settings = {
      enable_audio_bell = "no";
      cursor_text_color = "background";
      window_padding_width = 4;
      listen_on = "unix:/tmp/kitty";
    };
  };
}
