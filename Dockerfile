# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM alpine:3.6

ENV HG_VERSION=4.4

RUN apk update; \
    apk add --no-cache python2 ca-certificates; \
    apk add --no-cache --virtual build-dependencies build-base python-dev py-pip; \
    pip install --no-cache "mercurial>=$HG_VERSION,<$HG_VERSION.99"; \
    mkdir -p /etc/mercurial

COPY hgrc /etc/mercurial/hgrc
COPY requirements.txt /requirements.txt
COPY entrypoint.sh /entrypoint.sh

RUN addgroup -g 10001 app; \
    adduser -D -u 10001 -G app -g app app; \
    mkdir /repos; \
    chown app:app /repos; \
    pip install -r /requirements.txt; \
    apk del build-dependencies

VOLUME /repos

USER app
ENTRYPOINT ["/entrypoint.sh"]
CMD []
