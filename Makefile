# RPM Makefile
RELEASE=32
clean:
	rm -rf org.*.xml org.*.json build local-repo

manifests: clean
	./build-manifests.sh

build: clean
	./build-manifests.sh build

install: clean
	./build-manifests.sh build install

update_flatpak:
	./update-flatpak-repos.sh