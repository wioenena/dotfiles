#!/usr/bin/env sh

APPS=(
	# --- Graphics & Design ---
	"org.gimp.GIMP"
	"com.github.PintaProject.Pinta"
	"org.upscayl.Upscayl"
	"com.github.finefindus.eyedropper"
	"com.github.huluti.Curtail"
	"io.gitlab.adhami3310.Converter"
	"org.inkscape.Inkscape"
	"org.kde.krita"
	"com.github.libresprite.LibreSprite"
	"org.blender.Blender"

	# --- Audio Control & Effects ---
	"com.github.wwmm.easyeffects"

	# --- Development & Technical Tools & Editors ---
	"me.iepure.devtoolbox"
  "net.werwolv.ImHex"
  "com.getpostman.Postman"

	# --- Communication & Email ---
	"com.discordapp.Discord"

	# --- Productivity & Office ---
	"md.obsidian.Obsidian"

	# --- Music ---
	"com.spotify.Client"

	# --- Multimedia (Video/Audio Players & Editors) ---
	"no.mifi.losslesscut"
	# "org.shotcut.Shotcut"
	"fr.handbrake.ghb"
	"io.github.seadve.Kooha"
	"io.github.seadve.Mousai"

	# --- Security & Privacy ---
	"com.protonvpn.www"
	"me.proton.Pass"
)

echo "Installing flatpak apps..."

flatpak install "${APPS[@]}"

echo "All apps installed."
