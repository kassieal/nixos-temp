{
  config,
  options,
  lib,
  klib,
  inputs,
  ...
}: let
  inherit (lib) types mkOption listToAttrs map mkDefault mkMerge mkIf;
  inherit (klib) mk-homes all-modules-in-dir-rec mk-users mk-opt;

  cfg = config.modules.users;
in {
  options.modules = {
    users = mkOption {
      type = types.listOf (
        types.submodule {
	  options = {
	    name = mkOption {
	      type = types.str;
	    };
	    privileged = mkOption {
	      type = types.bool;
	      default = false;
	    };
	    config = mkOption {
	      type = types.nullOr types.path;
	      default = null;
	    };
	    password = mkOption {
	      type = types.nullOr types.path;
	      default = null;
	    };
	    extra-groups = mkOption {
	      type = types.listOf types.str;
	      default = [];
	    };
	  };
	}
      );
    };

    userDefaults = {
      extraGroups = mk-opt (types.listOf types.str) [] "Default Groups for All Users.";
    };
  };

  config = {
    users = {
      mutableUsers = false;
      users = mk-users config.modules.userDefaults.extraGroups cfg;
    };
  };
}
