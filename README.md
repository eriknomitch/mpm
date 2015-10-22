# package

A CLI wrapper to unify interaction with multiple package managers across various OSs/distributions.

## Disclaimer

**This currently doesn't do anything yet.**

**This is in EARLY DEVELOPMENT and is HIGHLY EXPERIMENTAL.**

## Usage

```Shell

# Searching (Available Packages)
$ mpm search <query>

# Installing
$ mpm install <package name(s)...>

# Uninstalling
$ mpm uninstall <package name(s)...>

# Listing (Installed Packages)
$ mpm list

```

## Supported Package Managers

### OS X
* [Homebrew](http://brew.sh/) (i.e., `brew`)

### Linux
* [Advanced Packaging Tool](https://wiki.debian.org/Apt) aka APT (i.e., `apt-get`, `apt-cache`, etc.)

## Copyright

Copyright &copy; 2015 Erik Nomitch. See LICENSE.txt for further details.

