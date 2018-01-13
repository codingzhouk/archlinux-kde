FROM zasdfgbnmsystem/basic

# setup
COPY yaourt custom_repo.conf startkde /
COPY locale.gen /etc/locale.gen

USER root
RUN cat custom_repo.conf >> /etc/pacman.conf
RUN pacman -Sy --noconfirm archlinuxcn-keyring
RUN pacman -Syu --noconfirm

# install packages
USER user
RUN  yaourt -Syua --noconfirm && yaourt -S --noconfirm $(grep '^\w.*' /yaourt) && sudo rm /boot/*.img

USER root

# setting up services
RUN systemctl enable sddm NetworkManager

# setting up mkinitcpio
RUN sed -i 's/basic/archlinux-kde/g' /etc/docker-btrfs.json

USER user
CMD [ "dbus-launch", "--exit-with-session", "/startkde" ]