{
  inputs,
  pkgs,
  ...
}: {
  imports = [ ./hardware-configuration.nix ];

  modules = {
    system = {
      boot.systemd-boot.enable = true;
      network.enable = true;

      filesystem = {
        disko = {
	  enable = true;
	  config-file = ./disko.nix;
	};
      };
    };

    users = [
      {
        name = "kassie";
	privileged = true;
	# config = "${inputs.self.outPath}/users/kassie";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    # packages
  ];
}
