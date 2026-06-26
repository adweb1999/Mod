# OneState Mod - Makefile

.PHONY: all build clean install ipa

all: build

build:
	@echo "Building OneState Mod..."
	@./build.sh

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf Payload/
	@rm -f *.ipa

ipa:
	@echo "Building IPA..."
	@./build.sh

install:
	@echo "Install with:"
	@echo "  - TrollStore: Open IPA with TrollStore app"
	@echo "  - AltStore: Drag IPA to AltStore"
	@echo "  - Sideloadly: Use Sideloadly app"
	@echo "  - Xcode: Use Devices and Simulators"

help:
	@echo "Available targets:"
	@echo "  make build    - Build the IPA"
	@echo "  make clean    - Clean build artifacts"
	@echo "  make ipa      - Build IPA (same as build)"
	@echo "  make install  - Show installation instructions"
	@echo "  make help     - Show this help"
