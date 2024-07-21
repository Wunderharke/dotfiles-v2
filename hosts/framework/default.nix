{
  pkgs,
  self,
  # inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "framework";
  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
  };
}
