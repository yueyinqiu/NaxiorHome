{ pkgs, config, ... }:
let
  proxy = http://127.0.0.1:25545/;
in
{
  home-manager-mihomo-manager.enable = true;
  my.packages.mihomo-tui = config.home-manager-mihomo-manager.mihomo-tui.package;

  home.sessionVariables = {
    all_proxy=proxy;
    http_proxy=proxy;
    https_proxy=proxy;
    ALL_PROXY=proxy;
    HTTP_PROXY=proxy;
    HTTPS_PROXY=proxy;
  };

    systemd.user.services.switch-nix-daemon-proxy-if-needed = {
    Unit = {
      Description = "Start nix-daemon-proxy-switchboard if not already running";
    };
    Service = {
      Type = "oneshot";
      script = ''
        status="$(${switchboard} status --json)"
        type="$(echo "$status" | ${pkgs.jq}/bin/jq -r '.Type')"

        if [ "$type" = "null" ]; then
          exec ${switchboard} http -H 127.0.0.1 -P 25545
        fi
        '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
