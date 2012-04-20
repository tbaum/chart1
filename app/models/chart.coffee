Spine = require('spine')

class Chart extends Spine.Model
  @configure 'Chart', 'name', 'query', 'options'

  @extend Spine.Model.Local

  @filter: (query) ->
    return @all() unless query
    query = query.toLowerCase()
    @select (item) ->
      item.name?.toLowerCase().indexOf(query) isnt -1
  # or item.email?.toLowerCase().indexOf(query) isnt -1

module.exports = Chart