{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix";
    nix-colors.url = "github:Misterio77/nix-colors";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixcord.url = "github:kaylorben/nixcord";
    niri.url = "github:sodiboo/niri-flake";
    caelestia.url = "github:caelestia-dots/shell";
    caelestia-cli.url = "github:caelestia-dots/cli";
    quickshell = {
      # remove ?ref=v0.1.0 to track the master branch
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qs-qml = {
      url = "git+https://git.outfoxxed.me/outfoxxed/nix-qml-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-hyprsplit = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

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
      pkgs = nixpkgs.legacyPackages.${system};
      #Avalable options are ["niri" "river" "hyprland" "all"]
      window_manager = "hyprland";
    in
    {
      nixosConfigurations = {
        mrfluffyLaptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            systemName = "laptop";
            inherit inputs window_manager;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
	    inputs.nix-index-database.nixosModules.nix-index
          ];
        };
        mrfluffyPC = nixpkgs.lib.nixosSystem {
          specialArgs = {
            systemName = "pc";
            inherit inputs window_manager;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
	    inputs.nix-index-database.nixosModules.nix-index
          ];
        };
      };
    };
}
