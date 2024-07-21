{
  imports = [
    # editors
    ../../editors/helix
    ../../editors/neovim

    # programs
    ../../programs
    ../../programs/wayland

    # services
    ../../services/ags
    ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix

    # system services
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 2256x1504, auto, 1.6"
    ];

    input = {
      repeat_rate = 40;
      repeat_delay = 200;
      follow_mouse = 3;
      touchpad.natural_scroll = true;
      sensitivity = 0.1;
    };
  };
}
