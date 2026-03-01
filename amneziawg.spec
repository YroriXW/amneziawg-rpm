%global debug_package %{nil}

Name:           amneziawg
Version:        1.0.20260210
Release:        2%{?dist}
Summary:        Fast, modern, secure VPN tunnel
License:        GPL-2.0-only
URL:            https://github.com/YroriXW/amneziawg-linux-kernel-module
Requires:       (akmod-amneziawg >= %{version} or kmod-amneziawg >= %{version})
Requires:       amneziawg-tools >= %{version}
Provides:       amneziawg-kmod-common = %{version}

BuildArch:      noarch

%description
Common package for AmneziaWG

%files

%changelog
* Sat Feb 28 2026 Oleg YroriXW <olegyrori@gmail.com> - 1.0.20260210-1
- Initial build
