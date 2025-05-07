{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nix-colors.url = "github:Misterio77/nix-colors";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixcord.url = "github:kaylorben/nixcord";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      anyrun,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      #Avalable options are ["niri" "river" "hyprland" "all"]
      window_manager = "hyprland";
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            systemName = "laptop";
            inherit inputs window_manager;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        pc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            systemName = "pc";
            inherit inputs window_manager;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
