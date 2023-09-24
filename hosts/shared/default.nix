{ pkgs, outputs, overlays, lib, inputs, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages = ps: with ps; [
    numpy
  ];
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
#   boot.loader.efi.efiSysMountPoint = "/boot/efi";
  programs.zsh.enable = true;
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    enableB43Firmware = true;
  };
  security = {
    sudo.enable = true;
  };
  services.blueman = {
    enable = true;
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Asia/Jakarta";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  users = {
    users.dann = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "libvirtd" ];
      packages = with pkgs; [ ];
    };
    defaultUserShell = pkgs.zsh;
  };
  fonts.packages = with pkgs; [
    material-design-icons
    phospor
    inter
    dosis
    material-symbols
    rubik
    ibm-plex
    (nerdfonts.override { fonts = [ "Iosevka" "CascadiaCode" "JetBrainsMono" ]; })
  ];

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  security.rtkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    nodejs
    home-manager
    lua-language-server
    lua54Packages.lua
    blueman
    inotify-tools
    udiskie
    rnix-lsp
    xorg.xwininfo
    # pulseaudio
    (pkgs.python3.withPackages my-python-packages)
    libnotify
    xdg-utils
    gtk3
    appimage-run
    jq
    discord
    firefox
    gperftools
    unzip
    slop
    git
    pstree
    mpv
    xdotool
    spotify
    simplescreenrecorder
    brightnessctl
    pamixer
    nix-prefetch-git
    python3
    brillo
    wmctrl
    ueberzugpp
    ripgrep
    maim
    xclip
    wirelesstools
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xorgserver
    xorg.xf86videoati
  ];

  environment.shells = with pkgs; [ zsh ];

  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  services.printing.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.xserver = {
    layout = "us";
    xkbVariant = "us,";
  };
  security.polkit.enable = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;
      substituters = [ ];
      trusted-public-keys = [ ];

    };
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };
  system = {
    copySystemConfiguration = false;
    stateVersion = "22.11";
  };
}
