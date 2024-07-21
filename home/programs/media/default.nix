{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol

    # audio
    amberol
    tidal-hifi

    # images
    loupe

    # videos
    celluloid
  ];
}
