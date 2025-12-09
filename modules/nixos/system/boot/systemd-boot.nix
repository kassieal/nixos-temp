{
  config,
  lib,
  klib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (klib) mk-enable;

  cfg = config.modules.system.boot.systemd-boot;
in {
  options.modules.system.boot.systemd-boot = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = mkDefault true;

      loader = {
        systemd-boot = {
	  enable = mkDefault true;
	  configurationLimit = mkDefault 8;
	};

	efi = {
	  canTouchEfiVariables = mkDefault true;
	  efiSysMountPoint = mkDefault "/efi";
	};
      };
    };
  };
}
