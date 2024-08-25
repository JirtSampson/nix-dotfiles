{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tree
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
     zsh = {
       enable = true;
       enableCompletion = true;
       enableAutosuggestions = true;
       syntaxHighlighting = true;
      
       shellAliases = {
         ll = "ls -l";
         update = "sudo nixos-rebuild switch";
         vim = "nvim";
       };
       history = {
         size = 10000;
         path = "/home/chris/.zsh_history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ ];
        theme = "gruvbox";
      };
    };
    git = {
      enable = true;
       aliases = {
       amend = "commit -a --amend";
       cob = "checkout -b";
     };
    };
  };
}
