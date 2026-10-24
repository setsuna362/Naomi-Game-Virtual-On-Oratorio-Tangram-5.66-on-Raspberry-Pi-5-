# NAOMI Virtual-On: Oratorio Tangram 5.66 on Raspberry Pi 5

Run **Virtual-On: Oratorio Tangram 5.66 (M.S.B.S. Ver. 5.66)** on a Raspberry Pi 5 with ReplayOS and Flycast. This guide is intended for Windows users and focuses on the **Windows one-click installer**.

> **Project status:** The Windows installer has been tested for remote installation and automatic VOOT startup on a Raspberry Pi 5. Not every mode or clean-install environment has been fully verified. The repository's one-click distribution and Release assets must be published before the Git-clone workflow below works end to end.

For the original, detailed Chinese instructions (manual compilation, configuration and troubleshooting), see [Manual installation.MD](Manual%20installation.MD).

## Step 1 — Flash ReplayOS to a microSD card

**On Windows:**

1. Download and install [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
2. Download the Raspberry Pi 5 ReplayOS image from the [ReplayOS download page](https://www.replayos.com/download/). The original manual uses **ReplayOS 1.6.0**, file `replayos-base-rpi-v1.6.0.img.xz`; check the supported image version before installing.
3. Open Raspberry Pi Imager and select **Raspberry Pi 5**.
4. Select **Use custom image**, then choose the downloaded ReplayOS `.img.xz` file.
5. Select your microSD card and write the image.

**Warning:** Double-check the selected storage device. Flashing will overwrite its contents.

## Step 2 — Find the Raspberry Pi 5 IP address

1. Insert the flashed microSD card into your Raspberry Pi 5.
2. Connect a display to the **micro-HDMI connector nearest the USB-C power connector**, and connect a keyboard and an Ethernet network cable.
3. Power on the Raspberry Pi 5.
4. In the ReplayOS menu, open **REPLAY OPTION → INFORMATION → IP → ETHERNET IP**.
5. Write down the IP address (for example, `192.168.1.50`). Your Windows PC and Raspberry Pi should be reachable over the same local network.

The original manual also suggests using a network IP scanner on Windows if needed.

## Step 3 — Prepare the Windows installation folder

The planned final distribution lets you clone this repository and provide only your own game and BIOS files.

Open **PowerShell** on Windows:

```powershell
git clone https://github.com/setsuna362/Naomi-Game-Virtual-On-Oratorio-Tangram-5.66-on-Raspberry-Pi-5- C:\Pi-5_VOOT
```

> **Prerequisite:** Git for Windows must be installed to use `git clone`. The installer files and matching release archive must also be published in this repository. Until then, use the separately supplied test installer package.

Put your **own legally obtained** files in `C:\Pi-5_VOOT`:

```text
C:\Pi-5_VOOT\
├── install.bat
├── install.ps1
├── naomi.zip       (user-supplied NAOMI BIOS)
└── vonot.zip       (user-supplied VOOT 5.66 game ROM)
```

The installer will obtain the precompiled Flycast ARM64 package and supporting configuration from the project's published distribution. **Game ROMs and BIOS files are not included or distributed by this project.**

## Step 4 — Run the one-click installer

From PowerShell:

```powershell
cd C:\Pi-5_VOOT
.\install.bat
```

Enter the Raspberry Pi 5 IP address from Step 2, then choose a mode:

| Option | Mode | Purpose |
| --- | --- | --- |
| 1 | **NO LINK** | Standalone play, no network link |
| 2 | **MASTER** | Main machine for linked play |
| 3 | **SLAVE** | Second machine for linked play |
| 4 | **SATELLITE** | Satellite Monitor Live / spectator setup (experimental) |

On a fresh ReplayOS installation, the expected SSH username is `root` and the default password is `replayos`. The Windows installer is designed to handle default authentication automatically. If your credentials differ, additional input or configuration may be necessary.

The installer transfers the files to the Pi, installs Flycast and its configuration, sets up the selected mode and enables automatic launch. It may need an internet connection on Windows to install a PowerShell SSH dependency on first use.

**Security:** Use this installer only on a Raspberry Pi you own or administer, on a trusted local network. Change the default ReplayOS SSH password after setup. Never include credentials or copyrighted ROMs in a public Git commit.

## Step 5 — Restart and verify

Restart the Raspberry Pi 5 normally. If installation succeeds, it should launch **VOOT 5.66** automatically instead of the ReplayOS frontend.

Check the controller inputs and open **GAME TEST MODE → GAME ASSIGNMENTS** to verify that **COMMUNICATION MODE** matches the selected role: **NO LINK**, **MASTER**, **SLAVE**, or **SATELLITE**. Also confirm the difficulty, match counts and play times.

For linked play, configure each machine with its intended role. Master/Slave networking must be tested on your actual network; three-machine Satellite behavior is still experimental.

## Installation paths on the Raspberry Pi 5

| Component | Destination |
| --- | --- |
| Flycast executable | `/root/flycast/build/flycast` |
| User-supplied `naomi.zip` and `vonot.zip` | `/root/flycast/build/` |
| Flycast settings | `/root/.config/flycast/emu.cfg` |
| Controller mappings | `/root/.config/flycast/mappings/` |
| VOOT EEPROM / NVRAM | `/root/.local/share/flycast/` |
| VMU files | `/root/.config/` |
| Auto-start service | `/etc/systemd/system/flycast.service` |

The installer should leave the Flycast `server =` setting blank by default instead of hardcoding another player's LAN address.

## Troubleshooting

If the installer cannot connect, confirm the IP address, Ethernet connection, SSH accessibility and credentials. If the first run requests a PowerShell NuGet/SSH dependency, ensure Windows has internet access; dependency installation behavior may vary by Windows/PowerShell version.

If the game does not appear after reboot, inspect the service over SSH:

```bash
systemctl status flycast.service
journalctl -u flycast.service -b --no-pager -n 100
```

**Stop Flycast before replacing its settings or save files**, as the running emulator may overwrite changes when it exits:

```bash
systemctl stop flycast.service
```

For detailed manual configuration, controller mappings, building Flycast, and other Dreamcast games, consult the [original Chinese manual](Manual%20installation.MD).

## Legal notice

Flycast and ReplayOS are separate projects. This repository is a community installation guide/tool and is not affiliated with SEGA. Users must supply their own legally obtained game and BIOS files. Do not upload `naomi.zip` or `vonot.zip` to this repository.
