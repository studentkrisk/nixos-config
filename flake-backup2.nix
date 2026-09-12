{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:NixOS/nixos-hardware";
    };

    flake-input-patcher = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jfly/flake-input-patcher";
    };

    niri-flake.url = "github:sodiboo/niri-flake";
  };

  outputs = unpatchedInputs:
    let
      patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;

      inputs = patcher.patch {
        inherit unpatchedInputs;
        flakePath = ./.;

        # No custom patch for now.
        patchSpec.nixos-hardware.patches = [ ];
      };
    in
    {
      nixosConfigurations.krisk = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          inputs.nixos-hardware.nixosModules.apple-t2
          ./configuration.nix
        ];
      };
    };
}
