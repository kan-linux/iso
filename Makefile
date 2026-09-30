.PHONY: iso qemu qemu-uefi clean

all: qemu

help:
	@echo ""
	@echo "KAN-LINUX - Pure, Source-built, Agent-first Linux distro"
	@echo ""
	@echo "  make iso          - Create ISO image"
	@echo "  make qemu         - Start QEMU"
	@echo "  make clean        - Remove generated ISO and build artifacts"
	@echo ""

# Install host dependencies
deps:
	@./scripts/install-deps.sh

iso:
	@./scripts/create-iso.sh

qemu:
	@./scripts/start-qemu.sh

clean:
	@rm -rf iso/boot         iso/casper
	@rm -f  iso/boot.catalog iso/*.iso
