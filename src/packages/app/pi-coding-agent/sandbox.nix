{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sandboxConfig = {
    enabled = true;
    network = {
      disabled = true;
      allowAllUnixSockets = true;
    };
    filesystem = {
      allowRead = [ ];
      denyRead = [ ];
      allowWrite = [ "/" ];
      denyWrite = [ "~/.pi/agent" ];
      allowDevices = [ "/dev/kvm" ];
    };
  };
in
{
  programs.pi-coding-agent.settings.packages = [
    "npm:@xzzpig/pi-sandbox"
  ];

  programs.pi-coding-agent.extraPackages = [
    pkgs.nodejs_latest
    pkgs.bubblewrap
    pkgs.socat
    pkgs.ripgrep
  ];

  home.file.".pi/agent/sandbox.json".source = jsonFormat.generate "pi-sandbox.json" sandboxConfig;
}
