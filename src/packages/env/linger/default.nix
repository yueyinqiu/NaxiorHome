{ config, lib, pkgs, ... }: {
  systemd.user.services.linger = {
    Unit.Description = "Enable linger for this user";
    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe' pkgs.systemd "loginctl"} enable-linger ${config.home.username}";
    };
    Install.WantedBy = [ "default.target" ];
  };
}