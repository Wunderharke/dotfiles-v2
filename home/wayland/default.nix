{
  pkgs,
  lib,
  config,
  colors,
  inputs,
  ...
}:
# Wayland config
let
  _ = lib.getExe;

  ocrScript = pkgs.writeShellScriptBin "wl-ocr" ''
    ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard}/bin/wl-copy
    ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';
in {
  imports = [
    ../graphical/eww
    ./gtklock.nix
    ./hyprland
    ./sway.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # idle/lock
    swaybg
    swaylock-effects
    inputs.self.packages.${pkgs.system}.gtklock

    # utils
    ocrScript
    wl-clipboard
    wlr-randr
    wlogout
    wofi
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs = {
    obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];

    swaylock.settings = {
      image = "${config.xdg.configHome}/wallpaper.png";
      ignore-empty-password = true;
      clock = true;
      effect-blur = "30x3";
      font = "Roboto";
    };
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
