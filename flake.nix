{
  description = "Personal package management with home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."noppo190" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      modules = [{
        nixpkgs.config.allowUnfree = true;

        home.username = "noppo";
        home.homeDirectory = "/home/noppo";
        home.stateVersion = "25.11";

        # インストールしたいパッケージをここに追加
        home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
          # 基本的な開発ツール
          neovim
          git
          curl
          wget

          # シェルツール
          fish
          tmux
          htop
          lazygit

          # モダンなCLIツール
          ripgrep  # 高速なgrep代替
          fd       # 高速なfind代替
          bat      # catの改良版
          eza      # lsの改良版

          # その他便利ツール
          jq       # JSONパーサー

          # ここに必要なパッケージを追加してください
          # パッケージ検索: https://search.nixos.org/packages
          # または: nix search nixpkgs パッケージ名
        ];

        # プログラム固有の設定（オプション）
        # programs.bash = {
        #   enable = true;
        #   shellAliases = {
        #     lg = "lazygit";
        #     update = "home-manager switch --flake ~/dotfiles";
        #   };
        # };

        # home-managerの自己管理を有効化
        programs.home-manager.enable = true;
      }];
    };
  };
}
