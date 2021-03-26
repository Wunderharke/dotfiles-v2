{ config, pkgs, ... }:

# graphical session configuration
# includes programs and services that work on both Wayland and X

{
  imports = [
    # base config
    ./minimal.nix

    # emacs config
    ./editors/emacs.nix

    # files to link in ~
    ./modules/files.nix

    # mail config
    ./modules/mail.nix

    # Wayland config
    ./modules/wayland.nix

    # X config
    ./modules/xsession.nix
  ];

  # install programs
  home.packages = with pkgs; [
    # audio
    carla
    pavucontrol
    playerctl
    pulsemixer
    # games
    lutris
    # messaging
    discord
    element-desktop
    lightcord
    mumble
    tdesktop
    zoom-us
    # music
    spotify
    # torrents
    transmission-remote-gtk
    # video
    droidcam
    jellyfin-mpv-shim
    # misc
    cached-nix-shell
    discord-rpc # RPC interfacing lib
    dunst # for dunstctl
    freerdp # for MS Office
    piper # configure mouse
    scrcpy # mirror Android screen
    ueberzug # image display in terminals
  ];

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    theme.name = "Orchis-dark-compact";
    theme.package = pkgs.orchis;
  };

  # programs
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = true;
      window.padding = {
        x = 5;
        y = 5;
      };
      scrolling.history = 10000;
      font = let font = "JetBrainsMono Nerd Font";
      in {
        normal.family = font;
        bold.family = font;
        italic.family = font;
        size = 11.0;
      };
      draw_bold_text_with_bright_colors = true;
      colors = {
        primary = {
          background = "0x16161c";
          foreground = "0xfdf0ed";
        };
        normal = {
          black = "0x232530";
          red = "0xe95678";
          green = "0x29d398";
          yellow = "0xfab795";
          blue = "0x26bbd9";
          magenta = "0xee64ae";
          cyan = "0x59e3e3";
          white = "0xfadad1";
        };
        bright = {
          black = "0x2e303e";
          red = "0xec6a88";
          green = "0x3fdaa4";
          yellow = "0xfbc3a7";
          blue = "0x3fc6de";
          magenta = "0xf075b7";
          cyan = "0x6be6e6";
          white = "0xfdf0ed";
        };
      };
      background_opacity = 0.7;
      live_config_reload = true;
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.mihai.name = "mihai";
  };

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = { ncmpcpp_directory = "~/.local/share/ncmpcpp"; };
  };

  # add more plugins on top of ./minimal.nix ones
  programs.neovim.plugins = (with pkgs.vimPlugins; [
    coc-prettier
    coc-snippets
    latex-live-preview
    vimsence
  ]);

  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls = [{
      title = "Drew DeVault's Blog";
      url = "https://drewdevault.com/blog/index.xml";
    }];
  };

  programs.texlive = {
    enable = false;
    package = pkgs.texlive.combined.scheme-basic;
  };

  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor = "#FDF0ED";
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";
      default-fg = "#FDF0ED";
    };
  };

  # services
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      zeroconf_enabled "yes"
      zeroconf_name "MPD @ %h"
      input {
        plugin "curl"
      }
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format    "48000:16:2"
      }
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';
    network.listenAddress = "any";
    network.startWhenNeeded = true;
  };

  services.mpdris2.enable = true;

  services.playerctld.enable = true;

  services.syncthing.enable = true;

  services.udiskie.enable = true;

  #services.xcape = {
  #  enable = true;
  #  mapExpression = { Caps_Lock = "Escape"; };
  #  timeout = 100;
  #};
}
