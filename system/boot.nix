{ config, pkgs, lib, kernel, fetchFromGitHub, ... }:
{  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Force kernel to use the right CPU driver & use graphics controller
    kernelParams = [ "i915.force_probe=4692" "i915.enable_guc=3" ];
    # Adding patched r8125 kernel module for ethernet
    extraModulePackages = [
      (
        pkgs.stdenv.mkDerivation rec {
          pname = "r8125";
          # On update please verify (using `diff -r`) that the source matches the
          # realtek version.
          version = "9.011.00-1";

          # This is a patched version of the Realtek version below for 6.1 kernel
          # [1] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
          src = fetchFromGitHub {
            owner = "awesometic";
            repo = "realtek-r8125-dkms";
            rev = version;
            sha256 = "";
          };

          hardeningDisable = [ "pic" ];

          nativeBuildInputs = kernel.moduleBuildDependencies;

          preBuild = ''
            substituteInPlace src/Makefile --replace "BASEDIR :=" "BASEDIR ?="
            substituteInPlace src/Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
          '';

          makeFlags = [
            "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
          ];

          buildFlags = [ "modules" ];

          meta = with lib; {
            # Not sure if this patch will work on 6.3
            broken = lib.versionAtLeast kernel.version "6.3.0";
          };
        }
      )
    ];
  };
}
