FROM zasdfgbnmsystem/basic

# setup
COPY yaourt custom_repo.conf /
COPY locale.gen /etc/locale.gen

USER root
RUN cat custom_repo.conf >> /etc/pacman.conf
RUN locale-gen
RUN pacman -Sy --noconfirm archlinuxcn-keyring

# install packages
USER user
RUN yaourt -Syu --noconfirm $(grep '^\w.*' /yaourt)
