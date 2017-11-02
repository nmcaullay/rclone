FROM alpine:3.4

MAINTAINER nmcaullay <nmcaullay@gmail.com>

ENV RCLONE_VERSION=current
ENV ARCH=amd64

RUN apk -U add ca-certificates \
    && rm -rf /var/cache/apk/* \
    && cd /tmp \
    && wget -q http://downloads.rclone.org/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    ##&& unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
    && unzip /tmp/rclone-current-linux-${ARCH}.zip \
    && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
    && rm -r /tmp/rclone*
    #&& addgroup rclone \
    #&& adduser -h /config -s /bin/ash -G rclone -D rclone

#Create the HTS user (1000), and add to user group (100)
#RUN addgroup rclone -g 100
RUN adduser -s /bin/ash -g 100 -D rclone -u 1001

USER rclone

VOLUME ["/config"]
VOLUME ["/files"]

ENTRYPOINT ["/usr/bin/rclone", "--config", "/config/rclone.conf", "-v", "--log-file", "/config/rclone.log"]

CMD ["--version"]
