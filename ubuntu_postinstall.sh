################################################################################
#################################### AUDIO #####################################
################################################################################

# pipewire-audio-client-libraries = pipewire-alsa and pipewire-jack in debian 12 and newer
sudo apt install pipewire pipewire-pulse pipewire-audio-client-libraries wireplumber

# is this really necessary? config files already existed for me
sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire pipewire-pulse
systemctl --user --now enable wireplumber.service
