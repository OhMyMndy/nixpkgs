{ lib, rustPlatform, fetchFromGitHub, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.87";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-J+84FZfrbv6jp2T9cYgodLZ+TgIAht+uJSVi5ULDGBU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qyqhhAitl0u69JYX+qjN8OnTyF17VdjjkbioFyA/W8s=";

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}
