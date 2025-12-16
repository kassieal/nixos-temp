{
  config,
  lib,
  klib,
  ...
}: let
  inherit (lib) mkIf mkDefault foldl' types;
  inherit (klib) mk-enable mk-opt;

  cfg = config.modules.system.filesystem.ephemeral-btrfs;
in {
  options.modules.system.filesystem.ephemeral-btrfs = { 
    enable = mk-enable false;
    device = mk-opt types.str "rotulus" "label of LUKS partition";
  };

  config = mkIf cfg.enable {
    boot.initrd = {
      enable = mkDefault true;
      systemd.enable = mkDefault true;
      supportedFilesystems = [ "btrfs" ];

      systemd.services.rollback = {
        description = "Rollback BTRFS root subvolume";
        wantedBy = [ "initrd.target" ];
        after = [
          "systemd-cryptsetup@${cfg.device}.service"
          "initrd-root-device.target"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = let
          users = foldl' (acc: x: "${acc} ${x.name}") "" config.modules.users;
        in ''
  	  mkdir /btrfs_tmp
          mount /dev/mapper/${cfg.device} /btrfs_tmp
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")

          # cache root
          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          # cache home
          if [[ -e /btrfs_tmp/old_homes ]]; then
            mkdir -p /btrfs_tmp/old_homes
            mv /btrfs_tmp/home "/btrfs_tmp/old_homes/$timestamp"
          fi

          # never guess what this one does :P
          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
          }

          # delete old saved roots
          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          # delete old saved homes
          for i in $(find /btrfs_tmp/old_homes/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          # recreate subvolumes
          btrfs subvolume create /btrfs_tmp/root
          btrfs subvolume create /btrfs_tmp/home

          btrfs subvolume snapshot /btrfs_tmp/persist "/btrfs_tmp/old_persist/$timestamp"

          for i in $(find /btrfs_tmp/old_persist/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          umount /btrfs_tmp
        '';
      };
    };
  };
}
