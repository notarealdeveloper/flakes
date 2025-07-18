{
  description = "Flakes repo.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      name = system;
      value = {
        hello = import ./flakes/hello { inherit pkgs system; };
        jello = import ./flakes/jello { inherit pkgs system; };
      };
    };

    defaultPackage = (pkgsFor builtins.currentSystem).hello;
}

