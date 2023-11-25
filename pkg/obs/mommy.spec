Name:          mommy
Version:       placeholder
Release:       placeholder
Summary:       mommy's here to support you, in any shell~ ❤️
License:       Unlicense
URL:           https://github.com/FWDekker/mommy
VCS:           git+https://github.com/fwdekker/mommy.git
Source:        mommy-%{version}.tar.gz
BuildArch:     noarch
BuildRequires: make
BuildRequires: glibc-langpack-en

%description
mommy's here to support you! mommy will compliment you if things go well, and
will encourage you if things are not going so well~

mommy is fully customizable, integrates with any shell, works on any system, and
most importantly, loves you very much~ ❤️

%prep
%setup -q

%clean
rm -rf "%{buildroot}"

%build
make build

%install
make prefix="%{buildroot}/%{_prefix}/" install

%files
%{_bindir}/mommy
%{_mandir}/man1/mommy.1.gz
%{_datarootdir}/fish/vendor_completions.d/mommy.fish
%{_datarootdir}/zsh/site-functions/_mommy

%changelog
# Changelog lists changes to the packaging, not to the software.
* Sat Nov 25 2023 Florine W. Dekker 1.2.5-1
- Rewrite script for OpenBuildService.

* Tue Mar 14 2023 Florine W. Dekker 1.2.3-1
- Initial release with rpkg.
