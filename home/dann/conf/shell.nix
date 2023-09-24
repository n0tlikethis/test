{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      la = "exa -l";
      ls = "ls --color=auto";
      v = "nvim";
      nf = "neofetch";
      suda = "sudo -E -s";
      nix-pkgs = "nix --extra-experimental-features 'nix-command flakes' search nixpkgs";
    };
    history = {
      expireDuplicatesFirst = true;
      save = 512;
    };
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[4~"   end-of-line
      bindkey  "^[[3~"  delete-char
      export PATH=${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.local/share/nvim/mason/bin:$PATH
      export LD_LIBRARY_PATH=${config.home.homeDirectory}/.config/awesome:${pkgs.lua54Packages.lua}/lib/:${pkgs.pam}/lib
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };

}
