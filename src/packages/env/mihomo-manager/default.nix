{ pkgs, config, ... }: {
  home-manager-mihomo-manager.enable = true;

  # my.packages.mihomo-tui = pkgs.callPackage ./_mihomo-tui.nix { };
  # home-manager-mihomo-manager.mihomo-tui.package = config.my.packages.mihomo-tui;
  my.packages.mihomo-tui = config.home-manager-mihomo-manager.mihomo-tui.package;
}
