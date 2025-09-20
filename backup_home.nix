{ config, pkgs, ... }:

let
  # Use relative paths from the Nix file instead of hardcoded absolute paths
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard ~/.config/ directories, relative to ./config/
  configs = {
    hypr = "hypr";
    waybar = "waybar";
    foot = "foot";
    nvim = "nvim";
    bleachbit = "bleachbit";
    mako = "mako";
    fastfetch = "fastfetch";
    gnupg = "gnupg";
    gtk2 = "gtk-2.0";
    gtk3 = "gtk-3.0";
    gtk4 = "gtk-4.0";
    lf = "lf";
    mpv = "mpv";
    newsboat = "newsboat";
    npm = "npm";
    pulse = "pulse";
    python = "python";
    wofi = "wofi";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    shell = "shell";
    tmux = "tmux";
    wget = "wget";
    zathura = "zathura";
    "userdirs.dirs" = "user-dirs.dirs";
    "mimeapps.list" = "mimeapps.list";
  };

  local_symlinks = {
    "bin" = ./local/bin;
    "share" = ./local/share;
  };

in
{
  home.username = "void";
  home.homeDirectory = "/home/void";
  home.stateVersion = "25.05";

  programs.git.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/.local/git-repos/nixos#nyx";
      gitr = "cd ~/.local/git-repos";
    };
    initExtra = ''
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
    '';
  };

  # Symlinks for ~/.config/*
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink ./config/${subpath};
      recursive = true;
    })
  configs;

  # Symlinks for ~/.local/{bin,share}
  home.file = builtins.mapAttrs (name: path: {
    source = create_symlink path;
    target = "${config.home.homeDirectory}/.local/${name}";
  }) local_symlinks;

  home.packages = with pkgs; [
    ripgrep
    nodejs
    gcc
    rofi
    xwallpaper
    gnumake
    pkg-config
    xorg.libX11
    xorg.libXinerama
    xorg.libXft
    harfbuzz
    fontconfig
  ];
}
