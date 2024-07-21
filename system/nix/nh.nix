{pkgs, ...}: {
  # nh default flake
  environment.variables.FLAKE = "/home/falk/Documents/code/dotfiles";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };
}
