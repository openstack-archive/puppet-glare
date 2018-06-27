Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-glare.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

glare
=======

#### Table of Contents

1. [Overview - What is the glare module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with glare](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)

Overview
--------

The glare module is a part of [OpenStack](https://www.openstack.org), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module its self is used to flexibly configure and manage the glare service for OpenStack.

Module Description
------------------

The glare module is a thorough attempt to make Puppet capable of managing the entirety of glare.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the glare module to assist in manipulation of configuration files.

Setup
-----

**What the glare module affects**

* [Glare](https://github.com/openstack/glare), the glare service for OpenStack.

### Installing glare

    glare is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install glare with:
    puppet module install openstack/glare

### Beginning with glare

To utilize the glare module's functionality you will need to declare multiple resources.

Implementation
--------------

### glare

glare is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
------------

* All the glare types use the CLI tools and so need to be ran on the glare node.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run the tests on the default vagrant node:

```shell
bundle install
bundle exec rake acceptance
```

For more information on writing and running beaker-rspec tests visit the documentation:

* https://github.com/puppetlabs/beaker-rspec/blob/master/README.md

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Release notes for the project can be found at:
  https://docs.openstack.org/releasenotes/puppet-glare

Contributors
------------

* https://github.com/openstack/puppet-glare/graphs/contributors
