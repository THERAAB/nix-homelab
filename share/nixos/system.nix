{ config, pkgs, ... }:
{ 
  security.auditd.enable = true;
  nix.settings.allowed-users = [ "@wheel" ];
  
  # Zsh
  environment.pathsToLink = [ "share/zsh" ];
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  
  #OpenSSH
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    };
  };

  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
  };

  # Neovim
  environment.variables.EDITOR = "nvim";  
}
