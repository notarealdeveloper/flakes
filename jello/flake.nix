{
  description = "Python jello package with GitHub‑based C hello dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    hello = pkgs.stdenv.mkDerivation {
      pname = "hello"; version = "1.0";
      src = builtins.fetchGit {
        url = "https://github.com/notarealdeveloper/hello.git";
        ref = "master";
        rev = "aea1e7c2100d5c1c3c3bcf910c00a247930135e6";
      };
      nativeBuildInputs = [ pkgs.gnumake pkgs.gcc ];
      buildPhase = "make";
      installPhase = ''
        mkdir -p $out/bin
        cp hello $out/bin/
      '';
    };

    jello = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jello"; version = "1.0";

      src = builtins.fetchGit {
        url = "https://github.com/notarealdeveloper/jello.git";
        ref = "master";
        rev = "b2f028840db5d6a1b992d33558e4db8587bd04ab";
      };

      format = "pyproject";
      nativeBuildInputs = [ pkgs.gnumake ];
      buildInputs = [
        hello
        pkgs.python3Packages.setuptools
        pkgs.python3Packages.wheel
      ];
      nativeCheckInputs = [ pkgs.python3Packages.pytest ];

      doCheck = true;
      checkPhase = "pytest";
    };
  in {
    packages.${system} = {
      hello = hello;
      jello = jello;
      default = jello;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ hello jello ];
    };
  };
}

