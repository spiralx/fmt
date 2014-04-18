
expect = require('chai').expect
{ classOf, isClass } = require '../src/classof'


# -----------------------------------------------------------------------------

describe 'classof.coffee', ->

  describe 'classOf', ->

    it 'should work for all types', (done) ->
      (expect classOf null).to.equal 'Null'
      (expect classOf undefined).to.equal 'Undefined'
      (expect classOf true).to.equal 'Boolean'
      (expect classOf {}).to.equal 'Object'
      (expect classOf classOf).to.equal 'Function'
      (expect classOf []).to.equal 'Array'
      (expect classOf 1).to.equal 'Number'
      (expect classOf 'foo').to.equal 'String'
      (expect classOf /.*/).to.equal 'RegExp'
      (expect classOf new Date).to.equal 'Date'

      global? and (expect classOf global).to.equal 'Global'
      window? and (expect classOf window).to.equal 'Window'

      Map? and (expect classOf new Map).to.equal 'Map'
      Set? and (expect classOf new Set).to.equal 'Set'

      done()

  describe 'isClass', ->

    it 'should work', (done) ->
      expect isClass 'foo', 'String'
        .to.be.true
      expect isClass 4, 'Number'
        .to.be.true
      expect isClass 'foo', 'Number'
        .to.be.false
      expect isClass 4, 'Object'
        .to.be.false
      expect isClass null, 'Null'
        .to.be.true
      expect isClass isClass, 'Function'
        .to.be.true

      done()

    it 'should work for multiple parameters', (done) ->
      expect isClass 'foo', 'String', 'Number'
        .to.be.true
      expect isClass 4, 'String', 'Number'
        .to.be.true

      done()

    it 'should work for a single parameter with multiple types', (done) ->
      expect isClass classOf, 'String Function'
        .to.be.true
      expect isClass classOf, 'Function Null'
        .to.be.true
      expect isClass classOf, 'String Function Date'
        .to.be.true

      done()
