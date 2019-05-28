{ stdenv, fetchurl, dpkg, busybox, systemd }:

stdenv.mkDerivation rec {
  name = "expressvpn-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://download.expressvpn.xyz/clients/linux/expressvpn_${version}-1_amd64.deb";
    sha256 = "19bxg5s6v7kswasl902r9ap9qx6a14r4d3yichw2c3wrbsx9cz9s";
  };

  buildInputs = [ dpkg ];

  sourceRoot = ".";

  unpackCmd = ''
    dpkg-deb -x "$src" .
  '';

  installPhase = ''
    cp -r ./usr/ $out/
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath "$out/lib/expressvpn/openvpn"):$out/lib/expressvpn" \
      $out/lib/expressvpn/openvpn
    patchelf \
      --set-rpath "$(patchelf --print-rpath "$out/lib/expressvpn/libxvclient.so"):$out/lib/expressvpn" \
      $out/lib/expressvpn/libxvclient.so
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath "$out/bin/expressvpn"):$out/lib/expressvpn" \
      $out/bin/expressvpn
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath "$out/bin/expressvpnd"):$out/lib/expressvpn" \
      $out/bin/expressvpnd
  '';

  meta = with stdenv.lib; {
    description = "ExpressVPN client and daemon";
    homepage    = https://www.expressvpn.com;
    license     = licenses.unfree;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kuznero ];
  };
}
