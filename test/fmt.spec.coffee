
expect = require('chai').expect
{ fmt } = require('../src/fmt')


# -----------------------------------------------------------------------------

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
      expect fmt 'x: {0}, y: {1}', 13, 'foo'
        .to.equal 'x: 13, y: foo'
      expect fmt 'x: {0}, y: {1} = woo {2}', 13, 'foo', true
        .to.equal 'x: 13, y: foo = woo true'
      expect fmt '{0}, {1}, {0}', 13, false
        .to.equal '13, false, 13'
      expect fmt '{0}, {2}, {0}', 13, false
        .to.equal '13, , 13'
      expect fmt 'last = {-1}', [1..10]...
        .to.equal 'last = 10'

      done()


    it 'should substitute by key', (done) ->
      expect fmt 'a: {a}, foo: {foo}', { a: 1, b: 2, foo: 'Hi!' }
        .to.equal 'a: 1, foo: Hi!'
      expect fmt 'a: {a}, c: {c}', { a: 1, b: 2, foo: 'Hi!' }
        .to.equal 'a: 1, c: '
      expect fmt 'a: {a}, $: {$}', { a: 1, b: 2, $: 'Hi!' }
        .to.equal 'a: 1, $: Hi!'

      done()


    it 'should allow {{ and }} escapes', (done) ->
      expect fmt 'x: {{x}}, x: {x}', x: 99
        .to.equal 'x: {x}, x: 99'
      expect fmt '{{0}} = {0}', 'foo'
        .to.equal '{0} = foo'


      done()


    it 'should use toString to format inputs', (done) ->
      expect fmt 'x: {0}, y: {1} = woo {2}', 13, 'foo', {}
        .to.equal 'x: 13, y: foo = woo [object Object]'
      expect fmt '{0}, {1}, {0}', 13, []
        .to.equal '13, , 13'

      done()


    it 'should support object paths', (done) ->
      obj =
        pos:
          x: 14
          y: -2.2
        name: 'Jill Stern'
        ids: ['fxu', 'zzy', 'moo']

      expect fmt 'name: "{name}"', obj
        .to.equal 'name: "Jill Stern"'
      expect fmt 'position: ({pos})', obj
        .to.equal 'position: ([object Object])'
      expect fmt 'position: ({pos.x}, {pos.y})', obj
        .to.equal 'position: (14, -2.2)'
      expect fmt 'name: "{name}", first id = {ids[0]}', obj
        .to.equal 'name: "Jill Stern", first id = fxu'
      expect fmt 'name: "{name}", last id = {ids[-1]}', obj
        .to.equal 'name: "Jill Stern", last id = moo'

      done()
