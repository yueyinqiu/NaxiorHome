{ config, lib, pkgs, ... }:
let
  proxyPort = 25545;
  proxy = "http://127.0.0.1:${toString proxyPort}/";

  switchboardLogin = pkgs.writeShellApplication {
    name = "nix-daemon-proxy-switchboard-login";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      switcher=/run/current-system/sw/bin/nix-daemon-proxy-switchboard
      port=${toString proxyPort}

      first=$("$switcher" status 2>/dev/null | head -n1)
      if [ "$first" = Direct ]; then
        "$switcher" http -H 127.0.0.1 -P "$port"
      fi
    '';
  };
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

  programs.bash.profileExtra = lib.mkAfter ''
    ${switchboardLogin}/bin/nix-daemon-proxy-switchboard-login &>/dev/null || true
  '';
}