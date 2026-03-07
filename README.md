# Unofficial [AmneziaWG](https://amnezia.org) builds

## Description

Personal packaging repository for **[AmneziaWG](https://github.com/amnezia-vpn/amneziawg-linux-kernel-module)** —  
a WireGuard fork with advanced traffic obfuscation (H1–H4, I1–I5, junk packets and more).

This is **unofficial** builds. The original project is developed by the [Amnezia VPN](https://amnezia.org) team.

Builds are available for:
- **Debian** (11, 12, 13)
- **Ubuntu** (22.04, 24.04, 25.10)
- **Fedora** (41, 42, 43)
- **EPEL** (9, 10)

via [my OBS repository](https://build.opensuse.org/package/show/home:YroriXW/amneziawg).

## Credits

**Base projects**
- [Amnezia VPN team](https://amnezia.org) and the entire [amnezia-vpn organization](https://github.com/amnezia-vpn) — for creating and maintaining AmneziaWG.
- [WireGuard project](https://www.wireguard.com/) and its author **[Jason A. Donenfeld (zx2c4)](https://www.zx2c4.com/)** — AmneziaWG is a fork of the original WireGuard kernel module.

**Patches & contributions**
- [babiulep](https://github.com/babiulep) for **[blake2s.patch](https://github.com/babiulep/my-kernel-patches/blob/main/AMNEZIAWG/blake2s.patch)**
- [Kirill Turanskiy](https://github.com/thebtf) for **[fixmemleakinjpspecsetup.patch](https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/pull/142)**
