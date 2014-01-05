console.log "i'm index"
require './a'

module.exports = (args...) ->
  console.log 'called with args: ', args...
  return 47

return 46
