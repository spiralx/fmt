
gulp   = require 'gulp'
plugins = (require 'gulp-load-plugins')()
args = (require 'yargs').argv


# Location of source files and output destinations
config =
  src:
    coffee: './src/**/*.coffee'
  test:
    coffee: './test/**/*.spec.coffee'
  dest:
    js: './lib'


# See http://stackoverflow.com/questions/21602332/catching-gulp-mocha-errors
handleError = (err) ->
  console.warn err
  this.emit 'end'


# e.g. gulp bump --type minor or gulp bump -t major
gulp.task 'bump', ->
  bumpType = args.type ? args.t ? 'patch'

  gulp.src './package.json'
    .pipe plugins.bump { type: bumpType }
    .pipe gulp.dest './'


gulp.task 'coffee', ->
  coff = plugins.coffee { bare: true }
    .on 'error', plugins.util.log

  console.info config.dest.js

  gulp.src config.src.coffee
    .pipe plugins.coffee { bare: true }
    .on 'error', plugins.util.log
    .pipe gulp.dest config.dest.js


gulp.task 'lint', ->
  gulp.src config.src.coffee
    .pipe plugins.coffeelint()
    .pipe plugins.coffeelint.reporter()


gulp.task 'mocha', ['coffee'], ->
  gulp.src config.test.coffee, { read: false }
    .pipe plugins.mocha {
      reporter: 'spec'
    }
    .on 'error', handleError


gulp.task 'test', ['lint', 'mocha']

gulp.task 'build', ['coffee', 'test']

gulp.task 'watch', ['test'], ->
  gulp.watch [ config.src.coffee ], ['build']
  gulp.watch [ config.test.coffee ], ['mocha']

gulp.task 'default', ['build']

