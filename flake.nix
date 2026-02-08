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
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # 共通のパッケージとモジュール設定
      commonModule = {
        home.stateVersion = "25.11";

        home.packages = with pkgs; [
          # パッケージ検索: https://search.nixos.org/packages
          # または: nix search nixpkgs パッケージ名
          # 基本的な開発ツール
          neovim
          git
          curl
          wget

          # シェルツール
          fish
          zellij
          htop
          lazygit

          # モダンなCLIツール
          ripgrep  # 高速なgrep代替
          fd       # 高速なfind代替
          bat      # catの改良版
          eza      # lsの改良版

          # その他便利ツール
          jq       # JSONパーサー
        ];

        programs.home-manager.enable = true;
      };

      # ホスト固有の設定を生成するヘルパー関数
      mkHome = { username, homeDirectory }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          commonModule
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

      homeConfigurations."remote-dev" = mkHome {
        username = "developer";
        homeDirectory = "/home/developer";
      };
    };
}
