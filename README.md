# NAOMI Virtual-On: Oratorio Tangram 5.66 on Raspberry Pi 5

Run **Virtual-On: Oratorio Tangram 5.66 (M.S.B.S. Ver. 5.66)** on a Raspberry Pi 5 with ReplayOS and Flycast. This guide is intended for Windows users and focuses on the **Windows one-click installer**.

> **Project status:** This guide targets RePlayOS 2.0.52. The user has tested all four installation modes (NO LINK, MASTER, SLAVE, and SATELLITE) successfully on RePlayOS 2.0.52. The current installer prompts for the SSH password twice.

For the original, detailed Chinese instructions (manual compilation, configuration and troubleshooting), see [Manual installation.MD](Manual%20installation.MD).

## Step 1 — Flash ReplayOS to a microSD card

**On Windows:**

1. Download and install [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
2. Download the Raspberry Pi 5 ReplayOS image from the [ReplayOS download page](https://www.replayos.com/download/). Use **RePlayOS 2.0.52** (image: `replayos-2.0.52-arm64.img.xz`). All four installation modes have been tested successfully on RePlayOS 2.0.52.
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

## Step 3 — Install Git for Windows

Open PowerShell and run:

```powershell
winget install --id Git.Git -e --source winget
```

After installation, close PowerShell and open it again.

## Step 4 — Clone the project

**Do not create `C:\Pi-5_VOOT` or place ROM/BIOS files there before cloning. Git creates this folder for you.**

```powershell
git clone https://github.com/setsuna362/Naomi-Game-Virtual-On-Oratorio-Tangram-5.66-on-Raspberry-Pi-5- C:\Pi-5_VOOT
```

If you have already cloned the project, use `git -C C:\Pi-5_VOOT pull` to get updates instead of cloning again.

## Step 5 — Add ROM and BIOS

**Only after `git clone` succeeds**, copy your own legally obtained `naomi.zip` and `vonot.zip` into `C:\Pi-5_VOOT`. Keep both files zipped. Game ROMs and BIOS files are not distributed by this project.

## Step 6 — Run the installer

```powershell
cd C:\Pi-5_VOOT
.\install.bat
```

The installer requires `install.ps1` alongside `install.bat`. The PowerShell script has now been restored to the main branch. All four installation modes have been tested successfully.

Follow the installer prompts to enter the Raspberry Pi 5 IP and select NO LINK, MASTER, SLAVE, or experimental SATELLITE mode. On a fresh ReplayOS image, SSH credentials are `root` / `replayos`.

## Step 7 — Restart and verify

Once installation completes successfully, restart the Raspberry Pi 5 and check that VOOT 5.66 launches and the selected communication mode is correct.

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
