{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    nix-colors.url = "github:Misterio77/nix-colors";
    hyprland.url = "github:/hyprwm/Hyprland/?ref=7230fe53cf3cabc9be8821784fb79507fee4c9e9";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, anyrun, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = import nixpkgs-stable {
        system = "${system}";
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in {

      nixosConfigurations = {
        hyprland = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-stable;
          };
          modules = [
            ./hosts/hyprland/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        river = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/river/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        qtile = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/qtile/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
