{
  description = "Python jello package with GitHub‑based C hello dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    selfpkgs.url = "github:notarealdeveloper/flakes/master";
  };

  outputs = { self, nixpkgs, selfpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    mine = import selfpkgs {};

    # Python package: uses setuptools via PEP-517 hooks
    jello = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jello";
      version = "1.0";

      src = builtins.fetchGit {
        url = "https://github.com/notarealdeveloper/jello.git";
        ref = "master";
        rev = "18d6bc75b6d16133ca8b5ebd3db486da36cbecc9";
      };

      format = "pyproject";

      nativeBuildInputs = [ pkgs.gnumake ];
      buildInputs = [
        mine.hello
        pkgs.python3Packages.pip
      ];
      buildPhase = "make";
      installPhase = "make install";

    };
  in {
    packages.${system}.default = jello;
  };
}

