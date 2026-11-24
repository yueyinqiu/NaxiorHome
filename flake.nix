{
  nixConfig = {
    extra-substituters = [
      "https://yueyinqiu.cachix.org"
    ];
  };

  inputs = {
    import-tree.url = "github:denful/import-tree";

    naxior.url = "github:yueyinqiu/Naxior";
    nixpkgs.follows = "naxior/nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    nixpak.url = "github:nixpak/nixpak";
    home-manager-mihomo-manager.url = "github:MihomoManager/HomeManagerMihomoManager";
    home-manager-vscode-server-machine-settings.url = "github:yueyinqiu/HomeManagerVscodeServerMachineSettings";
    nix-airgap.url = "github:bitbloxhub/nix-airgap";
  };

  outputs = inputs: {
    homeConfigurations."yueyinqiu@naxior" =
      let
        system = "x86_64-linux";
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          nixpak = inputs.nixpak;
          nix-airgap = inputs.nix-airgap.packages.${system};
        };
        modules = [
          inputs.home-manager-mihomo-manager.homeManagerModules.home-manager-mihomo-manager
          inputs.home-manager-vscode-server-machine-settings.homeManagerModules.home-manager-vscode-server-machine-settings
          (inputs.import-tree ./src)
        ];
      };

    devShells = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system: {
      default = import ./dev {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    });
  };
}