# Type "nixos-help" for help

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub = {
  enable = true;
  devices = [ "nodev" ];
  efiSupport = true;
  useOSProber = true;
  #version = 2; # Version is 2 by default
};

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Virtual Box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["adhikari"];

  services.openssh.enable = true;  # This enables the SSH server

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.tor = {

    enable = true;
    openFirewall = true;

  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adhikari = {
    isNormalUser = true;
    description = "adhikari";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.users.dooth = {

    isNormalUser = true;
    home = "/home/dooth";
    description = "SSH Client";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
    {REDACTED}
    ];

};

  # Install firefox.
  programs.firefox.enable = true;

boot.kernelPatches = [
    {

      name = "Rust Support";
      patch = null;

      features = {

        rust = false;	# Make sure the Kernel is above 6.7

      };

    }

  ];

  # Allow Steam To Run
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.pki.certificateFiles = [

	# Specify certificate file location

  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
     environment.systemPackages = with pkgs; [
    
  # House
    neovim 
    xclip
    vscode
    git
    gimp
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
    ciscoPacketTracer8
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Device Network Hardening

  services.udev.extraRules = ''
    # Match RTL-SDR: Realtek Semiconductor Corp. RTL2838 DVB-T
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="2838", MODE="0666", GROUP="plugdev"
  '';

  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" "rtl2832" "r820t" ];

  networking = {

  # Enable networking
  networkmanager.enable = true;
  	
  hostName = "REDACTED";
	
  enableIPv6 = false;

  wireguard = {
    
    enable = true;
    
    interfaces = {
	wg0 = {
	   ips = [ "10.12.0.41/32" ]; # Replace with your assigned client IP
	   listenPort = 51820;        # Optional; only needed if not default or you are accepting inbound traffic
	   # mtu = 1360;                # Optional; include if needed
	   privateKeyFile = "/home/adhikari/.wireguard/priv";

	   peers = [
		{
		  publicKey = "nxdlRhfXT3tmn2hOFVCPUsxIPE4A3Ayq3W8V5sCkr2Y=";
		  endpoint = "114.143.238.94:51820";
		  allowedIPs = [
		    "10.12.0.0/24"
		    "192.168.5.0/24"
		    "192.168.1.0/24"
		  ];
		  persistentKeepalive = 25;
	  }
      	];
      };
    };
  };

  # Optional: Make sure routing is enabled if needed
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "eth0";  # Replace with your real external interface

	extraHosts = ''
	  192.168.5.26 teleport.rudra.local
	  192.168.5.16 nextcloud.rudra.local
	  192.168.5.33 gitlab.rudra.local
	'';
	
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

	/home/adhikari/.ca-certificates/teleport.rudra.local.crt
	/home/adhikari/.ca-certificates/nextcloud.rudra.local.crt

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
