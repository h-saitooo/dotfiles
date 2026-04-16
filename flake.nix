{
  description = "Personal package management with home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # 共通のパッケージとモジュール設定
      commonModule = pkgs: {
        home.stateVersion = "25.11";

        home.packages = with pkgs; [
          # パッケージ検索: https://search.nixos.org/packages
          # または: nix search nixpkgs パッケージ名
          # 基本的な開発ツール
          git
          curl
          wget

          # シェルツール
          fish
          htop
        ];

        programs.home-manager.enable = true;
      };

      # ホスト固有の設定を生成するヘルパー関数
      mkHome = { username, homeDirectory, system ? "x86_64-linux" }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (commonModule pkgs)
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };

    in {
      homeConfigurations."noppo" = mkHome {
        username = "noppo";
        homeDirectory = "/home/noppo";
      };

      homeConfigurations."raspberry" = mkHome {
        username = "noppo";
        homeDirectory = "/home/noppo";
        system = "aarch64-linux";
      };

      homeConfigurations."remote-dev" = mkHome {
        username = "developer";
        homeDirectory = "/home/developer";
      };
    };
}
