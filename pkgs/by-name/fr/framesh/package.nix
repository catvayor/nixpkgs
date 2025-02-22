{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  pname = "framesh";
  version = "0.6.10";
  src = fetchurl {
    url = "https://github.com/floating/frame/releases/download/v${version}/Frame-${version}.AppImage";
    hash = "sha256-h2Y0G7luakd5UVu7bVt9r6xhvyOh80gYMTswmEIcnnk=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/frame.desktop $out/share/applications/frame.desktop
    install -m 444 -D ${appimageContents}/frame.png \
      $out/share/icons/hicolor/512x512/apps/frame.png
    wrapProgram "$out/bin/${pname}" \
       --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    substituteInPlace $out/share/applications/frame.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Native web3 interface that lets you sign data, securely manage accounts and transparently interact with dapps via web3 protocols like Ethereum and IPFS";
    homepage = "https://frame.sh/";
    downloadPage = "https://github.com/floating/frame/releases";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nook ];
  };
}
