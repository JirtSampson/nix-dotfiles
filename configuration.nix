# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernel.sysctl = {
     "net.ipv6.conf.all.disable_ipv6" = 1;
     "net.ipv6.conf.default.disable_ipv6" = 1;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "bcachefs" ];
  boot.initrd.luks.devices."luks-0488c0d7-a06f-492f-b0d2-11c36014f34e".device = "/dev/disk/by-uuid/0488c0d7-a06f-492f-b0d2-11c36014f34e";
  networking.hostName = "nuc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";  

  # Nix Options
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable VPN
  services.mullvad-vpn.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;  
  
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "en_DK.UTF-8/UTF-8" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };

# Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  

# Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

#Hyperland
#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #Tailscale
  services.tailscale.enable = true;
 
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  #Enable docker
  virtualisation.docker.enable = true;

  #Passwordless sudo
  # Define a user account. Don't forget to set a password with 'passwd'.
  security.sudo.extraRules= [
  {  users = [ "chris" ];
    commands = [
       { command = "ALL" ;
         options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }
    ];
  }
];
programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;


  users.users.chris = {
    isNormalUser = true;
    description = "Chris";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "dialout"];
    packages = with pkgs; [
      firefox
      kdePackages.kate
      bitwarden
      ungoogled-chromium
      nicotine-plus
      nextcloud-client
      git
      gnumake
      gcc
      cmake
      signal-desktop
      mullvad-vpn
      neovim
      vimPlugins.LazyVim
      docker
      gimp
      tor-browser-bundle-bin
      imagemagick
      handbrake
      fzf
      distrobox
      vlc
      mpv
      celluloid
      haruna
      onlyoffice-bin
      inkscape
      wireshark
      kdePackages.kcalc
      gparted
      wl-clipboard
      go
      python3
      python311Packages.django
      python311Packages.pip
      tree
      htop
      remmina
      appimage-run
      zip
      unzip
      iotop
      pciutils
      lsof
      lshw
      tree
      libsForQt5.ktexteditor
      libsForQt5.plasma-browser-integration
      killall
      cifs-utils
      nmap
      ffmpeg-full      
      kdePackages.kdenlive
      obsidian
      pgadmin
      arduino
      esptool
      esptool-ck
      cargo
      rustup
      vscode
      espup
      libguestfs
      ruby_3_3
      rubyPackages.rails
      ruby-lsp
      bundler
      yarn
      kdePackages.ktorrent
      #wineWowPackages.stable
      #winetricks
      #wineWowPackages.waylandFull
    ];
  };

  # Install Steam
  programs.steam.enable = true;

  # Postgres playground
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "pg-test" ];
    enableTCPIP = true;
    # port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE pg-test WITH LOGIN PASSWORD 'pg-test' CREATEDB;
      CREATE DATABASE pg-test;
      GRANT ALL PRIVILEGES ON DATABASE pg-test TO pg-test;
    '';
  };
  
  # Run/manage KVM VMs
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
  
  # Enable KDE and automatic login for the user.
  services.displayManager.defaultSession = "plasma";
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "chris";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #Hyperland pkgs:
    #waybar
    #dunst
    #libnotify
    #hyprpaper
    #kitty
    #rofi-wayland
    #wl-clipboard
    #dolphin
    #qt5ct
    #breeze-qt5
    #breeze-icons
    kdePackages.ffmpegthumbs
    libsForQt5.gwenview
    #libsForQt5.kdegraphics-thumbnailers
    #libsForQt5.kio
    #libsForQt5.kio-extras
    #libsForQt5.qtstyleplugins
    #libsForQt5.qtutilities
    #libsForQt5.qt5.qtwayland
    #libsForQt5.qt5.qtmultimedia
    #libsForQt5.qt5.qtimageformats
    #libsForQt5.qt5.qtbase
    #libsForQt5.phonon
    #grim
    #networkmanagerapplet
    #slurp
    #swww
    kde-gruvbox
    gruvbox-dark-icons-gtk
    gruvbox-gtk-theme
    gruvbox-dark-gtk
    vimPlugins.gruvbox
    vscode-extensions.jdinhlife.gruvbox
    spice-gtk
    kdePackages.plasma-workspace
    kdePackages.plasma-vault
    encfs
    cryfs
    jetbrains.ruby-mine
    zed-editor
  ];

  #Install fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerd-fonts.jetbrains-mono

  ];

  #Allow for non-packaged fonts to be installed to ~/.local/share/fonts
  fonts.fontDir.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions. 
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };
 
  #Keep a tidy NixOS
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
