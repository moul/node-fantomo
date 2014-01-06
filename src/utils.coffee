debug = require('debug') 'fantomo:lib:utils'
fs = require 'fs'
crypto = require 'crypto'
path = require 'path'
request = require 'request'

module.exports.cache_url = (opts, fn) ->
  throw "An url is mandatory" unless opts.url?

  opts.dir ?= '/tmp'
  opts.prefix ?= 'cache-'
  opts.suffix ?= ''

  md5sum = crypto.createHash 'md5'
  md5sum.update opts.url

  # FIXME: find a npmjs module
  filename = opts.prefix + md5sum.digest('hex') + opts.suffix
  filepath = path.join opts.dir, filename

  if fs.existsSync filepath
    debug "Cached version of #{opts.url} exists at #{filepath}"
    fn null, filepath
  else
    debug "Caching #{opts.url} to #{filepath}"
    callback = (err, res, body) ->
      if err
        throw err
      debug "Cached #{body.length} bytes"
      fn err, filepath
    req = request opts.url, callback
    req.pipe(fs.createWriteStream(filepath))

  return filepath
