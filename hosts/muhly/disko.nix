{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
	device = "/dev/nvme0n1";
	content = {
	  type = "gpt";
	  partitions = {
	    ESP = {
	      label = "NIXBOOT";
	      name = "ESP";
	      size = "512M";
	      type = "EF00";
	      content = {
	        type = "filesystem";
		format = "vfat";
		mountpoint = "/efi";
		mountOptions = [
		  "defaults"
		];
	      };
	    };
	    luks = {
	      size = "100%";
	      label = "NIXLUKS";
	      content = {
	        type = "luks";
		name = "rotulus";
		extraOpenArgs = [
		  "--perf-no_read_workqueue"
		  "--perf-no_write_workqueue"
		];
		settings = {
		  allowDiscards = true;
		};
		content = {
		  type = "btrfs";
		  extraArgs = [ "-L" "NIXROOT" "-f" ];
		  subvolumes = {
		    "/boot" = {
		      mountpoint = "/boot";
		      mountOptions = [ "subvol=boot" "compress=zstd" "noatime" ];
		    };
		    "/root" = {
		      mountpoint = "/";
		      mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
		    };
		    "/home" = {
		      mountpoint = "/home";
		      mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
		    };
		    "/nix" = {
		      mountpoint = "/nix";
		      mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
		    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                    };
		    "/log" = {
		      mountpoint = "/var/log";
		      mountOptions = [ "subvol=log" "compress=zstd" "noatime" ];
		    };
		    "/swap" = {
		      mountpoint = "/swap";
		      swap.swapfile.size = "16G";
		    };
		  };
		};
	      };
	    };
	  };
	};
      };
    };
  };
}
