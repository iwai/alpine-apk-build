ARG VERSION

FROM alpine:${VERSION}

# coreutils lua-aports
RUN apk -q -U add alpine-sdk \
  && adduser -D packager \
  && addgroup packager abuild \
  && mkdir -p /var/cache/distfiles \
  && chmod g+w /var/cache/distfiles \
  && chgrp abuild /var/cache/distfiles \
  && echo "packager    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD repositories /etc/apk/repositories

#ADD setup.sh /home/packager/bin/setup.sh
# TODO: customize /etc/abuild.conf

WORKDIR /work

USER packager
