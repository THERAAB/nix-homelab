# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    python = prev.python.override {
      packageOverrides = final: prev: {
        my_stuff = prev.buildPythonPacakge rec {
          pname = "aiohttp";
          version = "3.8.3";
          src = prev.fetchPypi {
            inherit pname version;
            sha256 = "";
          };
        };
      };
    };
    pythonPackages = python.pkgs;
  };
}