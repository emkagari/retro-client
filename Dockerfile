# The build environment: Node 24, Java, FFDec — nothing else to install.
# The repository isn't copied in: it's mounted at /work when running
# (./retro, retro.cmd, the CI), so the image only changes with the tools.
#
#   docker build -t retro-client .
#   docker run --rm -v "$PWD:/work" retro-client build
FROM node:24-bookworm-slim

ARG FFDEC_VERSION=26.2.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends openjdk-17-jre-headless curl unzip zip git ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL -o /tmp/ffdec.zip \
      "https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version${FFDEC_VERSION}/ffdec_${FFDEC_VERSION}.zip" \
 && unzip -q /tmp/ffdec.zip -d /opt/ffdec \
 && rm /tmp/ffdec.zip \
 # The repository is mounted with the host's owner: git must accept it.
 && git config --system safe.directory '*'

# Wins over retro.local.json's "ffdec" (a host path) inside the container.
ENV RETRO_FFDEC=/opt/ffdec/ffdec.jar
# FFDec writes its settings under $HOME: a writable one for any --user.
ENV HOME=/tmp

WORKDIR /work
ENTRYPOINT ["node", "/work/tools/cli.mjs"]
CMD ["help"]
