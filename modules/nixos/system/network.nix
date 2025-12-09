{
  config,
  options,
  lib,
  klib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (klib) mk-enable;
  
  cfg = config.modules.system.network;
in {
  options.modules.system.network = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    modules.userDefaults.extraGroups = [ "networkmanager" ];
  };
}
