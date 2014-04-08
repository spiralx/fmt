
expect = require('chai').expect
utils = require('../src/utils')


describe 'utils.coffee', ->
  describe 'replaceEach()', ->
    it 'should return a function', (done) ->
      expect utils.htmlEscape
        .to.be.instanceof Function
      rep = utils.replaceEach [ /\s+/g, ' ' ], [ /\s/g, '-' ]
      expect rep
        .to.be.instanceof Function
      done()

    it 'should work', (done) ->
      rep = utils.replaceEach [ /^\s+|\s+$/g, '' ], [ /\s+/g, ' ' ], [ /\s/g, '-' ]
      expect rep '\tsome  text\n'
        .to.equal 'some-text'
      done()

  describe 'htmlEscape()', ->
    it 'should escape <, > and & only', (done) ->
      expect utils.htmlEscape 'a <thing> & another <thing>'
        .to.equal 'a &lt;thing&gt; &amp; another &lt;thing&gt;'
      expect utils.htmlEscape 'a "<thing>" & another \'<thing>\''
        .to.equal 'a "&lt;thing&gt;" &amp; another \'&lt;thing&gt;\''
      done()

  describe 'getProperty()', ->
    it 'should get own properties on objects', (done) ->
      obj =
        pos:
          x: 13
          y: -6
        name: 'FooLoc'

      expect utils.getProperty obj, 'name'
        .to.equal 'FooLoc'
      expect utils.getProperty obj, 'pos'
        .to.eql x: 13, y: -6
      expect utils.getProperty obj, 'toString'
        .to.equal ''
      expect utils.getProperty obj, '0'
        .to.equal ''

      done()

    it 'should get items by index for arrays', (done) ->
      arr = [13, -6, 'FooLoc']

      expect utils.getProperty arr, '0'
        .to.equal 13
      expect utils.getProperty arr, '2'
        .to.equal 'FooLoc'

      arr.thing = 'something'

      expect utils.getProperty arr, 'thing'
        .to.equal 'something'
      expect utils.getProperty arr, '8'
        .to.equal ''
      expect utils.getProperty arr, 'toString'
        .to.equal ''

      done()
