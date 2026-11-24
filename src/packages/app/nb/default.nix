{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [ nixpak.nixpakModules.network ];

        app.package = pkgs.nb;
        app.binPath = "bin/nb";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          tmpfs = [
            "/etc/ssh"
            "/tmp"
          ];

          env.PATH = sloth.concat' "${pkgs.git}/bin:" (sloth.env "PATH");
          env.TMPDIR = "/tmp";

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/run/current-system"
            "${config.home.homeDirectory}/.nix-profile"
            "${config.home.homeDirectory}/.ssh"
            "${config.xdg.configHome}/git"
            (sloth.envOr "SSH_AUTH_SOCK" "/dev/null")
          ];
        };
      };
  };
in
{
  my.packages.nb = app.config.env;

  home.packages = [
    config.my.packages.nb
  ];
}