resin-device-path
-----------------

[![npm version](https://badge.fury.io/js/resin-device-path.svg)](http://badge.fury.io/js/resin-device-path)
[![dependencies](https://david-dm.org/resin-io/resin-device-path.png)](https://david-dm.org/resin-io/resin-device-path.png)
[![Build Status](https://travis-ci.org/resin-io/resin-device-path.svg?branch=master)](https://travis-ci.org/resin-io/resin-device-path)
[![Build status](https://ci.appveyor.com/api/projects/status/0nor6g1xxtaolih2?svg=true)](https://ci.appveyor.com/project/jviotti/resin-device-path)

**DEPRECATED in favor of verbose objects.**

Parse Resin.io device and partition paths.

Role
----

The intention of this module is to provide low level access to how a Resin.io device and partition paths, used internally in device specifications, are parsed.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Installation
------------

Install `resin-device-path` by running:

```sh
$ npm install --save resin-device-path
```

Documentation
-------------


* [devicePath](#module_devicePath)
  * [.parsePartition(definition)](#module_devicePath.parsePartition) ⇒ <code>Object</code>
  * [.parsePath(definition)](#module_devicePath.parsePath) ⇒ <code>Object</code>

<a name="module_devicePath.parsePartition"></a>
### devicePath.parsePartition(definition) ⇒ <code>Object</code>
**Kind**: static method of <code>[devicePath](#module_devicePath)</code>  
**Summary**: Parse a partition definition  
**Returns**: <code>Object</code> - parsed partition definition  
**Throws**:

- Will throw if partition definition is invalid.

**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| definition | <code>String</code> | partition definition |

**Example**  
```js
devicePath.parsePartition('(4:1)')
{
	primary: 4,
	logical: 1
}
```
<a name="module_devicePath.parsePath"></a>
### devicePath.parsePath(definition) ⇒ <code>Object</code>
**Kind**: static method of <code>[devicePath](#module_devicePath)</code>  
**Summary**: Parse a path definition  
**Returns**: <code>Object</code> - parsed path definition  
**Throws**:

- Will throw if path definition is invalid.

**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| definition | <code>String</code> | path definition |

**Example**  
```js
devicePath.parsePath('/foo/bar.img(4:1):/baz/qux')
{
	input: {
		path: '/foo/bar.img',
		type: 'image'
	},
	partition: {
		primary: 4,
		logical: 1
	},
	file: '/baz/qux'
}
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-device-path/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-device-path/issues](https://github.com/resin-io/resin-device-path/issues)
- Source Code: [github.com/resin-io/resin-device-path](https://github.com/resin-io/resin-device-path)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the MIT license.
