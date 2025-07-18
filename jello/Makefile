PKG = jello

build:
	nix build

run:
	python -c "import jello; jello.main()"

clean:
	rm -fv result flake.lock

install: build
	nix profile add .

uninstall:
	nix profile remove $(PKG)
