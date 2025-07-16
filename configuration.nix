# Type "nixos-help" for help

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {

	loader = {

		  # Bootloader.
		  grub = {
		  enable = true;
		  devices = [ "nodev" ];
		  efiSupport = true;
		  useOSProber = true;
		  #version = 2; # Version is 2 by default
		   };

		  efi.canTouchEfiVariables = true;

	};

	kernelPatches = [
	    {

	      name = "Rust Support";
	      patch = null;

	      features = {

		rust = false;	# Make sure the Kernel is above 6.7

	      };

	    }

	  ];

	kernelModules = ["rtw89"];

  };



  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n = {

	  # Select internationalisation properties.
	  defaultLocale = "en_US.UTF-8";

	  extraLocaleSettings = {
	    LC_ADDRESS = "en_IN";
	    LC_IDENTIFICATION = "en_IN";
	    LC_MEASUREMENT = "en_IN";
	    LC_MONETARY = "en_IN";
	    LC_NAME = "en_IN";
	    LC_NUMERIC = "en_IN";
	    LC_PAPER = "en_IN";
	    LC_TELEPHONE = "en_IN";
	    LC_TIME = "en_IN";
	  };

  };


  services = {

	  # Enable the X11 windowing system.
	  xserver.enable = true;

	  # Enable the GNOME Desktop Environment.
	  xserver.displayManager.gdm.enable = true;
	  xserver.desktopManager.gnome.enable = true;

	  openssh.enable = true;  # This enables the SSH server

	  # Configure keymap in X11
	  xserver.xkb = {
	    layout = "us";
	    variant = "";
	  };

	  tor = {

	    enable = true;
	    openFirewall = true;

	  };

	  # Enable CUPS to print documents.
	  printing.enable = true;

	  pipewire = {
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
	  # xserver.libinput.enable = true;

	  # Enable the OpenSSH daemon.
	  # openssh.enable = true;

  };


  # Enable Virtual Box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["adhikari"];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adhikari = {
    isNormalUser = true;
    description = "adhikari";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs = {

	  # Allow Steam To Run
	  steam = {
	    enable = true;
	    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	  };

	  firefox.enable = true;

	  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
	  # mtr.enable = true;
	  # gnupg.agent = {
	  #   enable = true;
	  #   enableSSHSupport = true;
	  # };

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
     environment.systemPackages = with pkgs; [
    
  # House
    neovim 
    xclip
    vscode
    git
    gimp
    usbutils
    # google-chrome # For compatibility with certain sites

  # Home 
    cowsay
    cmatrix
    htop
    neofetch
    cool-retro-term
    tauon
    kid3-qt
    cava
    glow    
    gimp
    discord
    vesktop	# A dependency in NixOs for wayland to support screen sharing in discord
    xournalpp

    spotify
    obs-studio

  # Work
    teams-for-linux
    gns3-gui
    gns3-server
    obsidian
    libreoffice-qt6-still

  # Networking
    traceroute
    whois
    nmap
    dig
    inetutils
    netdiscover

  # GNS 3 Setup
    gns3-gui
    gns3-server
    dynamips
    vpcs

  # Security
    snort
    openvpn

  # Foresics
   wireshark
   exif
   hashid
   # autopsy
   # sleuthkit # Autopsy wont run without this package
   e2fsprogs
   hexedit
   
  # Reverse Engineering
   pwntools
   pdf-parser
   file
   oletools
   binwalk

  # Development
   python3
   rustup
   python312Packages.pip
   gcc

 # Debugging
   gdb
   burpsuite
  # zap

  # Games
  # steamPackages.steam-runtime

  ];

  # Device Network Hardening
  networking = {

  # Enable networking
  networkmanager.enable = true;
  	
  hostName = "REDACTED";
	
  enableIPv6 = false;

  wireguard = {
    
    enable = true;
    
    interfaces = {

      };
  };

  wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # proxy.default = "http://user:password@proxy:port/";
  # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Optional: Make sure routing is enabled if needed
  # nat.enable = true;
  # nat.externalInterface = "eth0";  # Replace with your real external interface
	
  nftables.enable = true;

  firewall = {

    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    logRefusedPackets = true;

 };

};

  security.pki.certificateFiles = [

	# Specify certificate file location

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
