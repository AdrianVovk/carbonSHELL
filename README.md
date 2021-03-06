**PLEASE GO TO THIS REPO'S UP TO DATE LOCATION, https://source.carbon.sh**


# carbonSHELL
Maintainer: [Adrian Vovk](https://github.com/AdrianVovk)

carbonSHELL (or cSH) is the main graphical interface of [carbonOS](http://carbon.sh)

## Building and running

The shell is designed primarily to run on NixOS, and is therefore built with the [Nix package manager](https://nixos.org/nix). This is the only build dependency, since Nix handles everything else internally.

The shell runs on top of a Wayland compositor called [Wayfire](https://github.com/ammen99/wayfire), and that needs to be built first.

```
$ cd wayfire
$ nix build
```

Once the compositor is built, you can build the shell.

```
[...]
$ cd ../shell
$ nix build
```
Once built, you can start the environment. There are a few ways to achieve this.

First, you can edit `wayfire/config.ini` and change the hardcoded paths used for launching the shell. The paths you need to change all start with `/home/adrian/Development/desktop`. Change this prefix to match the location of this cloned repo. Then run:
```
[...]
$ wayfire/result/bin/wayfire --config wayfire/config.ini
```

Otherwise, you can use two different terminals and run this:
```
$ wayfire/result/bin/wayfire --config wayfire/config.ini
<SWITCH TO A NEW TERMINAL>
$ cd <cloned repo>/shell
$ result/bin/shell && result/bin/shell --wallpaper ../wallpapers/spacex.jpg
<SWITCH BACK TO FIRST TERMINAL>
```

To use Xwayland, either find it in `/nix/store` and add it to `PATH`, or install it using your distro's package manager.

##### Future build process
This is what building and running will look like in the near future:
```
$ cd session/
$ nix build
$ result/bin/carbon-session
```
I will also be moving the entire project to Meson, allowing builds from outside Nix.
