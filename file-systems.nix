{ config, pkgs, lib, ... }: 

{
  fileSystems."/data" =
    { 
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
      options = [ "nofail" ];
    };
}