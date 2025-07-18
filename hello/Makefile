PKG = hello

build:
	nix build

run:
	$(PKG)

clean:
	rm -fv result flake.lock

install: build
	nix profile add .

uninstall:
	nix profile remove $(PKG)
