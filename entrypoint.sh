#!/bin/bash
set -e
container=docker
export container

if [ ! -t 0 ]; then
	echo >&2 'ERROR: TTY needs to be enabled (`docker run -t ...`).'
	exit 1
fi

env >/etc/docker-entrypoint-env

cat >/etc/systemd/system/docker-entrypoint.target <<EOF
[Unit]
Description=the target for docker-entrypoint.service
Requires=docker-entrypoint.service systemd-logind.service systemd-user-sessions.service
EOF

quoted_args="$(printf " %q" "${@}")"
echo "/usr/local/bin/start-xrdp.sh ${quoted_args}" >/etc/docker-entrypoint-cmd

cat >/etc/systemd/system/docker-entrypoint.service <<EOF
[Unit]
Description=docker-entrypoint.service

[Service]
ExecStart=/bin/bash -exc "source /etc/docker-entrypoint-cmd"
# EXIT_STATUS is either an exit code integer or a signal name string, see systemd.exec(5)
ExecStopPost=/bin/bash -ec "if echo \${EXIT_STATUS} | grep [A-Z] > /dev/null; then echo >&2 \"got signal \${EXIT_STATUS}\"; systemctl exit \$(( 128 + \$( kill -l \${EXIT_STATUS} ) )); else systemctl exit \${EXIT_STATUS}; fi"
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
WorkingDirectory=$(pwd)
EnvironmentFile=/etc/docker-entrypoint-env

[Install]
WantedBy=multi-user.target
EOF

systemctl mask systemd-firstboot.service systemd-udevd.service systemd-modules-load.service
systemctl unmask systemd-logind
systemctl enable docker-entrypoint.service

systemd=
if [ -x /lib/systemd/systemd ]; then
	systemd=/lib/systemd/systemd
elif [ -x /usr/lib/systemd/systemd ]; then
	systemd=/usr/lib/systemd/systemd
elif [ -x /sbin/init ]; then
	systemd=/sbin/init
else
	echo >&2 'ERROR: systemd is not installed'
	exit 1
fi
systemd_args="--show-status=false --unit=docker-entrypoint.target"
echo "$0: starting $systemd $systemd_args"
exec $systemd $systemd_args
