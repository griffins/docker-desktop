FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update

RUN apt-get install -y \
    sudo \
    wget \
    xorgxrdp \
    xrdp && \
    apt remove -y light-locker xscreensaver && \
    apt autoremove -y && \
    rm -rf /var/cache/apt /var/lib/apt/lists

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  systemd systemd-sysv dbus dbus-user-session

RUN apt-get install -y budgie-desktop

RUN apt-get install zsh git -y

RUN chsh -s /bin/zsh

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY start-xrdp.sh /usr/local/bin/start-xrdp.sh

RUN chmod +x /usr/bin/entrypoint.sh /usr/local/bin/start-xrdp.sh

# Docker config
EXPOSE 3389
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
