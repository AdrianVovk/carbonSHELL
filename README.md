# WIP README
---

# Substance OS Desktop
Maintainer: [Adrian Vovk](https://github.com/AdrianVovk)

The Substance OS Desktop (we'll call it the shell from here on out) is the main graphical interface of [Substance OS](http://substanceproject.net

## Building and running
The Substance OS 

The shell runs on top of a Wayland compositor called [Wayfire](https://github.com/ammen99/wayfire), and that needs to be built first.

```
$ cd wlwayfire
$ nix build -f wayfire.nix
```

Once that is built, build the shell.

```
[...]
$ cd ../shell
$ nix build -f shell.nix
```

Then, you can run the shell and the compositor

```
[...]
$ cd ..
$ wlwayfire/result/bin/wayfire --config wlwayfire/wayfire.ini
$ 
```
