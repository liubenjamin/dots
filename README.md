# dots
os: artix linux

wm: i3-gaps

terminal: urxvt

shell: zsh

bar: polybar	

compositor: picom

## macOS preferences

edit `.config/macos/preferences.json` to change the tracked settings. This file is the source of truth; no export or script regeneration is needed.

```bash
# Preview the configured keys (also the default mode).
~/bin/apply-macos-settings --dry-run

# Back up existing preferences and apply the JSON values.
~/bin/apply-macos-settings --apply
```

requires macOS and Python 3. Run as your normal user, without `sudo`. Close System Settings before applying, then log out and back in.

the command writes only listed keys and preserves unrelated settings. Removing a key from the JSON stops managing it; it does not reset the stored value. Host-specific settings use the destination Mac's current host.

backups are private and saved under `~/tmp/pi/macos-settings-backup.*`. Do not commit full preference dumps: they can contain account data. The JSON contains selected stored settings, not a comparison against factory defaults. Some keys depend on the macOS version or hardware.
