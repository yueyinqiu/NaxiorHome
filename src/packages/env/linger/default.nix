{ ... }:
{
  systemd.user.services.enable-linger = {
    Unit = {
      Description = "enable linger";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/loginctl enable-linger yueyinqiu";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
