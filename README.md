# Debos

## Introduction

This guide describes how to use Debos tool to generate one system image as well
as the maintenance of the repository.

## Maintenance

### Deploy with github

Github CI is needed.

### How to debug?

#### Build ROCK 3A system image, for example

Build docker and enter docker container.

  ./dev-shell # build docker and enter docker container

Build system image in Docker container.

  ./build.sh # will show usage
  ./build.sh -c rk3568 -b rock-3a -m ubuntu -d focal -v server -a arm64 -f gpt

The generated system images will be copied to debos-radxa/output direcotry.

Once fail to build system image, need debos to go into debug shell environment.

Adding the following options can help.

```
debos --print-recipe --show-boot --debug-shell -v target.yaml
```

Partition root is mounted in /scratch/mnt. Partition boot is mounted in
/scratch/mnt/boot. Once in faker machine shell environment, we can use chroot
to debug.

```
chroot /scratch/mnt
```

### How to maintain this project?

File .../boards/*/packages.list.d/*.list specifies target board kernel packages.

All possible being used packages are located at .../rootfs/packages.

### System features

* Default non-root user: rock (password: rock)
* Automatically load Bluetooth firmware after system startup.
* Resize root filesystem to fit available disk space for the first boot.
* Support SSH by default.
* Hostname: board_name.
