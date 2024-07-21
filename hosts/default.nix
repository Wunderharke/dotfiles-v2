{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    framework = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./framework
          #"${mod}/core/lanzaboote.nix"

          "${mod}/programs/hyprland.nix"

          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.falk.imports = homeImports."falk@framework";
      	      backupFileExtension = "bak";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
