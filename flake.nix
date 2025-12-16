{
  description = "Kassie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs @ {
    self,
    nixpkgs, 
    ...
  }: let
    lib = nixpkgs.lib;
    klib = import ./lib {inherit lib inputs;};
    module-paths = klib.all-modules-in-dir-rec ./modules/nixos;
  in {
    lib = lib;
    klib = klib;

    nixosConfigurations =
      klib.mk-hosts {inherit inputs klib;} module-paths ./hosts;
  };
}
