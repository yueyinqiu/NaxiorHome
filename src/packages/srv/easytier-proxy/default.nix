{ config, lib, ... }: {
  xdg.configFile."easytier-proxy/env.example".text = ''
    ET_NETWORK_SECRET="XXXXXX"
  '';
  
  home-manager-mihomo-manager.instances.easytier-proxy = {
    port = 16884;
    configuration = ./proxy;
  };

  systemd.user.services.easytier-naxior = {
    Unit = {
      Description = "EasyTier network for naxior";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      EnvironmentFile = "${config.xdg.configHome}/easytier-proxy/env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.easytier}/bin/easytier-core"
        "-c"
        ./configuration.toml
      ];
      Restart = "on-failure";
    };
  };
}
