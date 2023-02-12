{ stdenv, lib, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
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
    sha256 = "sha256-b7TXUSdBYYACRvImK0ocfC/eWtdYN8hhwqybPZQbLAc=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = pkgs.linuxKernel.kernels.linux_6_1.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace src/Makefile --replace "BASEDIR :=" "BASEDIR ?="
    substituteInPlace src/Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = [
    "BASEDIR=${pkgs.linuxKernel.kernels.linux_6_1.kernel.dev}/lib/modules/${pkgs.linuxKernel.kernels.linux_6_1.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  meta = with lib; {
    # Not sure if this patch will work on 6.3
    # broken = lib.versionAtLeast pkgs.linuxKernel.kernels.linux_6_1.version "6.3.0";
  };
}