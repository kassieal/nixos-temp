{
  inputs,
  config,
  lib,
  klib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ../users
    # home-manager
  ];

  nix.settings = {
    experimental-features = mkDefault "nix-command flakes";
    auto-optimise-store = mkDefault true;
  };

  nixpkgs = {
    config.allowUnfree = mkDefault true;
    hostPlatform.system = "x86_64-linux";
  };

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
  ];

  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;
  system.stateVersion = "25.05"; # TODO should this be system wide?
}
