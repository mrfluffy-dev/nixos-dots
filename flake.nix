{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    nix-colors.url = "github:Misterio77/nix-colors";
    hyprland.url = "github:/hyprwm/Hyprland/?ref=04ac46c54357278fc68f0a95d26347ea0db99496";
    #"github:/hyprwm/Hyprland/?ref=9a09eac79b85c846e3a865a9078a3f8ff65a9259";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    dvd-zig.url = "github:mrfluffy-dev/dvd-zig";
    way-inhibitor.url = "git+https://git.mrfluffy.xyz/mrfluffy/way-inhibitor.git";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      anyrun,
      ...
    }@inputs:
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
    in
    {

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
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/river/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        qtile = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/qtile/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
