
/*
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */

/**
 * @module devicePath
 */
var utils, _;

_ = require('lodash');

_.str = require('underscore.string');

utils = require('./utils');


/**
 * @summary Parse a partition definition
 * @public
 * @function
 *
 * @param {String} definition - partition definition
 * @returns {Object} parsed partition definition
 *
 * @throws Will throw if partition definition is invalid.
 *
 * @example
 * devicePath.parsePartition('(4:1)')
 * {
 * 	primary: 4,
 * 	logical: 1
 * }
 */

exports.parsePartition = function(definition) {
  var logical, matches, primary, result;
  matches = definition.match(/^\(([0-9]+)(:([0-9]+))?\)$/);
  if (matches == null) {
    throw new Error("Invalid partition definition: " + definition);
  }
  primary = _.parseInt(matches[1]);
  logical = _.parseInt(matches[3]);
  result = {
    primary: primary
  };
  if ((logical != null) && !_.isNaN(logical)) {
    result.logical = logical;
  }
  return result;
};


/**
 * @summary Parse a path definition
 * @public
 * @function
 *
 * @param {String} definition - path definition
 * @returns {Object} parsed path definition
 *
 * @throws Will throw if path definition is invalid.
 *
 * @example
 * devicePath.parsePath('/foo/bar.img(4:1):/baz/qux')
 * {
 * 	input: {
 * 		path: '/foo/bar.img',
 * 		type: 'image'
 * 	},
 * 	partition: {
 * 		primary: 4,
 * 		logical: 1
 * 	},
 * 	file: '/baz/qux'
 * }
 */

exports.parsePath = function(definition) {
  var matches, partition, result;
  if (definition.indexOf(':') === -1) {
    return {
      file: definition
    };
  } else {
    matches = definition.match(/^([^\(\)]+)?(\(.*\))?:(.*)$/);
  }
  if ((matches == null) || _.isEmpty(matches[3])) {
    throw new Error('Invalid device path.');
  }
  result = {
    input: {
      path: matches[1] || '.'
    },
    file: matches[3]
  };
  partition = matches[2];
  if (partition != null) {
    result.partition = exports.parsePartition(partition);
  }
  result.input.type = utils.getDevicePathType(result);
  return result;
};
