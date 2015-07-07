m = require('mochainon')
utils = require('../lib/utils')

describe 'Utils:', ->

	describe '.getDevicePathType()', ->

		describe 'given a device path type with a partition', ->

			beforeEach ->
				@devicePath =
					input:
						path: '.'
					partition:
						primary: 2
					file: '/baz/qux'

			it 'should return a type = image', ->
				type = utils.getDevicePathType(@devicePath)
				m.chai.expect(type).to.equal('image')

		describe 'given a device type with a path = .', ->

			beforeEach ->
				@devicePath =
					input:
						path: '.'
					file: '/baz/qux'

			it 'should return a type = archive', ->
				type = utils.getDevicePathType(@devicePath)
				m.chai.expect(type).to.equal('archive')

		describe 'given a device type with a path != .', ->

			beforeEach ->
				@devicePath =
					input:
						path: '/foo/bar.hddimg'
					file: '/baz/qux'

			it 'should return a type = partition', ->
				type = utils.getDevicePathType(@devicePath)
				m.chai.expect(type).to.equal('partition')
