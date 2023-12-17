{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
  ,fetchFromGitHub ? pkgs.fetchFromGitHub
  ,lib ? pkgs.lib
  , buildNpmPackage ? pkgs.buildNpmPackage
  , nodejs_20 ? pkgs.nodejs_20
  , node-gyp ? pkgs.nodePackages.node-gyp
  , git ? pkgs.git
  , rsync ? pkgs.rsync
  , cargo-cross ? pkgs.cargo-cross
  , rustup ? pkgs.rustup
  , podman ? pkgs.podman
  , stdenv ? pkgs.stdenv
}:
let
target = if stdenv.hostPlatform.system == "x86_64-linux" then
    "linux-amd64"
  else if stdenv.hostPlatform.system == "x86_64-darwin" then
    "macos-amd64"
  else if stdenv.hostPlatform.system == "aarch64-darwin" then
    "macos-arm64"
  else if stdenv.hostPlatform.system == "aarch64-linux" then
    "linux-arm64"
  else throw "Platform ${stdenv.hostPlatform.system} not yet supported.";
in
buildNpmPackage rec  {
  pname = "garden";
  version = "0.13.20";

  src = fetchFromGitHub {
    owner = "garden-io";
    repo = "garden";
    rev = "${version}";
    hash = "sha256-vxfhEE2rsVCwuR2kblOaLmmG4HjwUI756S/tQQKfXOA=";
  };
  # sourceRoot = "${src.name}/cli";
  npmDepsHash = "sha256-QZX1EBlkTqjmgRKppj84u4ZFKkdXxFJSau26RBDj4Cc=";

  # dontNpmBuild = true;

  # maybe preBuild ?
  postPatch = ''
    cat <<EOF | tee scripts/check-docs.sh
    #!/bin/env bash
    EOF
    chmod +x scripts/check-docs.sh

    echo "" > cli/src/generate-docs.ts
  
    sed -E '/npm[^a-z]+install/d' -i cli/src/build-pkg.ts
    # why does the rollup fail now.?
    sed -E '/npm[^a-z]+run[^a-z]+rollup/d' -i cli/src/build-pkg.ts
  '';

  installPhase = ''
    runHook preInstall  

    rustup default stable
    PATH=$PATH:./bin

    # we aren't gonna use cross, but cargo directly
    ln -s ${rustup}/bin/cargo ./bin/cross

    # same as "npm run dist", but without "generate-docs"
    node cli/build/src/build-pkg.js ${target}

    mkdir -p $out/bin
    cp dist/${target} $out/bin/garden
    chmod +x $out/bin/garden

    runHook postInstall
  '';

  nativeBuildInputs = [ node-gyp git nodejs_20 rsync rustup podman ];

  makeCacheWritable = true;

  meta = with lib; {
    description = "Garden is a tool that combines rapid development, testing, and DevOps automation in one platform.";
    homepage = "https://garden.io/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ohmymndy ];
    platforms = platforms.all;
  };
}


