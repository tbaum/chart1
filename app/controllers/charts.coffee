Spine = require('spine')
Chart = require('models/chart')
Manager = require('spine/lib/manager')
$ = Spine.$

Main = require('controllers/charts.main')
Sidebar = require('controllers/charts.sidebar')

class Charts extends Spine.Controller
  className: 'charts'

  constructor: ->
    super

    @sidebar = new Sidebar
    @main = new Main

    @routes
      '/charts/:id/edit': (params) ->
        @sidebar.active(params)
        @main.edit.active(params)

      '/charts//import': (params) ->
        @main.import.active(params)

      '/charts//export': (params) ->
        @main.export.active(params)

      '/charts/:id': (params) ->
        @sidebar.active(params)
        @main.show.active(params)

    divide = $('<div />').addClass('vdivide')

    @append @sidebar, divide, @main

    Chart.fetch()

module.exports = Charts