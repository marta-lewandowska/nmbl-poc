%global debug_package %{nil}
%global KVER %{expand:%(ls -1 /lib/modules | tail -n1)}
%global os_dist %{expand:%(ls -1 /lib/modules | grep -Eo '\.[cefln]+[0-9]+' | tail -n1)}
%global VERSION 1
%global RELEASE 1
%global VR %{expand:%(%{VERSION}-%{RELEASE}%{os_dist})}

Name: nmbl
Summary: nmbl proof of concept as a package
Version: %{VERSION}
Release: %{RELEASE}%{?dist}
Group: System Environment/Base
License: GPLv3
URL: https://github.com/rhboot/nmbl-poc

%description
nmbl-poc is a proof of concept for a bootloader for UEFI machines based on
the linux kernel and grub-emu, using either switchroot or kexec.

%build
make rpm

%install
%make_install ESPDIR="%{efi_esp_dir}"

%files -n nmbl
%defattr(-,root,root,-)
%{efi_esp_dir}/*.uki

%changelog
* Tue Mar 04 2025 Marta Lewandowska <mlewando@redhat.com> - 1-0
- Fixes to get this thing to build in copr

* Fri Mar 17 2023 Peter Jones <pjones@redhat.com> - 0-0
- Yeet a spec file into the world
