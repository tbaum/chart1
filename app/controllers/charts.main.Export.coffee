Spine = require('spine')
Chart = require('models/chart')

class Export extends Spine.Controller
  className: 'export'

  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/export')({ exportData: JSON.stringify(Chart.all())})

  change: (params) =>
    @render()

module.exports = Export
