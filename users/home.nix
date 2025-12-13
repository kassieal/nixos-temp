{lib, ...}: let
  inherit (lib) mkDefault;
in {
  programs.home-manager.enable = mkDefault true;
  programs.git.enable = mkDefault true;

  nixpkgs.config.allowUnfree = mkDefault true;

  home.stateVersion = mkDefault "25.05";
}
