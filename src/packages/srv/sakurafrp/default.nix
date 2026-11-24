{ config, sakurafrp-frpc, lib, ... }: {
  my.packages.sakurafrp-frpc = sakurafrp-frpc;

  xdg.configFile."sakurafrp/env.example".text = ''
    FRPC_TOKEN="XXXXXX"
  '';

  systemd.user.services.sakurafrp-frpc = {
    Unit = {
      Description = "SakuraFrp frpc client";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      EnvironmentFile = "${config.xdg.configHome}/sakurafrp/env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.sakurafrp-frpc}/bin/frpc"
        "-f"
        "$FRPC_TOKEN"
      ];
      Restart = "on-failure";
    };
  };
}