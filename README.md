# debos-radxa

## Introduction

This guide describes how to use debos-radxa, based on [debos](https://github.com/go-debos/debos), to generate Radxa system image.

## Usage

In this example we will build ROCK 3A's system image with full options:

```
docker run --rm --interactive --tty --device /dev/kvm --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint ./build.sh godebos/debos \
-c rk3568 -b rock-3a -m ubuntu -d focal -v server -a arm64 -f gpt
```

You can also build supported configuration with the following command:

```
docker run --rm --interactive --tty --device /dev/kvm --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint scripts/build-supported-configuration.sh \
godebos/debos -m ubuntu -b radxa-zero2
```

The generated system images will be copied to `./output` direcotry. You can specify different configuration in the 3rd line.

Note: GitHub Actions uses some different options for `docker run` due to their runners do not support nested virtualization (i.e. no `/dev/kvm`). In that's your case you need to specify `--tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g` instead of `--device /dev/kvm`. It also uses a wrapper script to only build the supported configurations.

## How to debug errors

Launch `dev-shell` to get a shell inside debos docker. You can then run `build.sh` to monitor the build status. debos mounts root partition at `/scratch/mnt`, and boot partition is mounted at `/scratch/mnt/boot`. You can also `chroot /scratch/mnt` to examine the file system.

Currently `dev-shell` uses a custom docker image to build, so your result might be different from GitHub build. If you want to reproduce GitHub build please use the command from Usage section.

## Add support for new boards

`./boards/*/packages.list.d/*.list` are board-specific debos recipes.

`./rootfs/packages` contains additional packages.

## Supported boards

* Radxa CM3
* Radxa E23
* Radxa E25
* Radxa Zero
* Radxa Zero 2
* ROCK 3A
* ROCK 3B
* ROCK 5B
* ROCK Pi 4C Plus

## Default settings

* Default non-root user: rock (password: rock)
* Automatically load Bluetooth firmware after startup
* The first boot will resize root filesystem to use all available disk space
* SSH installed by default
* Hostname: board_name
