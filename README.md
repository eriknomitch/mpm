# mpm (Meta Package Manager)

*A CLI wrapper to unify interaction with multiple package managers across various OSs/distributions.*

The concept of mpm is to create one (meta) package manager syntax/wrapper for the numerous package managers that exist to simplify administration of them.

**_Disclaimer_: This is in early development and is experimental.**

## Usage

```Shell

# Searching (Searches Available Packages)
$ mpm search <query>

# Installing
$ mpm install <package name(s)...>

# Uninstalling
$ mpm uninstall <package name(s)...>

# Listing (Lists Installed Packages)
$ mpm list

# Updating (Updates the Package Index)
$ mpm update

```

## Supported Package Managers

### Linux
* [Advanced Packaging Tool](https://wiki.debian.org/Apt) aka **APT** (i.e., `apt-get`, `apt-cache`, etc.)

### OS X
* [Homebrew](http://brew.sh/) (i.e., `brew`)

## Copyright

Copyright &copy; 2015 Erik Nomitch. See LICENSE.txt for further details.

