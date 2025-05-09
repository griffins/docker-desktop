FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive


# Install all packages
RUN apt-get update && apt-get install -y --install-recommends budgie-desktop

# Define package list as a variable
ENV PACKAGES="\
  sudo \
  curl \
  git \
  jq \
  zsh \
  wget \
  lsb-release \
  iputils-ping \
  aria2 \
  xorgxrdp \
  xrdp \
  firefox-esr \
  systemd \
  systemd-sysv \
  dbus \
  dbus-user-session \
  lsb-release \
  gnupg \
  wget \
   atool \
   cabextract \
   lrzip \
   file-roller \
   tumbler \
   nemo \
    gnome-terminal \
  apt-transport-https \
"

RUN apt-get install -y --no-install-recommends $PACKAGES && \
    apt-get remove -y light-locker xscreensaver && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*


# Set zsh as default shell for all users
RUN chsh -s /usr/bin/zsh

# Copy entrypoint and session scripts
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY start-xrdp.sh /usr/local/bin/start-xrdp.sh

# Make them executable
RUN chmod +x /usr/bin/entrypoint.sh /usr/local/bin/start-xrdp.sh

# Expose RDP port
EXPOSE 3389

# Start the system via our entrypoint
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
