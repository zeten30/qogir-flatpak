# RPM Makefile
RELEASE=31
clean:
	rm -rf org.*.xml org.*.json build local-repo

manifests: clean
	./build-manifests.sh

install: clean
	./build-manifests.sh install