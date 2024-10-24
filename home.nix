{ config, pkgs, inputs, ... }:

let
  # Define the base config directory
  configDir = "/home/chris/homemgr";
  
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile (configDir + file)}\nEOF\n";
in
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
  };

  # Link config files to the right location
  xdg.configFile = {
    "nvim/plugin" = {
      source = "${configDir}/config/nvim/plugin";
      recursive = true;
    };
    "nvim/options.lua" = {
      source = "${configDir}/config/nvim/options.lua";
    };
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
        ${builtins.readFile "${configDir}/config/nvim/options.lua"}
      '';
      extraPackages = with pkgs; [
        lua-language-server
        xclip
        wl-clipboard
      ];
      
      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-lspconfig;
          config = toLuaFile "/config/nvim/plugin/lsp.lua";
        }

        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        {
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }
        neodev-nvim
        nvim-cmp 
        {
          plugin = nvim-cmp;
          config = toLuaFile "/config/nvim/plugin/cmp.lua";
        }

        {
          plugin = telescope-nvim;
          config = toLuaFile "/config/nvim/plugin/telescope.lua";
        }
        telescope-fzf-native-nvim
        cmp_luasnip
        cmp-nvim-lsp
        luasnip
        friendly-snippets
        lualine-nvim
        nvim-web-devicons
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-json
          ]));
          config = toLuaFile "/config/nvim/plugin/treesitter.lua";
        }
        vim-nix
      ];
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
      };
      history = {
        size = 1000000;
        save = 1000000;
        path = "/home/chris/.zsh_history";
      };
    };

    starship = {
      enable = true;
      settings = pkgs.lib.importTOML "/home/chris/homemgr/config/starship.toml";
    };
  };
}
