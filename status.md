Problem: MT7922 Wi-Fi 6E card on Framework laptop connects to
`mit_pommes` on 5 GHz / 40 MHz only. Other devices connect to
6 GHz / 160 MHz on the same AP and get much higher speeds.

## What we found

- Hardware: MediaTek MT7922 (mt7921e driver), supports 6 GHz (Band 4)
- Regulatory domain: DE, 6 GHz allowed (5945-6425 @ 320 MHz, NO-OUTDOOR, no NO-IR)
- All 6 GHz channels enabled at 23 dBm in `iw phy phy0 info`
- AP (Unifi) has 6 GHz enabled at 160 MHz, other devices use it fine
- AP advertises 6 GHz BSS via RNR (IE 201) in its 5 GHz beacons:
  - 6 GHz BSSID: 6c:63:f8:53:96:c4
  - Channel 37 (6135 MHz), Operating Class 134 (160 MHz)
- Scan finds 109 BSSes but ZERO on 6 GHz — the driver never scans 6 GHz
- Two likely culprits found:
  1. `ieee80211_regdom` was `00` (world) at cfg80211 module level
  2. CLC (Country Location Control) was enabled (`disable_clc=N`)

## Changes applied (pending rebuild + reboot)

In `fw.nix`, added:
```nix
boot.extraModprobeConfig = ''
  options cfg80211 ieee80211_regdom=DE
  options mt7921_common disable_clc=1
'';
```

In `platform.nix`, bumped kernel:
- From: `linuxPackages_6_18` (6.18.13)
- To: `linuxPackages_latest` (6.19.3)
- Note: 6_18 was pinned because 6_19 broke VirtualBox — might be fixed now

## After reboot, verify with

```bash
# Check regulatory domain is DE and not 00
cat /sys/module/cfg80211/parameters/ieee80211_regdom
# Check CLC is disabled
cat /sys/module/mt7921_common/parameters/disable_clc
# Scan and look for 6 GHz BSSes (freq > 5945)
nix-shell -p iw --run 'iw dev wlan0 scan dump' | grep -E '(BSS |freq:)' | grep -A1 'BSS ' | grep 'freq: [6-7]'
# Check current connection
iwctl station wlan0 show
nix-shell -p iw --run 'iw dev wlan0 link'
```

## If 6 GHz still not found after reboot

- Try wpa_supplicant instead of iwd (iwd may not handle RNR-based 6 GHz discovery)
- Check `dmesg | grep -iE 'mt79|6.*ghz|regulatory'` for clues
- Bump 5 GHz channel width to 80 MHz on the Unifi controller as fallback
