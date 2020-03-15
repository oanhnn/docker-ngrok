# Using alpine image to get ngrok because BusyBox wget's issue
# See http://lists.busybox.net/pipermail/busybox-cvs/2018-October/038412.html
FROM alpine:3.11 AS builder

RUN set -eux; \
    apk add wget unzip ; \
    wget -q -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip ; \
    unzip -o ngrok.zip -d /bin/ ; \
    ngrok --version

# Build runtime image
FROM busybox

RUN adduser -h /home/ngrok -D -u 1000 ngrok

COPY entrypoint.sh /
COPY --chown=ngrok ngrok.yml /home/ngrok/.ngrok2/
COPY --from=builder /bin/ngrok /bin/ngrok

USER ngrok
EXPOSE 4040

CMD ["/entrypoint.sh"]
