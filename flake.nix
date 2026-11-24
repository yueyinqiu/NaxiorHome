{
  nixConfig = {
    extra-substituters = [
      "https://yueyinqiu.cachix.org"
    ];
  };

  inputs = {
    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak.url = "github:nixpak/nixpak";
    home-manager-mihomo-manager.url = "github:MihomoManager/HomeManagerMihomoManager";
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