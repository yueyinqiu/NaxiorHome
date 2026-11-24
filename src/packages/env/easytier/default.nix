{ pkgs, config, lib, ... }: {  
  my.packages.easytier = pkgs.easytier;

  xdg.configFile."easytier/default.env.example".text = ''
    ET_NETWORK_SECRET="XXXXXX"
  '';
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
      EnvironmentFile = "${config.xdg.configHome}/easytier/default.env";
      ExecStart = lib.hm.strings.escapeSystemdExecArgs [
        "${config.my.packages.easytier}/bin/easytier-core"
        "-c"
        ./easytier-naxior.toml
      ];
      Restart = "on-failure";
    };
  };
}
