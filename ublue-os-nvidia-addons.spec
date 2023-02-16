Name:           ublue-os-nvidia-addons
Version:        0.2
Release:        1%{?dist}
Summary:        Additional files for nvidia driver support

License:        MIT
URL:            https://github.com/ublue-os/nvidia

BuildArch:      noarch
Supplements:    mokutil policycoreutils

Source0:        public_key.der
Source1:        nvidia-container-runtime.repo
Source2:        nvidia-container.pp

%description
Adds various runtime files for nvidia support. These include a key for importing with mokutil to enable secure boot for nvidia kernel modules

%prep
%setup -q -c -T


%install
# Have different name for *.der in case kmodgenca is needed for creating more keys
install -Dm0644 %{SOURCE0} %{buildroot}%{_sysconfdir}/pki/akmods/certs/akmods-nvidia.der
install -Dm0644 %{SOURCE1} %{buildroot}%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
install -Dm0644 %{SOURCE2} %{buildroot}%{_datadir}/selinux/packages/nvidia-container.pp

sed -i "s@gpgcheck=0@gpgcheck=1@" %{buildroot}%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo

%files
%attr(0644,root,root) %{_sysconfdir}/pki/akmods/certs/akmods-nvidia.der
%attr(0644,root,root) %{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
%attr(0644,root,root) %{_datadir}/selinux/packages/nvidia-container.pp

%changelog
* Thu Feb 16 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add nvidia-container-runtime repo
- Add nvidia-container-runtime selinux policy file
- Re-purpose into a general-purpose add-on package
- Update URL to point to ublue-os project

* Fri Feb 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add key for enrolling kernel modules in alpha builds
