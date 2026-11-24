{ pkgs, config, ... }: {  
  my.packages.easytier = pkgs.easytier;

  home.packages = [
    config.my.packages.easytier
  ];
}
