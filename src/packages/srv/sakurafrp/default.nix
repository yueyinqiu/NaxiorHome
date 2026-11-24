{ config, sakurafrp-frpc, lib, ... }: {
  my.packages.sakurafrp-frpc = sakurafrp-frpc;

  xdg.configFile."sakurafrp/env.example".text = ''
    SAKURAFRP_ARGUMENT_FETCH_CONFIG="XXXXXX"
  '';

  systemd.user.services.sakurafrp = {
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
        "--fetch_config"
        "$SAKURAFRP_ARGUMENT_FETCH_CONFIG"
        "--no_check_update"
        "--encrypt_dns"
      ];
      Restart = "on-failure";
    };
  };
}