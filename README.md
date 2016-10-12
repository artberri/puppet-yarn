# Puppet yarn

[![Build Status](https://travis-ci.org/artberri/puppet-yarn.svg?branch=master)](https://travis-ci.org/artberri/puppet-yarn)

A puppet module to install [Yarn](https://yarnpkg.com) Package Manager.

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with yarn](#setup)
    * [What yarn affects](#what-yarn-affects)
    * [Beginning with yarn](#beginning-with-yarn)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Installing an specific version of Node.js](#installing-an-specific-version-of-nodejs)
    * [Installing multiple versions of Node.js](#installing-multiple-versions-of-nodejs)
    * [Installing Node.js globally](#installing-nodejs-globally)
    * [Installing Node.js global npm packages](#installing-nodejs-global-npm-packages)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Class: yarn](#class-yarn)
    * [Define: yarn::node::install](#define-yarnnodeinstall)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

Yarn is a fast, reliable, and secure dependency manager for npm and bower. This Puppet module simplifies the task of installing it and supports
package, npm or source installation.

## Setup

### What yarn affects

* It will install Yarn.
* It will install `wget`, `tar` and `gzip` packages if you choose the source installation method.

**Node.js requirement:** Yarn requires Node.js to be installed, but this module will not do it. You need to install Node.js by your own, you can
use the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) to do it. Examples are provided with this module.

### Beginning with yarn

To have Puppet install yarn with the default parameters, declare the yarn class:

```puppet
class { 'yarn': }
```

The Puppet module applies a default configuration: installs yarn using the recommended methods, package for Debian and RedHat families
and source for the rest. You can also use `npm` to install it.
Use the [Reference](#reference) section to find information about the class's parameters and their default values.

You can customize parameters when declaring the `yarn` class. For instance, this declaration will install yarn using the `npm` method
for the `foo` user:

```puppet
class { 'yarn':
  user           => 'foo',
  install_method => 'npm',
}
```

## Usage

### Installing Yarn

This is the most common usage for yarn. It installs yarn with default parameters.

```puppet
class { 'yarn': }
```

### Installing Yarn on CentOS with Node.js

The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
for any other module.

```puppet
class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn': }

Package['nodejs'] -> Package['yarn']

if $::osfamily == 'RedHat' and $::operatingsystemrelease =~ /^5\.(\d+)/ {
  class { 'epel': }
  Class['epel'] -> Class['nodejs'] -> Class['yarn']
}

```

### Installing Yarn on Ubuntu with Node.js

The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
for any other module.

```puppet
class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn': }

Package['nodejs'] -> Package['yarn']

```

### Installing Yarn on other Linux distros with Node.js

The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
for any other module.

```puppet
class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn':
  manage_repo    => false,
  install_method => 'source',
  require        => Package['nodejs'],
}

```

### Installing Yarn using npm with Node.js

The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
for any other module.

```puppet
class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn':
  manage_repo    => false,
  install_method => 'npm',
  require        => Class['nodejs'],
}

```

### Remove Yarn

```
class { 'yarn':
  package_ensure => false,
}

```

## Reference

### Class: `yarn`

Guides the basic setup and installation of yarn on your system. It is the only public class.

When this class is declared with the default options, Puppet:

- Installs latest version of yarn.
- Uses package installation for Debian and RedHat families and source installation for the rest.

You can simply declare the default `yarn` class:

``` puppet
class { 'yarn': }
```

**Parameters within `yarn`:**

#### `package_ensure`

What state the package should be in. It will be passed to the `ensure` parameter when the `package` install method is used. If it is
set to `absent` it will remove Yarn for all installation methods.

Default: `present`.

#### `package_name`

The package name. You can include the version also if you are using the `npm` installation method.

Default: `yarn`.

#### `manage_repo`

Allos the module to manage the Yarn repo.

Default: `true` for Debian and RedHat, `false` for the rest.

#### `install_method`

Sets the installation method. Allowed values: `source`, `npm`, `package`.

Default: `package` for Debian and RedHat, `source` for the rest.

- Ensures packages `wget`, `tar` and `gzip` when `source` method is used.

#### `source_install_dir`

The installation directory when `source` installation method is used.

Default: `/opt`.

#### `symbolic_link`

The path to create a symbolic link in order to make yarn available for all users.

Default: `/usr/local/bin/yarn`.

#### `user`

Sets the user for `source` and `npm` installation methods.

Default: `root`.

#### `source_url`

Url to download Yarn when `source` installation method is used.

Default: `https://yarnpkg.com/latest.tar.gz`.

## Limitations

This module can not work on Windows and should work on LINUX systems.

This module is CI tested against [open source Puppet](http://docs.puppetlabs.com/puppet/) on:

- CentOS 7
- Ubuntu 14.04
- Debian 7

This module should also work properly in other distributions and operating systems, such as FreeBSD, Gentoo, and Amazon Linux,
but is not formally tested on them.

Report an [issue](../../issues) if this module does not work properly in any Linux distro.

## Development

### Contributing

This modules is an open project, and community contributions are highly appreciated.

For more information, please read the complete [module contribution guide](CONTRIBUTING.md).

### Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec)
to verify functionality. For detailed information on using these tools, please see their respective documentation.

This project contains tests for [rspec-puppet](http://rspec-puppet.com/) to verify functionality. For detailed information on using
these tools, please see their respective documentation.

#### Testing quickstart

```sh
gem install bundler
bundle install
bundle exec rake test
./spec/run_virtualbox_tests.sh # this will take a long time
```
