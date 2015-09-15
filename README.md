# package

A CLI wrapper to unify interaction with multiple package managers across various OSs/distributions.

## Disclaimer

**This is in EARLY DEVELOPMENT and is HIGHLY EXPERIMENTAL.**

## Usage

```Shell

# Searching (Available Packages)
$ package search <query>

# Installing
$ package install <package name(s)...>

# Uninstalling
$ package uninstall <package name(s)...>

# Listing (Installed Packages)
$ package list

```

## Supported Package Managers

### OS X
* Homebrew (i.e., `brew`)

### Linux
* Advanced Packaging Tool aka APT (i.e., `apt-get`, `apt-cache`, etc.)

## Copyright

Copyright (c) 2015 Erik Nomitch. See LICENSE.txt for
further details.

