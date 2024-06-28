################################################################################
#################################### AUDIO #####################################
################################################################################

# pipewire-audio-client-libraries = pipewire-alsa and pipewire-jack in debian 12 and newer
# pavucontrol can be used to control pipewire when pipewire-pulse plugin is installed
sudo apt install pipewire pipewire-pulse pipewire-audio-client-libraries wireplumber pavucontrol

# is this really necessary? config files already existed for me
sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire pipewire-pulse
systemctl --user --now enable wireplumber.service
