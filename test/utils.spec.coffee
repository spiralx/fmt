
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


  describe 'reduce()', ->
    sum = (a, b) -> a + b

    it 'should work with an initial value', (done) ->
      (expect utils.reduce [1..5], sum, 0).to.equal 15
      (expect utils.reduce [1..5], sum, 5).to.equal 20
      done()

    it 'should work without an initial value', (done) ->
      (expect utils.reduce [1..5], sum).to.equal 15
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
