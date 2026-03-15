%global debug_package %{nil}

Name:           amneziawg
Version: 1.0.20260210
Release: 14%{?dist}
Summary:        Fast, modern, secure VPN tunnel
License:        GPL-2.0-only
URL:            https://github.com/YroriXW/amneziawg
Requires:       (akmod-amneziawg >= %{version} or kmod-amneziawg >= %{version})
Requires:       amneziawg-tools >= %{version}
Provides:       amneziawg-kmod-common = %{version}

BuildArch:      noarch

%description
Common package for AmneziaWG

%files

%changelog
