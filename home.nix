{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      dog
      esptool
      fd
      httpie
      jq
      lazydocker
      lazygit
      minicom
      mtr
      nix-zsh-completions
      trippy
    ];
    username = "chris";
    homeDirectory = "/home/chris";
    stateVersion = "23.11";
    
    #Link dotfiles into place:
    #Neovim
#    file = {
#      ".config/nvim" = {
#        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/homemgr" ;
#        recursive = true;
#      };
#    };
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };
    eza.enable = true;
    fzf.enable = true;
    git = {
      enable = true;
        aliases = {
          amend = "commit -a --ammend";
          cob = "checkout -b";
        };
    };
    jq.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = ''
        -- NOTE: This will get the OS from Lua:
        -- print(vim.loop.os_uname().sysname)

        -- setup lazy.nvim
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        vim.opt.rtp:prepend(lazypath)

        -- hack to deal with bug in telescope-cheat.nvim
        -- https://github.com/nvim-telescope/telescope-cheat.nvim/issues/7
        local cheat_dbdir = vim.fn.stdpath "data" .. "/databases"
        if not vim.loop.fs_stat(cheat_dbdir) then
          vim.loop.fs_mkdir(cheat_dbdir, 493)
        end

        -- load additional settings
        require("config.vim-options")
        require("lazy").setup("plugins")

        -- tell sqlite.lua where to find the bits it needs
        vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'

      '';
      extraPackages = with pkgs; [
        gcc    # needed so treesitter can do compiling
        sqlite # needed by sqlite.lua used by telescope-cheat
      ];
      plugins = [ pkgs.vimPlugins.lazy-nvim ]; # let lazy.nvim manage every other plugin
    };
    ripgrep.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        ll = "eza -alh";
        update = "sudo nixos-rebuild switch";
        vim = "nvim";
        ls = "eza";
        tree = "eza --tree";
        cat = "bat";
        dig = "dog";
        find = "fd";
      };
      history = {
        size = 1000000;
        save = 1000000;
        path = "/home/chris/.zsh_history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ ];
        theme = "gruvbox";
      };
    };
    starship = {
      enable = true;
      settings = pkgs.lib.importTOML "/home/chris/homemgr/config/starship.toml";
    };
  };
  home.file = {
    ".config/nvim/lua/config" = {
      source = ./config/nvim/lua/config;
      recursive = true;
    };
    ".config/nvim/lua/plugins" = {
      source = ./config/nvim/lua/plugins;
      recursive = true;
    };
  };
}
