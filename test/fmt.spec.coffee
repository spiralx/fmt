
expect = require('chai').expect
{ fmt } = require('../src/fmt')

describe 'fmt.coffee', ->

  describe 'fmt()', ->

    it 'should show plain values', (done) ->
      expect fmt 'foo'
        .to.equal 'foo'
      expect fmt 4
        .to.equal '4'

      done()

    it 'should substitute by position', (done) ->
      expect fmt 'x: {0}', 13
        .to.equal 'x: 13'

      done()
