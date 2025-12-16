{
  config,
  options,
  lib,
  klib,
  inputs,
  ...
}: let
  inherit (lib) mkIf types mkOption;
  inherit (klib) mk-enable;

  cfg = config.modules.system.filesystem.disko;
in {
  imports = [ inputs.disko.nixosModules.disko ];

  options.modules.system.filesystem.disko = {
    enable = mk-enable false;
    config-file = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    inherit (import cfg.config-file) disko;

    fileSystems = {
      "${config.modules.system.filesystem.impermanence.persist-dir}".neededForBoot = true;
      "/var/log".neededForBoot = true;
      "/home".neededForBoot = true;
    };
  };
} 
