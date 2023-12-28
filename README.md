# RayLib-LibVLC-Haxe

![](https://img.shields.io/github/repo-size/MAJigsaw77/raylib-libvlc-haxe) ![](https://badgen.net/github/open-issues/MAJigsaw77/raylib-libvlc-haxe)

A Haxe/[RayLib](https://github.com/raysan5/raylib) example to play videos using [LibVLC](https://www.videolan.org/vlc/libvlc.html).

* **Works only on Linux for now**.

## Instructions

1. Download the repo and extract it.

2. Install the [raylib-haxe](https://github.com/haxeui/raylib-haxe).

   * You should use `Git` to install it.
        ```bash
        haxelib git raylib-haxe https://github.com/haxeui/raylib-haxe.git
        ```

3. Look into [here](https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux#install-required-tools) to install raylib libs in order to compile it.

4. You need to install [`vlc`](https://www.videolan.org/vlc) from your distro's package manager.

    * [Debian](https://debian.org) based distributions:
        ```bash
        sudo apt-get install libvlc-dev
        sudo apt-get install libvlccore-dev
        sudo apt-get install vlc-bin
        ```

    * [Arch](https://archlinux.org) based distributions:
        ```bash
        sudo pacman -S vlc
        ```

    * [Gentoo](https://www.gentoo.org) based distributions:
        ```bash
        sudo emerge media-video/vlc
        ```

5. Run `haxe build.hxml` in the root of the extracted folder and **Well done!**

## Licensing

![](https://github.com/videolan/vlc/raw/master/share/icons/256x256/vlc-xmas.png)

**LibVLC** is the engine of **VLC** released under the **LGPL2.1 License**. Check [VideoLAN.org](https://videolan.org/legal.html) for more information.
