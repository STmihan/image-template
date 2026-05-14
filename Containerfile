FROM ghcr.io/ublue-os/bazzite-deck-nvidia:unstable AS source

RUN dnf5 install -y rpmrebuild && \
    mkdir -p /export && \
    rpmrebuild -p -d /export --notest-install terra-gamescope && \
    rpmrebuild -p -d /export --notest-install terra-gamescope-libs && \
    ls -lh /export/x86_64/

FROM ghcr.io/ublue-os/bazzite-deck-nvidia:stable

COPY --from=source /export/x86_64/terra-gamescope-*.rpm /tmp/gs/

RUN dnf5 -y remove --no-autoremove gamescope gamescope-libs && \
    dnf5 -y install /tmp/gs/terra-gamescope-*.rpm && \
    ln -f /usr/bin/gamescope /usr/sbin/gamescope && \
    rpm -q terra-gamescope terra-gamescope-libs && \
    rm -rf /tmp/gs && \
    ostree container commit

