{pkgs, ...}: let
  network = import ../../../share/network.properties.nix;
  secrets-dir = "/var/lib/secrets";
in {
  systemd.tmpfiles.rules = [
    "d    ${secrets-dir}     -       -      -    -   - "
    "Z    ${secrets-dir}     644     root   -    -   - "
  ];
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "example@aol.com";
      credentialsFile = "/run/secrets/cloudflare_dns_secret";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
    };
    certs = {
      ${network.domain}.domain = "*.${network.domain}";
      "${network.domain}-tld".domain = "${network.domain}";
    };
  };
  services = {
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
    };
  };
  nix.settings.allowed-users = ["@wheel"];
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      neovim
      pciutils
      usbutils
    ];
  };
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
  };
}
