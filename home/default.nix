{
  pkgs,
  config,
  colors,
  inputs,
  ...
}:
# graphical session configuration
# includes programs and services that work on both Wayland and X
let
  inherit (colors) xcolors;
in {
  imports = [
    ./cli.nix # base config
    ./terminals.nix
  ];

  home.packages = with pkgs; let
    teams-chromium = makeDesktopItem {
      name = "Teams";
      desktopName = "Teams";
      genericName = "Microsoft Teams";
      exec = "${config.programs.chromium.package}/bin/chromium --app=\"https://teams.live.com\"";
      icon = "teams";
      categories = ["Network" "InstantMessaging"];
      mimeTypes = ["x-scheme-handler/teams"];
    };
    discord-chromium = makeDesktopItem {
      name = "discord";
      desktopName = "Discord";
      genericName = "Discord";
      exec = "${config.programs.chromium.package}/bin/chromium --app=\"https://discord.com/channels/@me\"";
      icon = "discord";
      categories = ["Network" "InstantMessaging"];
      mimeTypes = ["x-scheme-handler/discord"];
    };
  in [
    # archives
    p7zip
    unrar
    # file downloaders
    yt-dlp
    # file managers
    file
    gh
    # messaging
    (discord-plugged.override {
      plugins = [inputs.discord-tweaks];
    })
    discord-chromium
    tdesktop
    teams
    teams-chromium
    # torrents
    transmission-remote-gtk
    # misc
    libnotify
    xournalpp
  ];

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Orchis-purple-dark-compact";
      package = pkgs.orchis-theme.override {tweaks = ["primary" "compact"];};
    };
  };

  programs = {
    chromium = {
      enable = true;
      commandLineArgs = ["--ozone-platform-hint=auto"];
      extensions = [{id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}];
    };

    firefox = {
      enable = true;
      profiles.mihai = {};
    };

    git = {
      enable = true;
      delta.enable = true;
      ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
      signing = {
        key = "5899325F2F120900";
        signByDefault = true;
      };
      userEmail = "fufexan@protonmail.com";
      userName = "Mihai Fufezan";
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
      settings = {PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";};
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };

    zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-darkcolor = "#${xcolors.base00}";
        recolor-lightcolor = "rgba(0,0,0,0)";
        default-bg = "rgba(0,0,0,0.7)";
        default-fg = "#${xcolors.base06}";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      pinentryFlavor = "gnome3";
      sshKeys = ["73D1C4271E8C508E1E55259660C94BE828B07738"];
    };

    syncthing.enable = true;

    udiskie.enable = true;
  };
}
