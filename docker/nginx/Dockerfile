# syntax=docker/dockerfile:1

FROM nginx:1.27-alpine-slim
ARG S6_OVERLAY_VERSION=3.2.0.0

RUN <<EOF
set -eux
wget -q -P /tmp \
  https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
  https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
rm -f /tmp/s6-overlay*.tar.xz
EOF

COPY ./docker/nginx/s6-rc.d /etc/s6-overlay/s6-rc.d

STOPSIGNAL SIGQUIT

CMD []
ENTRYPOINT ["/init"]

