# Add Flatpak exports to XDG_DATA_DIRS using the distro's setup script.
if [ -r /etc/profile.d/flatpak.sh ]; then
    . /etc/profile.d/flatpak.sh
fi
