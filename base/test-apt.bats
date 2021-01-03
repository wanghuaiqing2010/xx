#!/usr/bin/env bats

load 'assert'

@test "no_cmd" {
  run xx-apt
  assert_failure
  assert_output --partial "Usage: apt"
}

@test "native" {
  run xx-apt info file
  assert_success
  assert_line "Package: file"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc"
}

@test "amd64" {
  export TARGETARCH=amd64
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:amd64"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-amd64-cross"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-x86-64-linux-gnu"
}

@test "arm64" {
  export TARGETARCH=arm64
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:aarch64"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-arm64-cross"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-aarch64-linux-gnu"
}

@test "arm" {
  export TARGETARCH=arm
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:armhf"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-armhf-cross"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-arm-linux-gnueabihf"
}


@test "armv6" {
  export TARGETARCH=arm
  export TARGETVARIANT=v6
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:armel"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-armel-cross"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-arm-linux-gnueabi"
  unset TARGETVARIANT
}


@test "s390x" {
  export TARGETARCH=s390x
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:s390x"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-s390x-cross"

  # buster has no gcc package for arm64
  if [ "$(uname -m)" == "aarch64" ] && [ "$(cat /etc/debian_version | cut -d. -f 1)" = "10" ]; then
    return
  fi

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-s390x-linux-gnu"
}

@test "ppc64le" {
  export TARGETARCH=ppc64le
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:ppc64el"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-ppc64el-cross"

  # buster has no gcc package for arm64
  if [ "$(uname -m)" == "aarch64" ] && [ "$(cat /etc/debian_version | cut -d. -f 1)" = "10" ]; then
    return
  fi

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-powerpc64le-linux-gnu"
}

@test "386" {
  export TARGETARCH=386
  if ! xx-info is-cross; then return; fi

  run xx-apt info file
  assert_success
  assert_line "Package: file:i386"

  run xx-apt info libc6-dev
  assert_success
  assert_line "Package: libc6-dev-i386-cross"

  run xx-apt info gcc
  assert_success
  assert_line "Package: gcc-i686-linux-gnu"
}
