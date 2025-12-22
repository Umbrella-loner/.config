# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, zen-browser, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
#dconf

#virtualization
virtualisation.libvirtd.enable = true;
networking.nftables.enable = true;
virtualisation.spiceUSBRedirection.enable = true;
programs.virt-manager.enable = true;
zramSwap.enable = true;


#darkmode
# Add this block to your configuration.nix
programs.dconf.enable = true;  # You already have this

# Force GTK apps to use dark theme
environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";
};

# Set dark theme via dconf (this is what was missing)
programs.dconf.profiles.user.databases = [{
  settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}];

#new kernels
boot.kernelPackages = pkgs.linuxPackages_latest;
#hyprland block
programs.hyprland = {
enable = true;
xwayland.enable = true;
};
boot.loader.systemd-boot.enable = false;

boot.loader.efi = {
  canTouchEfiVariables = true;
  efiSysMountPoint = "/boot/efi";
};

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
  useOSProber = true;
};

programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs;
[
stdenv.cc.cc
  zlib
  openssl
  glib
  gtk3
  xorg.libX11
  xorg.libXcursor
  xorg.libXrandr
  xorg.libXinerama
  xorg.libXcomposite
  xorg.libXdamage
  xorg.libXfixes
  xorg.libXtst
  alsa-lib
  pulseaudio
  wayland
  mesa
];

#laptop stuff
services.logind.settings.Login = {
  HandleLidSwitch = "ignore";
  HandleLidSwitchExternalPower = "ignore";
};


programs.zsh = {
  enable = true;

  enableCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  shellAliases = {
  };


  # Global interactive config (applies to ALL users)
  interactiveShellInit = ''
    bindkey '^ ' autosuggest-accept
    path+=("$HOME/.local/bin")
    export PATH
 # fzf integration
    eval "$(fzf --zsh)"
    
    # zoxide (better cd)
    eval "$(zoxide init zsh)"
  '';

};
users.defaultUserShell = pkgs.zsh;

#dbus-thing-block
services.dbus.enable = true;

environment.variables = {
XDG_DATA_DIRS = [
  "/usr/share"
  "${pkgs.gsettings-desktop-schemas}/share"
  "${pkgs.glib}/share"

  ];
  };

#app-image support don't forget
programs.appimage.enable = true;
programs.appimage.binfmt = true;

#xdg-portal-block
xdg.portal = {
enable = true;
extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
};

#ssh-settings
services.openssh = {
enable = true;
};
  networking.firewall.allowedTCPPorts = [ 22 ];
boot.kernelParams = [
"console=tty50"
"mem_sleep_default=deep"
];


#homemanager
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.users.robin = { pkgs, ... }: {
  home.stateVersion = "25.11";
};


#flakes-setting
nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "doc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


#flatpak-apps
services.flatpak.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robin = {
    isNormalUser = true;
    description = "robin";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [];
  };

#nix-index
programs.nix-index.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
git
terraform
xfce.thunar
cliphist
evince
ps_mem
zen-browser.packages.${pkgs.system}.default
glib
gsettings-desktop-schemas
obs-studio
obs-studio-plugins.wlrobs
obs-studio-plugins.obs-pipewire-audio-capture
obs-studio-plugins.obs-vkcapture
blender
gcc 
zip
file
tree
less
ripgrep
fd
bat
eza
htop
ncdu
lsof
strace
yazi
p7zip
rar
nmap
netcat
rsync
jq
openssh
yq
man-pages
man-pages-posix
fzf
zoxide
tldr
clang
clang-tools
gnumake
cmake
gdb
rofi
firefox
kubectl
vim
curl 
wget 
unzip 
vlc
neovim
gammastep
curl
brave
google-chrome
hyprpaper
alacritty
protonvpn-gui
firefox
adwaita-icon-theme
grim
slurp
docker
tmux
swaynotificationcenter
wl-clipboard
brightnessctl
networkmanagerapplet
blueman
waybar
swayosd
nerd-fonts.jetbrains-mono
nerd-fonts.fira-code
aria2
  ];

#fonts
fonts = {
packages = with pkgs; [
 nerd-fonts.jetbrains-mono
 nerd-fonts.fira-code
 ];
 fontconfig = {
 enable = true;
 defaultFonts = {
  monospace = [ "JetBrainsMono Nerd Font"];
   sansSerif = [ "JetBrainsMono Nerd Font" ];
   serif = [ "JetbrainsMono Nerd Font" ];
   };
   };
   };

   
#powersaving tlp
services.tlp.enable = true;


#acpi-thing-block
services.acpid.enable = true;


#keyd-program-block
services.keyd = {
  enable = true;

  keyboards.default = {
    ids = [ "*" ];
    settings = {
      main = {
        rightalt = "leftmeta";
	};
	};
	};
	};


#bluetooth-block
hardware.bluetooth.enable = true;
services.blueman.enable = true;


  #docker-block
virtualisation.docker.rootless = {
enable = true;
setSocketVariable = true;
};




#audio-stack(don't forget)
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
jack.enable = true;
};

security.rtkit.enable = true;



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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  system.stateVersion = "25.11";
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
}
