#!/bin/bash

get_cpu_arch() {
  uname -a | awk '{ print $(NF-1) }'
}

install_go() {
  [ "$SKIP_GO_INSTALLER" = "yes" ] && return 0

  [ -z "$GO_VERSION" ] && GO_VERSION=1.23.3
  [ "$( get_cpu_arch )" = "x86_64" ] && GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  [ "$( get_cpu_arch )" = "aarch64" ] && GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz"

  printf "[-] Installing Go v%s...\n" "$GO_VERSION"
  
  curl -L -s -q -o /tmp/go-${GO_VERSION}.tar.gz "$GO_URL"
  rm -rf $HOME/.local/go && mkdir -p $HOME/.local
  tar xvf /tmp/go-${GO_VERSION}.tar.gz -C $HOME/.local/

  grep 'GO_HOME=' $HOME/.bashrc >/dev/null 2>&1 || {
    printf "
GO_HOME=$HOME/.local/go
export PATH=\$GO_HOME/bin:\$PATH\n" >> $HOME/.bashrc
  }
  
  # Ensure next call for $PATH has newest value
  GO_HOME=$HOME/.local/go
  export PATH=$GO_HOME/bin:$PATH
  
  sudo rm /tmp/go-${GO_VERSION}.tar.gz
  printf "[-] Go has been successfully installed on %s.\n" "\$GO_HOME -> $GO_HOME"
  printf "[-] Run 'source ~/.bashrc' to update PATH.\n"

  return 0
}

install_xcaddy() {
  [ "$SKIP_XCADDY_INSTALLER" = "yes" ] && return 0

  [ -z "$XCADDY_VERSION" ] && XCADDY_VERSION=0.4.4
  [ "$( get_cpu_arch )" = "x86_64" ] && XCADDY_URL="https://github.com/caddyserver/xcaddy/releases/download/v${XCADDY_VERSION}/xcaddy_${XCADDY_VERSION}_linux_amd64.tar.gz"
  [ "$( get_cpu_arch )" = "aarch64" ] && XCADDY_URL="https://github.com/caddyserver/xcaddy/releases/download/v${XCADDY_VERSION}/xcaddy_${XCADDY_VERSION}_linux_arm64.tar.gz"  

  printf "[-] Installing xcaddy v%s...\n" "$XCADDY_VERSION"
  
  curl -L -s -q -o /tmp/xcaddy-${XCADDY_VERSION}.tar.gz "$XCADDY_URL"
  rm -rf $HOME/.local/xcaddy && mkdir -p $HOME/.local/xcaddy/bin
  tar xvf /tmp/xcaddy-${XCADDY_VERSION}.tar.gz -C $HOME/.local/xcaddy/bin/ xcaddy

  grep 'XCADDY_HOME=' $HOME/.bashrc >/dev/null 2>&1 || {
    printf "
XCADDY_HOME=$HOME/.local/xcaddy
export PATH=\$XCADDY_HOME/bin:\$PATH\n" >> $HOME/.bashrc
  }

  # Ensure next call for $PATH has newest value
  XCADDY_HOME=$HOME/.local/xcaddy
  export PATH=$XCADDY_HOME/bin:$PATH

  sudo rm /tmp/xcaddy-${XCADDY_VERSION}.tar.gz
  printf "[-] xcaddy has been successfully installed on %s.\n" "\$XCADDY_HOME -> $XCADDY_HOME"
  printf "[-] Run 'source ~/.bashrc' to update PATH.\n"

  return 0
}

apply_path() {
  # Ensure next call for $PATH has newest value
  GO_HOME=$HOME/.local/go
  export PATH=$GO_HOME/bin:$PATH

  # Ensure next call for $PATH has newest value
  XCADDY_HOME=$HOME/.local/xcaddy
  export PATH=$XCADDY_HOME/bin:$PATH
}

build_caddy_plus_security() {
  [ -z "$CADDY_VERSION" ] && CADDY_VERSION=2.8.4
  [ -z "$SECURITY_VERSION" ] && SECURITY_VERSION=1.1.29
  [ -z "$CADDY_OUTPUT" ] && CADDY_OUTPUT=./out/caddy

  apply_path
  rm -rf ./out/* 2>/dev/null

  printf "[-] Building Caddy v%s with caddy-security v%s...\n" "$CADDY_VERSION" "$SECURITY_VERSION"
  xcaddy build v${CADDY_VERSION} \
    --output "$CADDY_OUTPUT" \
    --with github.com/greenpau/caddy-security@v${SECURITY_VERSION} && \
  printf "[-] Caddy with security plugin has been successfully built. See the ./out/ directory.\n" && \
  cat <<EOF > ./out/release.txt
Caddy with security plugin release:
===================================
- Caddy v${CADDY_VERSION}
- caddy-security v${SECURITY_VERSION}
EOF
}

install_go && install_xcaddy && build_caddy_plus_security