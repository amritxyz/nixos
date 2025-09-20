{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nyx";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kathmandu";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver = {
    enable = true;
    autoRepeatDelay = 250;
    autoRepeatInterval = 50;
  };

  users.users.void = {
    isNormalUser = true;
    description = "void";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hyprpaper
    waybar
    wtype
    wofi
    wl-clipboard
    foot
    neovim
    wget
    git
    firefox
    lf
    grim
    slurp
    imv
    mpv
    # dejavu_fonts
    nerd-fonts.symbols-only
  ];

xdg = {
  portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "eDP-1";
          max_fps = 30;
          # exec_before = "disable_notifications.sh";
          # exec_after = "enable_notifications.sh";
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland 
      xdg-desktop-portal-gtk 
    ];
  };
};

  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.hyprland.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}
