FROM zasdfgbnmsystem/basic

# setup
COPY yaourt custom_repo.conf /
COPY locale.gen /etc/locale.gen

USER root
RUN pacman -Syu --noconfirm base
RUN cat custom_repo.conf >> /etc/pacman.conf
RUN locale-gen
RUN pacman -Sy --noconfirm archlinuxcn-keyring

# install packages
USER user
RUN  yaourt -Syua --noconfirm && yaourt -S --noconfirm $(grep '^\w.*' /yaourt) && sudo rm /boot/*.img

# setting up services
RUN systemctl enable sshd sddm NetworkManager

# setting up mkinitcpio
RUN sed -i 's/archlinux\/base/zasdfgbnmsystem\/archlinux-kde/g' /etc/docker-btrfs.json
RUN perl -i -p -e 's/(?<=^HOOKS=\()(.*)(?=\))/$1 docker-btrfs/g' /etc/mkinitcpio.conf

# setting up sshd
RUN sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# copy gen_boot
COPY gen_boot /usr/bin

# allow running as xsession
COPY startkde /
CMD [ "dbus-launch", "--exit-with-session", "/startkde" ]