{ pkgs, ... }:
{
  programs.pi-coding-agent.extraPackages = [
    pkgs.python314
    pkgs.jq
  ];

  programs.pi-coding-agent.context = builtins.readFile ./agent.md;
}
