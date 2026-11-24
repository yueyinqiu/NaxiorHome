{
  config,
  pkgs,
  ...
}:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = pkgs._7zip-zstd;
        app.binPath = "bin/7z";
        app.extraEntrypoints = [
          "/bin/7za"
          "/bin/7zr"
          "/bin/7zz"
        ];

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;
          network = false;

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              config.home.homeDirectory
            ]
            config.my.paths.s
          ];

          bind.ro = [ "/etc" ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages."7zip" = app.config.env;

  home.packages = [
    config.my.packages."7zip"
  ];
}