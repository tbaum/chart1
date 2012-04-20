require('lib/setup')

Spine = require('spine')
Charts = require('controllers/charts')

class App extends Spine.Controller
  constructor: ->
    super
    @contacts = new Charts
    @append @contacts.active()

    Spine.Route.setup()

module.exports = App