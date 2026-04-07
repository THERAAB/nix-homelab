{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "govee2mqtt";
  version = "2025.11.25-60a39bcc";
  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee2mqtt";
    tag = "2026.03.25-ab9deb66";
    hash = "sha256-APGvE5BIYgZtAWbM9DGJFuGyI3715g8Gyxou8uhspdM=";
  };
  cargoPatches = [
    ./dont-vendor-openssl.diff
  ];
  prePatch = ''
    substituteInPlace src/undoc_api.rs \
        --replace '"6.5.02"' '"7.4.10"'
    substituteInPlace src/undoc_api.rs \
        --replace 'iOS 16.5.0) Alamofire/5.6.4' 'iOS 18.4.0) Alamofire/5.10.2'
  '';
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
