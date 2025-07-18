{
  description = "Hello C binary flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nix = pkgs.nix.overrideAttrs (final: prev: {
        experimentalFeatures = [ "flakes" "nix-command" ];
      });
      hello = pkgs.stdenv.mkDerivation {
        pname = "hello";
        version = "1.0";
        src = builtins.fetchGit {
          url = "https://github.com/notarealdeveloper/hello.git";
          ref = "master";
          rev = "aea1e7c2100d5c1c3c3bcf910c00a247930135e6";
        };
        nativeBuildInputs = [ pkgs.gnumake pkgs.gcc nix ];
        buildPhase = "make";
        installPhase = ''
          mkdir -p $out/bin
          cp hello $out/bin/
        '';
      };
    in {
      packages.${system}.default = hello;

      apps.${system}.hello = {
        type = "app";
        program = "${hello}/bin/hello";
      };
    };
}

