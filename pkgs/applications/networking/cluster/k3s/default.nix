{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "k3s-${version}";
  version = "v0.5.0";

  goPackagePath = "github.com/rancher/k3s";

  src = fetchFromGitHub {
    rev = version;
    owner = "rancher";
    repo = "k3s";
    sha256 = "16lw7n85zy4nb27awbnrk27p6mx85773pndiizzqcrm4dvkb3i6s";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Lightweight Kubernetes";
    homepage = https://github.com/rancher/k3s;
    license = licenses.asl20;
    maintainers = with maintainers; [kuznero];
    platforms = platforms.unix;
  };
}
