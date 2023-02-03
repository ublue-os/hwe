Name:           akmods-nvidia-key
Version:        0.1
Release:        1%{?dist}
Summary:        Secure boot key for nvidia kernel modules

License:        MIT
URL:            http://rpmfusion.org/Packaging/KernelModules/Akmods

BuildArch:      noarch
Supplements:    mokutil

Source0:        public_key.der


%description
Key for importing with mokutil to enable secure boot for nvidia kernel modules

%prep
%setup -q -c -T


%install
# Have different name for *.der in case kmodgenca is needed for creating more keys
install -Dm0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/pki/akmods/certs/akmods-nvidia.der

%files
%attr(0644,root,root) %{_sysconfdir}/pki/akmods/certs/akmods-nvidia.der

%changelog
* Fri Feb 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add key for enrolling kernel modules in alpha builds
