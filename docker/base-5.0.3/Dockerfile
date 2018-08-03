FROM ubuntu:14.04

RUN \
  apt-get update && \
  echo 'golang-go golang-go/dashboard boolean false' | debconf-set-selections && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  git \
  zsh=5.0.2-3ubuntu6.2 \
  mercurial \
  subversion \
  golang \
  jq \
  node \
  ruby \
  python \
  python-virtualenv

RUN adduser --shell /bin/zsh --gecos 'fred' --disabled-password fred
RUN locale-gen "en_US.UTF-8"

COPY docker/fred-sudoers /etc/sudoers.d/fred

USER fred
WORKDIR /home/fred
ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color
ENV DEFAULT_USER=fred
ENV POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

RUN touch .zshrc

CMD ["/bin/zsh", "-l"]
