{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:soopyc/nixos-hardware/9d1d3c914e2c951fbcad437d1faa9661af4ae44f";
    };
    # niri-flake.url = "github:sodiboo/niri-flake";
  };

  outputs = {self, nixpkgs, home-manager, nixos-hardware, ...}@inputs: {
      nixosConfigurations.krisk = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-hardware.nixosModules.apple-t2
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.krisk = ./home.nix;
          }
        ];
      };
    };
}
