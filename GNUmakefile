# Target locations
prefix := /usr/
bin_prefix := $(prefix)/bin/
man_prefix := $(prefix)/share/man/
fish_prefix := $(prefix)/share/fish/vendor_completions.d/
zsh_prefix := $(prefix)/share/zsh/site-functions/

# Extracted values
version := $(shell head -n 1 version)
date := $(shell tail -n 1 version)

comment := $(shell grep -- "--description" .fpm | tr -d "\"" | cut -d " " -f 2-)
maintainer := $(shell grep -- "--maintainer" .fpm | tr -d "\"" | cut -d " " -f 2-)


## Meta
# Output list of targets
.PHONY: list
list:
	@# Taken from https://stackoverflow.com/a/26339924/
	@LC_ALL=C $(MAKE) -pRrq -f "$(lastword $(MAKEFILE_LIST))" : 2>/dev/null | \
		awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | \
		egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

# Clean up previous builds
.PHONY: clean
clean:
	@rm -rf build/ dist/


## Tests
.PHONY: test
test: test/unit test/integration

.PHONY: test/%
test/%: system ?= 0
test/%:
	@MOMMY_SYSTEM="$(system)" MOMMY_MAKE="$(MAKE)" shellspec "src/test/sh/$(@:test/%=%)_spec.sh"


## "Compile" files into `build/`
.PHONY: build
build:
	@# Copy relevant files
	@mkdir -p build/bin/; cp src/main/sh/mommy build/bin/
	@mkdir -p build/man/man1/; cp src/main/man/man1/mommy.1 build/man/man1/
	@mkdir -p build/completions/fish/; cp src/main/completions/fish/mommy.fish build/completions/fish/
	@mkdir -p build/completions/zsh/; cp src/main/completions/zsh/_mommy build/completions/zsh/

	@# Insert version information
	@sed -i".bak" "s/%%VERSION_NUMBER%%/$(version)/g;s/%%VERSION_DATE%%/$(date)/g" \
		build/bin/mommy \
		build/man/man1/mommy.1
	@rm -f build/bin/mommy.bak build/man/man1/mommy.1.bak

	@# Compress
	@gzip -f build/man/man1/mommy.1


## Installation
# Copy built files into appropriate directories
.PHONY: install
install: build
	@# Create directories
	@install -m 755 -d "$(bin_prefix)" "$(man_prefix)/man1/" "$(fish_prefix)" "$(zsh_prefix)"

	@# Copy files
	@install -m 755 build/bin/mommy "$(bin_prefix)"
	@install -m 644 build/man/man1/mommy.1.gz "$(man_prefix)/man1/"
	@install -m 644 build/completions/fish/mommy.fish "$(fish_prefix)"
	@install -m 644 build/completions/zsh/_mommy "$(zsh_prefix)"

# Install with preset overrides, as specified later
.PHONY: install/%
install/%: install
	@#

# Remove installed files
.PHONY: uninstall
uninstall:
	@rm "$(bin_prefix)/mommy"
	@rm "$(man_prefix)/man1/mommy.1.gz"
	@rm "$(fish_prefix)/mommy.fish"
	@rm "$(zsh_prefix)/_mommy"

# Uninstall with preset overrides, as specified later
.PHONY: uninstall/%
uninstall/%: uninstall
	@#


## Build packages
.PHONY: dist/%

# Invoke fpm on built files to create `fpm_target` type output
# For valid `fpm_target`s, see https://fpm.readthedocs.io/en/latest/packaging-types.html
.PHONY: fpm
fpm: build
ifndef fpm_target
	$(error fpm_target is undefined)
endif
	@mkdir -p dist
	@fpm -t "$(fpm_target)" \
		-p "dist/mommy-$(version).$(fpm_target)" \
		--version "$(version)" \
		\
		"build/bin/mommy=$(bin_prefix)/mommy" \
		"build/man/man1/mommy.1.gz=$(man_prefix)/man1/mommy.1.gz" \
		"build/completions/fish/mommy.fish=$(fish_prefix)/mommy.fish" \
		"build/completions/zsh/_mommy=$(zsh_prefix)/_mommy"

# Build generic extractable package
dist/generic: prefix := ./build/generic/mommy/usr/
dist/generic:
	@rm -rf build/generic/

	@$(MAKE) prefix="$(prefix)" install

	@mkdir -p dist/
	@tar -C build/generic/ -czf "dist/mommy-$(version)+generic.tar.gz" ./

# Build Debian package with fpm
dist/deb: zsh_prefix := $(prefix)/share/zsh/vendor-completions/
dist/deb:
	@$(MAKE) fpm_target=deb zsh_prefix="$(zsh_prefix)" fpm

# Build AlpineLinux / Debian / ArchLinux / RedHat package with fpm
dist/apk dist/pacman dist/rpm:
	@$(MAKE) fpm_target="$(@:dist/%=%)" fpm

# Build macOS package with fpm
%/osxpkg: prefix := /usr/local/
dist/osxpkg:
	@$(MAKE) fpm_target=osxpkg prefix="$(prefix)" fpm

	@# `installer` program requires `pkg` extension
	@mv dist/*.osxpkg "dist/mommy-$(version)+osx.pkg"

# Build FreeBSD package with fpm
%/freebsd: prefix := /usr/local/
dist/freebsd:
	@$(MAKE) fpm_target=freebsd prefix="$(prefix)" fpm

# Build NetBSD package manually
%/netbsd: prefix := build/netbsd/usr/pkg/
%/netbsd: man_prefix := $(prefix)/man/
dist/netbsd:
	@$(MAKE) prefix="$(prefix)" man_prefix="$(man_prefix)" install

	@cd build/netbsd; find . -type f | sed -e "s/^/.\//" > +CONTENTS

	@echo "$(comment)" > build/netbsd/+COMMENT

	@echo "$(comment)" 				   > build/netbsd/+DESC
	@echo "" 						  >> build/netbsd/+DESC
	@echo "Maintainer: $(maintainer)" >> build/netbsd/+DESC

	@echo "MACHINE_ARCH=$$(uname -p)"           > build/netbsd/+BUILD_INFO
	@echo "OPSYS=$$(uname)"                    >> build/netbsd/+BUILD_INFO
	@echo "OS_VERSION=$$(uname -r)"            >> build/netbsd/+BUILD_INFO
	@echo "PKGTOOLS_VERSION=$$(pkg_create -V)" >> build/netbsd/+BUILD_INFO


	@cd build/netbsd; \
	pkg_create \
		-B +BUILD_INFO \
		-c +COMMENT \
		-d +DESC \
		-f +CONTENTS \
		-I / \
		-p . \
		"mommy-$(version)+netbsd.tgz"

	@mkdir -p dist/
	@mv build/netbsd/mommy*.tgz dist/

# Build OpenBSD package manually
%/openbsd: prefix := build/openbsd/usr/local/
%/openbsd: man_prefix := $(prefix)/man/
dist/openbsd:
	@$(MAKE) prefix="$(prefix)" man_prefix="$(man_prefix)" install

	@cd build/openbsd; find . -type f | sed -e "s/^/.\//" > +CONTENTS

	@echo "$(comment)" > build/openbsd/+COMMENT

	@echo "$(comment)" > build/openbsd/+DESC


	@cd build/openbsd; \
	pkg_create \
		-d +DESC \
		-D COMMENT="$(comment)" \
		-D FULLPKGPATH="mommy-$(version)+netbsd" \
		-D MAINTAINER="$(maintainer)" \
		-f +CONTENTS \
		-B "$$(pwd)/" \
		-p / \
		"mommy-$(version)+openbsd.tgz"

	@mkdir -p dist/
	@mv build/openbsd/mommy*.tgz dist/
