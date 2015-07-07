m = require('mochainon')
device = require('../lib/device')

describe 'Device Path:', ->

	describe '.parsePartition()', ->

		it 'should parse primary partition definitions', ->
			partitionDefinition = '(2)'
			m.chai.expect(device.parsePartition(partitionDefinition)).to.deep.equal
				primary: 2

		it 'should parse extended partition definitions', ->
			partitionDefinition = '(4:1)'
			m.chai.expect(device.parsePartition(partitionDefinition)).to.deep.equal
				primary: 4
				logical: 1

		it 'should parse primary partition definitions with multiple numbers', ->
			partitionDefinition = '(123)'
			m.chai.expect(device.parsePartition(partitionDefinition)).to.deep.equal
				primary: 123

		it 'should parse extended partition definitions with multiple numbers', ->
			partitionDefinition = '(4:123)'
			m.chai.expect(device.parsePartition(partitionDefinition)).to.deep.equal
				primary: 4
				logical: 123

		describe 'given invalid partition definitions', ->

			it 'should throw if missing right paren', ->
				partitionDefinition = '(4:1'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (4:1')

			it 'should throw if missing left paren', ->
				partitionDefinition = '4:1)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: 4:1)')

			it 'should throw if missing both parens', ->
				partitionDefinition = '4:1'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: 4:1')

			it 'should throw if using comma as a delimiter', ->
				partitionDefinition = '4,1'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: 4,1')

			it 'should throw if using letters', ->
				partitionDefinition = '(a)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (a)')

			it 'should throw if using a float number', ->
				partitionDefinition = '(4.1)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (4.1)')

			it 'should throw if missing the extended numbers', ->
				partitionDefinition = '(4:)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (4:)')

			it 'should throw if using letters for the primary partition', ->
				partitionDefinition = '(a:1)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (a:1)')

			it 'should throw if using letters for the logical partition', ->
				partitionDefinition = '(4:a)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (4:a)')

			it 'should throw if using letters in both the primary and logical partitions', ->
				partitionDefinition = '(a:a)'
				m.chai.expect ->
					device.parsePartition(partitionDefinition)
				.to.throw('Invalid partition definition: (a:a)')

	describe '.parsePath()', ->

		describe 'given an implicit disk image', ->

			it 'should parse a device path with a non extended partition', ->
				devicePath = '(2):/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '.'
						type: 'image'
					partition:
						primary: 2
					file: '/baz/qux'

			it 'should parse a device path with an extended partition', ->
				devicePath = '(4:1):/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '.'
						type: 'image'
					partition:
						primary: 4
						logical: 1
					file: '/baz/qux'

			it 'should parse a device path without partition', ->
				devicePath = '/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '.'
						type: 'archive'
					file: '/baz/qux'

		describe 'given a explicit disk image', ->

			it 'should parse a device path with a non extended partition', ->
				devicePath = '/foo/bar.img(2):/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '/foo/bar.img'
						type: 'image'
					partition:
						primary: 2
					file: '/baz/qux'

			it 'should parse a device path with an extended partition', ->
				devicePath = '/foo/bar.img(4:1):/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '/foo/bar.img'
						type: 'image'
					partition:
						primary: 4
						logical: 1
					file: '/baz/qux'

			it 'should parse a device path pointing to a hddimg partition file', ->
				devicePath = '/foo/bar.hddimg:/baz/qux'
				m.chai.expect(device.parsePath(devicePath)).to.deep.equal
					input:
						path: '/foo/bar.hddimg'
						type: 'partition'
					file: '/baz/qux'

		describe 'given invalid device paths', ->

			it 'should throw if using Windows paths', ->
				devicePath = 'C:\\foo\\bar.img(4:1):/baz/qux'
				m.chai.expect ->
					device.parsePath(devicePath)
				.to.throw('Invalid device path.')

			it 'should throw if missing file', ->
				devicePath = '/foo/bar.hddimg:'
				m.chai.expect ->
					device.parsePath(devicePath)
				.to.throw('Invalid device path.')
