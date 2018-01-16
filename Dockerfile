# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM alpine:3.6

ENV HG_RELEASE=4.4
EXPOSE 80

# Build/install dependencies
RUN apk update; \
    apk add --no-cache python2 ca-certificates curl bash; \
    apk add --no-cache --virtual build-dependencies build-base python-dev py-pip; \
    pip install --no-cache mercurial==$HG_RELEASE

# hg
RUN mkdir -p /etc/mercurial
COPY hgrc /etc/mercurial/hgrc

# python
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# vct
# XXX RUN hg clone https://hg.mozilla.org/hgcustom/version-control-tools /var/hg/version-control-tools

# users/groups
RUN addgroup -g 1000 hg; \
    adduser -D -u 1000 -G hg -s /bin/bash hg
#   adduser -D autoland; \
#   mkdir /home/autoland/.ssh

# cleanup
RUN apk del build-dependencies

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
