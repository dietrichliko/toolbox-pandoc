ARG FEDORA_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG TARGETARCH
FROM registry.fedoraproject.org/fedora-toolbox:${FEDORA_VERSION}

LABEL org.opencontainers.image.title="My Pandoc Fedora Toolbox pandoc"
LABEL org.opencontainers.image.description="A Fedora-based development container with pandoc and latex"
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.authors="Dietrich Liko <Dietrich.Liko@oeaw.ac.at>"
LABEL org.opencontainers.image.licenses="MIT"                   
LABEL org.opencontainers.image.source="https://github.com/dietrichliko/toolbox-pandoc"
LABEL org.opencontainers.image.documentation="https://github.com/dietrichliko/toolbox-pandoc/README.md"


RUN dnf -y update && \
    dnf -y copr enable atim/starship && \
    dnf -y copr enable lihaohong/chezmoi && \
    dnf -y install \
        zsh \
        jq \
        chezmoi \
        starship \
        gh \
        direnv \
        krb5-workstation

# Install latex

RUN dnf -y install make texlive-scheme-full && \
    dnf clean all

# Install pandoc

RUN URL=$(curl -s https://api.github.com/repos/jgm/pandoc/releases/latest | jq -r --arg match "${TARGETARCH}.tar.gz" '.assets.[] | select(.name | endswith($match)).browser_download_url');\
    curl -sLO $URL; \
    tar xzvf pandoc-*-linux-${TARGETARCH}.tar.gz --strip-components=1 -C /usr/local; \
    rm pandoc-*-linux-${TARGETARCH}.tar.gz

