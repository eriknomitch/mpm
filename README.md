# mpm (Meta Package Manager)

*A CLI wrapper to unify interaction with multiple package managers across various OSs/distributions.*

The concept of `mpm` is to create a (meta) package manager syntax/wrapper for the numerous package managers that exist to simplify administration of them.

<!---
**_Disclaimer_: This is in early development and is experimental.**
-->

## Usage

```Shell

# Searching (Searches Available Packages)
$ mpm search <query>

# For example:
#  * If you were on Debian, this would execute: apt-cache search <query>
#  * If you were on OS X, this would execute:   brew search <query>

# Installing (base package manager)
$ mpm install <package name(s)...>

# Installing (exterior/additional package managers)
$ mpm /cask install PACKAGE [PACKAGE...]
$ mpm /gem  install GEM [GEM...]
$ mpm /npm  install PACKAGE [PACKAGE...]

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

### Others
* Suggestions? Open a GitHub issue tagged as a *Feature Request*.

## Installation

For now:

```Shell
$ git clone https://github.com/eriknomitch/mpm.git
$ cd mpm
$ bundle install
$ rake install
```
## Copyright

Copyright &copy; 2015 Erik Nomitch. See LICENSE.txt for further details.

