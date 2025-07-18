{
  description = "Simple C program";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      hello = pkgs.stdenv.mkDerivation {
        pname = "hello";
        version = "1.0";
        src = builtins.fetchGit {
          url = "https://github.com/notarealdeveloper/hello.git";
          rev = "aea1e7c2100d5c1c3c3bcf910c00a247930135e6";
          ref = "refs/heads/master";
        };
        buildInputs = [ pkgs.gnumake pkgs.gcc ];
        buildPhase = "make";
        installPhase = ''
          mkdir -p $out/bin
          cp hello $out/bin/
        '';
      };
    in {
      packages = {
        x86_64-linux = {
          default = hello;
        };
      };
    };
}

