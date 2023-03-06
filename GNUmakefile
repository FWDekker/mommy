# Extracted values
version := $(shell head -n 1 version)
date := $(shell tail -n 1 version)

comment := $(shell grep -- "--description" .fpm | tr -d "\"" | cut -d " " -f 2-)
maintainer := $(shell grep -- "--maintainer" .fpm | tr -d "\"" | cut -d " " -f 2-)

# Define default output directories
# Separating these variables into a `*_prefix` and `*_prefix_default` allows, for example, the `fpm` target to specify
# certain defaults, while also allowing the `deb` target to override that default when invoking `fpm`, and then also
# allows the user to override that default when running `make osxpkg`.
prefix_default = /usr/
bin_prefix_default = $(prefix)/bin/
man_prefix_default = $(prefix)/share/man/man1/
fish_prefix_default = $(prefix)/share/fish/vendor_completions.d/
zsh_prefix_default = $(prefix)/share/zsh/site-functions/

install fpm: prefix ?= $(prefix_default)
install fpm: bin_prefix ?= $(bin_prefix_default)
install fpm: man_prefix ?= $(man_prefix_default)
install fpm: fish_prefix ?= $(fish_prefix_default)
install fpm: zsh_prefix ?= $(zsh_prefix_default)


# Output list of `make` targets
.PHONY: list
list:
	@# Taken from https://stackoverflow.com/a/26339924/
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

# Clean up previous builds
.PHONY: clean
clean:
	@rm -rf build/ dist/


# Run tests
.PHONY: test
test: test/mommy test/man test/fish test/zsh

.PHONY: test/%
test/%:
	@shellspec src/test/sh/"$(@:test/%=%)"_spec.sh


## Compilation
# "Compile" files into `build/`
.PHONY: build
build:
	@# Copy relevant files
	@mkdir -p build/bin/; cp src/main/sh/mommy build/bin/
	@mkdir -p build/man/; cp src/main/resources/mommy.1 build/man/
	@mkdir -p build/fish/; cp src/main/fish/mommy.fish build/fish/
	@mkdir -p build/zsh/; cp src/main/zsh/_mommy build/zsh/

	@# Insert version information
	@sed -i".bak" "s/%%VERSION_NUMBER%%/$(version)/g;s/%%VERSION_DATE%%/$(date)/g" build/bin/mommy build/man/mommy.1
	@rm -f build/bin/mommy.bak build/man/mommy.1.bak

	@# Compress
	@gzip -f build/man/mommy.1


# Copy built files into appropriate directories
.PHONY: install
install: build
	@# Create directories
	@install -m 755 -d "$(bin_prefix)" "$(man_prefix)" "$(fish_prefix)" "$(zsh_prefix)"

	@# Copy files
	@install -m 755 build/bin/* "$(bin_prefix)"
	@install -m 644 build/man/* "$(man_prefix)"
	@install -m 644 build/fish/* "$(fish_prefix)"
	@install -m 644 build/zsh/* "$(zsh_prefix)"

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
		"build/man/mommy.1.gz=$(man_prefix)/mommy.1.gz" \
		"build/fish/mommy.fish=$(fish_prefix)/mommy.fish" \
		"build/zsh/_mommy=$(zsh_prefix)/_mommy"

# Build AlpineLinux / Debian / RedHat / FreeBSD package with fpm
.PHONY: dist/apk dist/deb dist/rpm dist/freebsd
dist/apk dist/deb dist/rpm dist/freebsd:
	@$(MAKE) fpm_target="$(@:dist/%=%)" bin_prefix='$$(prefix)/local/bin/' man_prefix='$$(prefix)/local/man/man1/' fpm

# Build ArchLinux package with fpm
.PHONY: dist/pacman
dist/pacman:
	@$(MAKE) fpm_target=pacman fpm

# Build macOS package with fpm
.PHONE: dist/osxpkg
dist/osxpkg:
	@$(MAKE) fpm_target=osxpkg prefix='/usr/local/' fpm

	@# `installer` program requires `pkg` extension
	@mv dist/*.osxpkg "dist/mommy-$(version)+osx.pkg"

# Build NetBSD package manually
.PHONY: dist/netbsd
dist/netbsd:
	@$(MAKE) prefix='build/netbsd/usr/pkg/' man_prefix='$$(prefix)/man/man1/' install

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
.PHONY: dist/openbsd
dist/openbsd:
	@$(MAKE) prefix='build/openbsd/usr/' bin_prefix='$$(prefix)/local/bin/' man_prefix='$$(prefix)/local/man/man1/' install

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
