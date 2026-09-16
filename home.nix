{ config, pkgs, ... }:

{
  home.username = "krisk";
  home.homeDirectory = "/home/krisk";
  home.stateVersion = "26.05"; # dont mess with
  programs.home-manager.enable = true;
}
