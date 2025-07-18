{
  description = "jello flake, runtime depends on hello";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hello = { url = "github:notarealdeveloper/helloflake/master"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, nixpkgs, hello, ... }:
    let
      system = "x86_64-linux";  # static target
      pkgs = import nixpkgs { inherit system; };
      helloPkg = hello.packages.${system}.default;
      nix = pkgs.nix.overrideAttrs (final: prev: {
        experimentalFeatures = [ "flakes" "nix-command" ];
      });
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "jello";
        version = "1.0";

        src = ./.;  # **must** point to your source directory

        nativeBuildInputs = [
          pkgs.gnumake
          nix
        ];

        buildInputs = [ helloPkg pkgs.python3Packages.pip ];
        propagatedBuildInputs = [ helloPkg ];

        buildPhase = "make";
        installPhase = "make install";
      };
    };
}

