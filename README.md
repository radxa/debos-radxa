# debos-radxa

## Introduction

This guide describes how to use debos-radxa, based on [debos](https://github.com/go-debos/debos), to generate Radxa system image.

## Build Host

### Required Packages for the Build Host

You must install essential host packages on your build host.
The following command installs the host packages on an Ubuntu distribution

<pre>
$ sudo apt-get install -y git
</pre>

### Install Docker Engine on Ubuntu

See Docker Docs [installing Docker Engineer on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).

## Use Git to Clone debos-radxa

<pre>
radxa@x86-64:~$ cd ~
radxa@x86-64:~$ git clone https://github.com/radxa/debos-radxa.git
</pre>

## Build Your Image

### Part One: Build image step by step

Launch `dev-shell` to get a shell inside debos docker.

<pre>
radxa@x86-64:~$ cd debos-radxa
radxa@x86-64:~/debos-radxa$ ./dev-shell
Building Docker environment...
Sending build context to Docker daemon   2.56kB
Step 1/11 : FROM debian:testing
 ---> fb444549e96f
...
...
...
Step 11/11 : ENV USER=root     HOME=/root
 ---> Using cache
 ---> bc195e420707
Successfully built bc195e420707
Successfully tagged debos-radxa:1
Enter Docker container...
root@terra:~/debos-radxa#
</pre>

Launch `./build.sh` to get build options.

<pre>
root@terra:~/debos-radxa# ./build.sh
TOP DIR = /home/radxa/debos-radxa
====USAGE: build.sh -c <cpu> -b <board> -m <model> -d <distro>  -v <variant> -a <arch> -f <format> [-0]====
Specify -0 to disable debug-shell, useful for automated build.
Options:
  ./build.sh -c rk3399 -b rockpi-4b -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3399 -b rockpi-4b -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3399 -b rockpi-4cplus -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3399 -b rockpi-4cplus -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3566 -b radxa-cm3-io -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3566 -b radxa-cm3-io -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3566 -b radxa-e23 -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3566 -b radxa-e23 -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3568 -b radxa-e25 -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3568 -b radxa-e25 -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3568 -b rock-3a -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3568 -b rock-3a -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3568 -b rock-3b -m debian -d buster -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3568 -b rock-3b -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c rk3588 -b rock-5b -m debian -d bullseye -v xfce4 -a arm64 -f gpt
  ./build.sh -c rk3588 -b rock-5b -m ubuntu -d focal -v server -a arm64 -f gpt
  ./build.sh -c s905y2 -b radxa-zero -m debian -d buster -v xfce4 -a arm64 -f mbr
  ./build.sh -c s905y2 -b radxa-zero -m ubuntu -d focal -v server -a arm64 -f mbr
  ./build.sh -c a311d -b radxa-zero2 -m debian -d buster -v xfce4 -a arm64 -f mbr
  ./build.sh -c a311d -b radxa-zero2 -m ubuntu -d focal -v server -a arm64 -f mbr
</pre>

Start build Image such as rock-5b-ubuntu-focal-server-arm64-gpt image.

<pre>
root@terra:~/debos-radxa# ./build.sh -c rk3588 -b rock-5b -m ubuntu -d focal -v server -a arm64 -f gpt
TOP DIR = /home/radxa/debos-radxa
====Start to build  board system image====
TOP DIR = /home/radxa/debos-radxa
====Start to preppare workspace directory, build====
...
...
...
====debos rock-5b-ubuntu-focal-server-arm64-gpt end====
TOP DIR = /home/radxa/debos-radxa
 System image rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img is generated. See it in /home/radxa/debos-radxa/output
/home/radxa/debos-radxa
====Building  board system image is done====
====Start to clean system images====
TOP DIR = /home/radxa/debos-radxa
I: show all system images:
total 329092
drwxr-xr-x  2 root root      4096 Mar  8 11:09 .
drwxrwxr-x 10 1002 1002      4096 Mar  8 11:08 ..
-rw-r--r--  1 root root    139442 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.bmap
-rw-r--r--  1 root root        90 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.md5.txt
-rw-r--r--  1 root root 336828856 Mar  8 11:07 rock-5b-ubuntu-focal-server-arm64-20220308-1107-gpt.img.xz
====Cleaning system images is done====
root@terra:~/debos-radxa#
</pre>

The generated system images will be copied to `./output` direcotry.

### Part Two: Build image with one line command

#### Example one of building rock-3a-ubuntu-focal-server-arm64-gpt image

In this example we will build ROCK 3A's system image with full options:

<pre>
radxa@x86-64:~$ cd ~
radxa@x86-64:~$ cd debos-radxa/
radxa@x86-64:~/debos-radxa$
radxa@x86-64:~/debos-radxa$ docker run --rm --interactive --tty --device /dev/kvm --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint ./build.sh godebos/debos \
-c rk3568 -b rock-3a -m ubuntu -d focal -v server -a arm64 -f gpt
</pre>

#### Example two of building radxa-zero2-ubuntu-focal-server-arm64-mbr image

You can also build supported configuration with the following commands:

<pre>
radxa@x86-64:~$ cd ~
radxa@x86-64:~$ cd debos-radxa/
radxa@x86-64:~/debos-radxa$ docker run --rm --interactive --tty --device /dev/kvm --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint scripts/build-supported-configuration.sh \
godebos/debos -m ubuntu -b radxa-zero2
</pre>

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
* ROCK Pi 4B
* ROCK Pi 4C Plus

## Default settings

* Default non-root user: rock (password: rock)
* Automatically load Bluetooth firmware after startup
* The first boot will resize root filesystem to use all available disk space
* SSH installed by default
* Hostname: board_name
