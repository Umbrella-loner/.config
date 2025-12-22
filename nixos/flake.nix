{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.doc = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit zen-browser; };  # Add this line
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.robin = {
            home.stateVersion = "25.11";
          };
        }
      ];
    };
  };
}
