FROM registry.fedoraproject.org/fedora-minimal:33

VOLUME [ "/srv/mirror/content" ]

RUN microdnf -y update

ENV PKGS "git rsync zsh hostname bzip2"
RUN microdnf install -y ${PKGS} --nodocs --setopt install_weak_deps=0 && \
    microdnf clean all -y

WORKDIR /srv/mirror

ADD https://pagure.io/quick-fedora-mirror/raw/master/f/quick-fedora-mirror /srv/mirror/
ADD https://pagure.io/quick-fedora-mirror/raw/master/f/quick-fedora-hardlink /srv/mirror/

ADD mirror.zsh /srv/mirror/mirror.zsh
 
RUN chmod +x ./mirror.zsh quick-fedora-mirror quick-fedora-hardlink

ENTRYPOINT /srv/mirror/mirror.zsh
