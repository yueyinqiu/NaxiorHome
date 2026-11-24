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

        app.package = pkgs.git;
        app.binPath = "bin/git";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          tmpfs = [ "/etc/ssh" "/tmp" ];

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
            (sloth.envOr "VSCODE_GIT_IPC_HANDLE" "/dev/null")
          ];

          env = {
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.git = app.config.env;

  programs.git = {
    enable = true;
    package = config.my.packages.git;
    settings = {
      user = {
        name = "yueyinqiu";
        email = "me@yueyinqiu.top";
      };
      pull.rebase = true;
      alias = {
        ac = "!git add -A && git commit";
      };
    };
    lfs.enable = true;
  };
}