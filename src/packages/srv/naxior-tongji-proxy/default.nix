{ config, lib, ... }: {
  xdg.configFile."naxior-tongji-proxy/env.example".text = ''
    ET_NETWORK_SECRET="XXXXXX"
  '';
  
  home-manager-mihomo-manager.instances.naxior-tongji-proxy = {
    port = 58657;
    configuration = ./proxy;
  };

  systemd.user.services.naxior-tongji-proxy-easytier = {
    Unit = {
      Description = "EasyTier network for naxior";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      EnvironmentFile = "${config.xdg.configHome}/naxior-tongji-proxy/env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.easytier}/bin/easytier-core"
        "-c"
        ./configuration.toml
      ];
      Restart = "on-failure";
    };
  };
}
