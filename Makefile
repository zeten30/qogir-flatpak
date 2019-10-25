# RPM Makefile
RELEASE=31
clean:
	rm -rf org.*.xml org.*.json build

manifests: clean
	./build-manifests.sh
