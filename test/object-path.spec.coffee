
expect = require('chai').expect
{ ObjectPath } = require('../src/object-path')

describe 'object-path.coffee', ->
  describe 'ObjectPath()', ->
    it 'should accept an empty path', (done) ->
      op = new ObjectPath ''
      expect op.pathExpr
        .to.equal ''
      done()

    it 'should accept simple names', (done) ->
      op = new ObjectPath 'foobar'
      expect op.pathExpr
        .to.equal '.foobar'
      op = new ObjectPath '$'
      expect op.pathExpr
        .to.equal '.$'
      done()

    it 'should accept simple indices', (done) ->
      op = new ObjectPath '4'
      expect op.pathExpr
        .to.equal '[4]'
      expect op.elems[0].index
        .to.equal 4
      op = new ObjectPath '-1'
      expect op.pathExpr
        .to.equal '[-1]'
      expect op.elems[0].index
        .to.equal -1
      done()

    it 'should accept .property path elements', (done) ->
      op = new ObjectPath 'foo.bar'
      expect op.pathExpr
        .to.equal '.foo.bar'
      op = new ObjectPath 'foo.bar.x'
      expect op.pathExpr
        .to.equal '.foo.bar.x'
      op = new ObjectPath 'a.b.c.d'
      expect op.pathExpr
        .to.equal '.a.b.c.d'
      op = new ObjectPath '[1].bar'
      expect op.pathExpr
        .to.equal '[1].bar'
      done()

    it 'should accept [index] path elements', (done) ->
      op = new ObjectPath '[0][1][2][3]'
      expect op.pathExpr
        .to.equal '[0][1][2][3]'
      op = new ObjectPath 'foo[0]'
      expect op.pathExpr
        .to.equal '.foo[0]'
      op = new ObjectPath '[3][1][-1]'
      expect op.pathExpr
        .to.equal '[3][1][-1]'
      done()

    it 'should accept all path elements', (done) ->
      op = new ObjectPath 'foo.x[0]'
      expect op.pathExpr
        .to.equal '.foo.x[0]'
      op = new ObjectPath '[3].par[-1].idx'
      expect op.pathExpr
        .to.equal '[3].par[-1].idx'
      op = new ObjectPath '[1].bar[2]'
      expect op.pathExpr
        .to.equal '[1].bar[2]'
      done()
