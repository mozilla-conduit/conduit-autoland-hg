# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM python:3.8.3-slim-buster

ENV USER=app
ENV UID=10001

RUN adduser --disabled-password --uid $UID --gecos "" $USER; \
    mkdir /$USER; \
    chown $USER:$USER /$USER

ENV HG_VERSION=5.3.2

RUN apt-get update; \
    apt-get install -y build-essential openssh-server; \
    pip install --no-cache "mercurial==$HG_VERSION"; \
    mkdir -p /etc/mercurial

RUN hg clone https://hg.mozilla.org/hgcustom/version-control-tools/ /version-control-tools

COPY hgrc /etc/mercurial/hgrc
COPY requirements.txt /requirements.txt
COPY entrypoint /entrypoint
COPY version.json /$USER/version.json

RUN mkdir /repos; \
    chown $USER:$USER /repos; \
    pip install -r /requirements.txt; \
    apt-get autoremove -y build-essential;

RUN mkdir /home/$USER/.ssh; \
    chown $USER:$USER /home/$USER/.ssh; \
    chmod 700 /home/$USER/.ssh

RUN chown $USER:$USER /etc/ssh/ssh_host_rsa_key; \
    chown $USER:$USER /etc/ssh/ssh_host_ecdsa_key; \
    chown $USER:$USER /etc/ssh/ssh_host_ed25519_key;

RUN sed -i 's/^AcceptEnv.*/& AUTOLAND_REQUEST_USER/' /etc/ssh/sshd_config

VOLUME /home/$USER/.ssh
VOLUME /repos

USER $USER
ENTRYPOINT ["/entrypoint"]
CMD []
