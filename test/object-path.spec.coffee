
expect = require('chai').expect
{ ObjectPath, PathElement, PropertyElement, IndexElement } = require('../src/object-path')


# -----------------------------------------------------------------------------

_test_obj =
  foo:
    ids: [1..10]
    name: 'John Smith'
  bar:
    x: [ { a: 1, b: 2 }, new Date() ]
  v: 100
  a: [5, 8]


_test_arr = [ 16, { a: 1, b: 2 }, new Date() ]
_test_empty_arr = []


# -----------------------------------------------------------------------------

describe 'object-path.coffee', ->

  describe 'PathElement()', ->

    it 'should set the key and depth', (done) ->
      pe = new PathElement 'test', 0
      expect pe.key
        .to.equal 'test'
      expect pe.depth
        .to.equal 0

      pe = new PathElement 5, 2
      expect pe.key
        .to.equal 5
      expect pe.depth
        .to.equal 2

      done()


    it 'should accept default depth param', (done) ->
      expect new PathElement 'foo'
        .to.be.ok
      expect (new PathElement 'foo').depth
        .to.equal 0

      done()


    it 'should display the correct string from toString', (done) ->
      pe = new PathElement 'test', 0
      expect pe.toString()
        .to.equal 'PathElement(k: "test", d: 0)'

      pe = new PathElement 5, 2
      expect pe.toString()
        .to.equal 'PathElement(k: "5", d: 2)'

      done()


  # ---------------------------------------------------------------------------

  describe 'PropertyElement()', ->

    it 'should accept only valid property names', (done) ->
      expect new PropertyElement 'foo'
        .to.be.ok.and.have.property 'key', 'foo'
      expect (-> new PropertyElement 5)
        .to.throw TypeError

      done()


    it 'should have the correct pathExpr output', (done) ->
      expect (new PropertyElement 'foo').pathExpr()
        .to.equal '.foo'
      expect (new PropertyElement 'foo', 12).pathExpr()
        .to.equal '.foo'
      expect (new PropertyElement '$').pathExpr()
        .to.equal '.$'

      done()


    it 'should resolve properties', (done) ->
      expect (new PropertyElement 'v').resolve _test_obj
        .to.equal 100
      expect (new PropertyElement 'x').resolve _test_obj
        .to.be.undefined
      expect (new PropertyElement 'a').resolve _test_obj
        .to.eql [5, 8]

      done()


  # ---------------------------------------------------------------------------

  describe 'IndexElement()', ->

    it 'should accept only valid array indices', (done) ->
      expect (-> new IndexElement 'foo')
        .to.throw TypeError
      expect new IndexElement 5
        .to.be.ok.and.have.property 'key', 5
      expect new IndexElement
        .to.be.ok.and.have.property 'key', 0
      expect new IndexElement -1
        .to.be.ok.and.have.property 'key', -1

      done()


    it 'should have the correct pathExpr output', (done) ->
      expect (new IndexElement 5).pathExpr()
        .to.equal '[5]'
      expect (new IndexElement 5, 1).pathExpr()
        .to.equal '[5]'
      expect (new IndexElement).pathExpr()
        .to.equal '[0]'
      expect (new IndexElement -2).pathExpr()
        .to.equal '[-2]'

      done()


    it 'should resolve properties', (done) ->
      # { IndexElement } = require('./src/object-path'); op = new IndexElement 0; arr = [ 16, { a: 1, b: 2 }, new Date() ]; op.resolve arr
      expect (new IndexElement 0).resolve _test_arr
        .to.equal 16
      expect (new IndexElement 2).resolve _test_arr
        .to.be.a 'date'
      expect (new IndexElement -1).resolve _test_arr
        .to.be.a 'date'
      expect (new IndexElement 1).resolve _test_empty_arr
        .to.be.undefined
      expect (new IndexElement -5).resolve _test_arr
        .to.be.undefined

      done()


  # ---------------------------------------------------------------------------

  describe 'ObjectPath()', ->

    it 'should accept no path', (done) ->
      expect (op = new ObjectPath)
        .to.be.ok.and.have.property 'pathExpr', '.'
      expect op.elems
        .to.eql []
      done()



    it 'should accept simple names', (done) ->
      op = new ObjectPath 'foobar'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf PropertyElement
        .and.have.property 'key', 'foobar'
      expect op.pathExpr
        .to.equal '.foobar'

      op = new ObjectPath '$'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf PropertyElement
        .and.have.property 'key', '$'
      expect op.pathExpr
        .to.equal '.$'

      op = new ObjectPath '.foobar'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf PropertyElement
        .and.have.property 'key', 'foobar'
      expect op.pathExpr
        .to.equal '.foobar'

      done()


    it 'should accept simple indices', (done) ->
      op = new ObjectPath '4'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf IndexElement
        .and.have.property 'key', 4
      expect op.pathExpr
        .to.equal '[4]'

      op = new ObjectPath '-1'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf IndexElement
        .and.have.property 'key', -1
      expect op.pathExpr
        .to.equal '[-1]'

      op = new ObjectPath '[4]'
      expect op.elems
        .to.have.property 'length', 1
      expect op.elems[0]
        .to.be.instanceOf IndexElement
        .and.have.property 'key', 4
      expect op.pathExpr
        .to.equal '[4]'

      done()


    it 'should accept .property path elements', (done) ->
      op = new ObjectPath 'foo.bar'
      expect op.elems
        .to.have.property 'length', 2
      expect op.pathExpr
        .to.equal '.foo.bar'

      op = new ObjectPath 'foo.bar.x'
      expect op.elems
        .to.have.property 'length', 3
      expect op.pathExpr
        .to.equal '.foo.bar.x'

      op = new ObjectPath 'a.b.c.d'
      expect op.elems
        .to.have.property 'length', 4
      expect op.pathExpr
        .to.equal '.a.b.c.d'

      op = new ObjectPath '[1].bar'
      expect op.elems
        .to.have.property 'length', 2
      expect op.pathExpr
        .to.equal '[1].bar'

      done()


    it 'should accept [index] path elements', (done) ->
      op = new ObjectPath '[0][1][2][3]'
      expect op.elems
        .to.have.property 'length', 4
      expect op.pathExpr
        .to.equal '[0][1][2][3]'

      op = new ObjectPath 'foo[0]'
      expect op.elems
        .to.have.property 'length', 2
      expect op.pathExpr
        .to.equal '.foo[0]'

      op = new ObjectPath '[3][1][-1]'
      expect op.elems
        .to.have.property 'length', 3
      expect op.pathExpr
        .to.equal '[3][1][-1]'

      done()


    it 'should accept all path elements', (done) ->
      op = new ObjectPath 'foo.x[0]'
      expect op.elems
        .to.have.property 'length', 3
      expect op.pathExpr
        .to.equal '.foo.x[0]'

      op = new ObjectPath '[3].par[-1].idx'
      expect op.elems
        .to.have.property 'length', 4
      expect op.pathExpr
        .to.equal '[3].par[-1].idx'

      op = new ObjectPath '[1].bar[2]'
      expect op.elems
        .to.have.property 'length', 3
      expect op.pathExpr
        .to.equal '[1].bar[2]'

      done()


    it 'should resolve correctly', (done) ->
      # { ObjectPath } = require('./src/object-path'); op = new ObjectPath 'a[0]'; obj = a: [5, 8]; op.resolve obj
      expect (new ObjectPath 'v').resolve _test_obj
        .to.equal 100

      expect (new ObjectPath 'a').resolve _test_obj
        .to.be.an 'array'
        .and.eql [5, 8]
      expect (new ObjectPath 'a[0]').resolve _test_obj
        .to.equal 5

      expect (new ObjectPath 'foo.ids[0]').resolve _test_obj
        .to.equal 1
      expect (new ObjectPath 'foo.ids[-10]').resolve _test_obj
        .to.equal 1

      expect (new ObjectPath 'foo.name').resolve _test_obj
        .to.equal 'John Smith'
      expect (new ObjectPath 'bar.x[0].a').resolve _test_obj
        .to.equal 1

      done()
