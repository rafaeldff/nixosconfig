Problem: MT7922 Wi-Fi 6E card on Framework laptop connects to
`mit_pommes` on 5 GHz / 40 MHz only. Other devices connect to
6 GHz / 160 MHz on the same AP and get much higher speeds.

## What we found (initial investigation)

- Hardware: MediaTek MT7922 (mt7921e driver), supports 6 GHz (Band 4)
- Regulatory domain: DE, 6 GHz allowed (5945-6425 @ 320 MHz, NO-OUTDOOR, no NO-IR)
- All 6 GHz channels enabled at 23 dBm in `iw phy phy0 info`
- AP (Unifi) has 6 GHz enabled at 160 MHz, other devices use it fine
- AP advertises 6 GHz BSS via RNR (IE 201) in its 5 GHz beacons:
  - 6 GHz BSSID: 6c:63:f8:53:96:c4 (+ 72:63:f8:53:96:c4)
  - Channel 37 (6135 MHz), Operating Class 134 (160 MHz)

## Changes applied and verified after reboot

In `fw.nix`, added:
```nix
boot.extraModprobeConfig = ''
  options cfg80211 ieee80211_regdom=DE
  options mt7921_common disable_clc=1
'';
```

In `platform.nix`, bumped kernel:
- From: `linuxPackages_6_18` (6.18.13)
- To: `linuxPackages_latest` (6.19.9)
- Note: 6_18 was pinned because 6_19 broke VirtualBox — might be fixed now

### Post-reboot verification results

- `ieee80211_regdom` = **DE** (was `00`) ✓
- `disable_clc` = **Y** (was `N`) ✓
- `iw reg get` shows DE regulatory with 5945-6425 @ 320 MHz, NO-OUTDOOR ✓
- `iw phy phy0 channels` shows all 6 GHz channels enabled, 23 dBm, no "disabled" flag ✓
- `iw phy phy0 info` shows Band 4 (6 GHz) with HE capabilities ✓
- Firmware: HW/SW 0x8a108a10, build 20260224

### Still broken: no 6 GHz BSSes in scan results

- Scan results show **zero** 6 GHz BSSes (only 2.4 + 5 GHz found)
- Even explicit `iw dev wlan0 scan trigger freq 6135` finds nothing on 6 GHz
- RNR (IE 201) is present in 5 GHz beacon and correctly advertises the 6 GHz BSS
- iwd recognizes the 6 GHz band at startup but never scans it

### Current connection (unchanged)

- BSSID: 6c:63:f8:53:96:c3 (5 GHz radio)
- Freq: 5200 MHz (channel 40)
- Width: **40 MHz** (HT operation shows secondary below, but no VHT IE → capped at 40 MHz)
- Mode: 802.11ax (HE), MCS 11 NSS 2
- Bitrate: ~573 Mbit/s TX, ~458 Mbit/s RX
- Signal: -33 dBm

## Root cause: iwd does not do RNR-based 6 GHz discovery

iwd v3.10 sees the 6 GHz band and the RNR element, but does not use RNR
to trigger out-of-band 6 GHz scanning. During `autoconnect_quick` it
connects to the first known 5 GHz BSS immediately. Even a manual scan
trigger on 6135 MHz finds nothing — this may be because 6 GHz requires
active probing with proper SAE (WPA3) parameters that only
wpa_supplicant handles correctly.

## Two separate problems

1. **No 6 GHz connection** — iwd cannot discover the 6 GHz BSS
2. **40 MHz on 5 GHz** — AP advertises HT40 (secondary below) but no
   VHT Operation IE in its 5 GHz beacons, so the client is limited to
   40 MHz even though both sides support 80 MHz. This is likely a Unifi
   AP configuration issue (check 5 GHz channel width setting in the
   controller)

## Next steps

### For 6 GHz (the main fix)
- **Switch from iwd to wpa_supplicant** — wpa_supplicant has proper
  support for RNR-based 6 GHz BSS discovery and SAE-based probing on
  6 GHz. This is the recommended path for Wi-Fi 6E on Linux.
  - In NixOS: `networking.wireless.iwd.enable = false;` and configure
    `networking.supplicant` or use NetworkManager with wpa_supplicant backend
  - Alternatively, use NetworkManager (`networking.networkmanager.enable = true;`)
    which defaults to wpa_supplicant and handles 6 GHz well

### For 5 GHz 40 MHz (secondary issue)
- Check Unifi controller: ensure 5 GHz channel width is set to 80 MHz
  (not "auto" or "40 MHz")
- This is independent of the iwd/wpa_supplicant question

### iwd config tweaks (unlikely to help, but worth trying first)
```ini
# /etc/iwd/main.conf
[Scan]
DisablePeriodicScan=false

[General]
EnableNetworkConfiguration=true
```
