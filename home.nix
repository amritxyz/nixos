{ config, pkgs, ... }:

let
  dot_config = "${config.home.homeDirectory}/.local/git-repos/nixos/config";
  neovim = "${config.home.homeDirectory}/.local/git-repos/nixos/neovim";
  dot_local = "${config.home.homeDirectory}/.local/git-repos/nixos/local";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    nvim = "nvim";
    bleachbit = "bleachbit";
    dunst = "dunst";
    fastfetch = "fastfetch";
    # git = "git";
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
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    shell = "shell";
    tmux = "tmux";
    wget = "wget";
    x11 = "x11";
    zathura = "zathura";
    "userdirs.dirs" = "user-dirs.dirs";
    "mimeapps.list" = "mimeapps.list";
  };
in

{
  home.username = "void";
  home.homeDirectory = "/home/void";
  programs.git.enable = true;
  home.stateVersion = "25.05";
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

  # home.file.".config/nvim".source = ./config/nvim;

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dot_config}/${subpath}";
      recursive = true;
    })
  configs;

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
