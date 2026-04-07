{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "govee2mqtt";
  version = "4374efdb232bb074dcfe325008f9deddb063db95";
  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee2mqtt";
    rev = "4374efdb232bb074dcfe325008f9deddb063db95";
    hash = "sha256-ol7Y06XGL+S6HUEB63X7DoyNyX6if8O3Byg55f2acL0=";
  };
  cargoPatches = [
    ./dont-vendor-openssl.diff
  ];
  postPatch = ''
    substituteInPlace src/service/http.rs \
      --replace '"assets"' '"${placeholder "out"}/share/govee2mqtt/assets"'
  '';

  cargoHash = "sha256-XIdWxhyARhAHV0IZXOHOl4mHFS5/4Is74B4615jYeDs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    mkdir -p $out/share/govee2mqtt/
    cp -r assets $out/share/govee2mqtt/
  '';

  meta = {
    description = "Connect Govee lights and devices to Home Assistant";
    homepage = "https://github.com/wez/govee2mqtt";
    changelog = "https://github.com/wez/govee2mqtt/blob/${finalAttrs.version}/addon/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "govee";
  };
})
