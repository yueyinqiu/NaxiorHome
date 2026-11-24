{
  config,
  nixpak,
  pkgs,
  ...
}:
{
  my.packages.git = config.programs.git.package;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "yueyinqiu";
        email = "me@yueyinqiu.top";
      };
      pull.rebase = true;
      alias = {
        ac = "!git add -A && git commit";
      };
    };
    lfs.enable = true;
  };
}