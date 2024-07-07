{
  pkgs,
  lib,
  ...
}: let
  inherit (import ./options.nix) dotfilesDir userName;
in {
  programs = {
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true; 
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    nushell = {
      enable = true;
      shellAliases = let
        g = lib.getExe pkgs.git;
      in {
        # Git
        ga = "${g} add";
        gc = "${g} commit";
        gd = "${g} diff";
        gl = "${g} log";
        gs = "${g} status";
        gp = "${g} push origin main";

        # ETC.
        c = "clear";
        cd = "z";
        f = "${pkgs.yazi-unwrapped}/bin/yazi";
        la = "ls -la";
        ll = "ls -l";
        n = "${pkgs.nitch}/bin/nitch";
        nv = "nvim";

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

      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = ''"  "'';
        PROMPT_INDICATOR_VI_NORMAL = ''"∙ "'';
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        DIRENV_LOG_FORMAT = ''""''; # make direnv quiet
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
        EDITOR = ''"nvim"'';
      };
      
     configFile.text = ''
    let dark_theme = {
      # color for nushell primitives
      separator: white
      leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
      header: green_bold
      empty: blue
      # Closures can be used to choose colors for specific values.
      # The value (in this case, a bool) is piped into the closure.
      # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
      bool: light_cyan
      int: white
      filesize: cyan
      duration: white
      date: purple
      range: white
      float: white
      string: white
      nothing: white
      binary: white
      cell-path: white
      row_index: green_bold
      record: white
      list: white
      block: white
      hints: dark_gray
      search_result: { bg: red fg: white }
      shape_and: purple_bold
      shape_binary: purple_bold
      shape_block: blue_bold
      shape_bool: light_cyan
      shape_closure: green_bold
      shape_custom: green
      shape_datetime: cyan_bold
      shape_directory: cyan
      shape_external: cyan
      shape_externalarg: green_bold
      shape_external_resolved: light_yellow_bold
      shape_filepath: cyan
      shape_flag: blue_bold
      shape_float: purple_bold
      # shapes are used to change the cli syntax highlighting
      shape_garbage: { fg: white bg: red attr: b}
      shape_globpattern: cyan_bold
      shape_int: purple_bold
      shape_internalcall: cyan_bold
      shape_keyword: cyan_bold
      shape_list: cyan_bold
      shape_literal: blue
      shape_match_pattern: green
      shape_matching_brackets: { attr: u }
      shape_nothing: light_cyan
      shape_operator: yellow
      shape_or: purple_bold
      shape_pipe: purple_bold
      shape_range: yellow_bold
      shape_record: cyan_bold
      shape_redirection: purple_bold
      shape_signature: green_bold
      shape_string: green
      shape_string_interpolation: cyan_bold
      shape_table: blue_bold
      shape_variable: purple
      shape_vardecl: purple
      shape_raw_string: light_purple
    }

    $env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }

    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
        trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
        }
        header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

    explore: {
        status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" },
        command_bar_text: { fg: "#C4C9C6" },
        highlight: { fg: "black", bg: "yellow" },
        status: {
            error: { fg: "white", bg: "red" },
            warn: {}
            info: {}
        },
        table: {
            split_line: { fg: "#404040" },
            selected_cell: { bg: light_blue },
            selected_row: {},
            selected_column: {},
        },
    }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "plaintext" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
            max_results: 10 # setting it lower can improve completion performance at the cost of omitting some options
            completer: null # check 'carapace_completer' above as an example
        }
        use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }

    filesize: {
        metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }

    cursor_shape: {
        emacs: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    color_config: $dark_theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
    use_grid_icons: true
    footer_mode: "25" # always, never, number_of_rows, auto
    float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: $env.EDITOR # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: vi # emacs, vi

    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol: true # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals: false # true enables highlighting of external commands in the repl resolved by which.
    recursion_limit: 50 # the maximum number of times nushell allows recursion before stopping it

    plugins: {} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.

    plugin_gc: {
        # Configuration for plugin garbage collection
        default: {
            enabled: true # true to enable stopping of inactive plugins
            stop_after: 10sec # how long to wait after a plugin is inactive to stop it
        }
        plugins: {
            # alternate configuration for specific plugins, by name, for example:
            #
            # gstat: {
            #     enabled: false
            # }
        }
    }

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }

    menus: [
        # Configuration for default nushell menus
        # Note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: ""
            type: {
                layout: columnar
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text: green
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: false
            marker: ""
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: completion_previous_menu
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menuprevious }
        }
        {
            name: open_command_editor
            modifier: control
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: { send: openeditor }
        }
        {
            name: move_up
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    { send: menuup }
                    { send: up }
                ]
            }
        }
        {
            name: move_down
            modifier: none
            keycode: down
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    { send: menudown }
                    { send: down }
                ]
            }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    { send: menuleft }
                    { send: left }
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: none
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    { send: historyhintcomplete }
                    { send: menuright }
                    { send: right }
                ]
            }
        }
        {
            name: move_one_word_left
            modifier: control
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movewordleft }
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: control
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movewordright }
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: backspace
            mode: [emacs, vi_insert]
            event: { edit: backspaceword }
        }
        {
            name: move_left
            modifier: none
            keycode: backspace
            mode: vi_normal
            event: { edit: moveleft }
        }
      ]
    }
    def nd [language: string] {
          nix develop $"/home/polo/nix-devshells/($language)" -c $env.SHELL
        }
   '';

    };
  };
}
