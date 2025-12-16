{
  config,
  options,
  lib,
  klib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (klib) mk-enable;
  cfg = config.modules.impermanence;
in {
  imports = [ inputs.impermanence.homeManagerModules.impermanence ];
  
  options.modules.impermanence = {
    enable = mk-enable true;
  };
  
  config = mkIf cfg.enable {
    home.persistence = {
      "/persist/home/${config.home.username}" = {
        directories = [
          "dotfiles"
          "Pictures"
          "Documents"
          "Music"
          ".gnupg"
          ".ssh"
          "projects"          
        ];
        allowOther = true;
      };
    };
  };
}
