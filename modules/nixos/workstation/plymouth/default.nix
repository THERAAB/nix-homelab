{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.plymouth;
  theme = pkgs.runCommand "plymouth-theme" {} ''
    themeDir="$out/share/plymouth/themes/custom"
    mkdir -p $themeDir
    # Convert in case the input image is not PNG
    # A transparent border of 42% ensures that the image is not clipped when rotated
    ${pkgs.imagemagick}/bin/convert \
      -background transparent \
      -bordercolor transparent \
      -border 42% \
      ${config.boot.plymouth.logo} \
      $themeDir/logo.png
    cp ${./custom.script} $themeDir/custom.script
    echo "
    [Plymouth Theme]
    Name=Custom
    ModuleName=script
    [script]
    ImageDir=$themeDir
    ScriptFile=$themeDir/custom.script
    " > $themeDir/custom.plymouth
  '';
in {
  options.nix-homelab.workstation.plymouth = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup plymouth boot");
  };
  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      logo = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
        # Reduce size
        postFetch = ''
          substituteInPlace $out \
            --replace "141.5919" "70.79595" \
            --replace "122.80626" "61.40313"
        '';
        sha256 = "4+MWdqESKo9omd3q0WfRmnrd3Wpe2feiayMnQlA4izU=";
      };
      theme = "custom";
      themePackages = [theme];
    };
  };
}
