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

        app.package = pkgs.pi-coding-agent;
        app.binPath = "bin/pi";

        dbus.enable = false;

        bubblewrap = {
          sharePgid = true;

          tmpfs = [ 
            "/tmp" 
            "/etc/ssh"
          ];

          bind.dev = [ "/dev/kvm" ];

          bind.rw = [
            "${config.home.homeDirectory}/.pi/agent"
            config.my.paths.s
          ];

          bind.ro = [
            "/nix"
            "/usr"
            "/etc"
            "/bin"
            "/run/current-system"
            "${config.xdg.stateHome}/nix/profiles"
            "${config.home.homeDirectory}/.nix-profile"
            "${config.home.homeDirectory}/.ssh"
            "${config.xdg.configHome}/git"
          ];

          env = {
            PI_CLIPBOARD_OSC52 = "1";
            TMPDIR = "/tmp";
          };
        };
      };
  };
in
{
  my.packages.pi-coding-agent = app.config.env;

  programs.pi-coding-agent = {
    enable = true;
    package = config.my.packages.pi-coding-agent;
  };
}