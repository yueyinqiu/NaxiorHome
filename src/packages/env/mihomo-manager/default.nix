{ pkgs, config, ... }: {
  home-manager-mihomo-manager.enable = true;
  my.packages.mihomo-tui = config.home-manager-mihomo-manager.mihomo-tui.package;
}
