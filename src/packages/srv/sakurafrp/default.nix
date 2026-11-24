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
      RuntimeDirectory = "sakurafrp";
      WorkingDirectory = "%t/sakurafrp";
      EnvironmentFile = "${config.xdg.configHome}/sakurafrp/env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.sakurafrp-frpc}/bin/frpc"
        "--no_check_update"
        "--encrypt_dns"
        "--fetch_config"
      ] + " $SAKURAFRP_ARGUMENT_FETCH_CONFIG";
      Restart = "on-failure";
    };
  };
}