Spine = require('spine')
Chart = require('models/chart')

class Show extends Spine.Controller
  className: 'show'

  events:
    'click .edit': 'edit'

  elements:
    'div .graph' : 'graph'

  constructor: ->
    super
    @active @change

  render: ->
    self = this
    @html require('views/show')(@item)
    gvizQuery = new google.visualization.Query "https://www.google.com/fusiontables/gvizdata?tq=" + encodeURIComponent(@item.query)
    gvizQuery.send (response)-> self.createChart.call self, response

  createChart: (response, target) ->
    return @html require('views/error')(message: response.getMessage(), query: @item.query) if response.isError()

    data = response.getDataTable()

    rearanged = new google.visualization.DataTable()
    rearanged.addColumn "number", "Clients"
    rearanged.addRow [undefined]
    cols = {}
    rows = {}
    i = 0
    while i < data.getNumberOfRows()
      _host = data.getValue(i, 0) + " " + data.getValue(i, 1)
      _clients = data.getValue i, 2
      _data = data.getValue i, 3

      colId = cols[_host]?= rearanged.addColumn "number", _host
      rowId = rows[_clients]?= rearanged.addRow()

      rearanged.setCell rowId, 0, _clients if colId == 1
      rearanged.setCell rowId, colId, _data
      i++

    chart = new google.visualization.LineChart @graph[0]
    options = JSON.parse(@item.options)
    options.title ?= @item.name
    chart.draw rearanged, options

  change: (params) =>
    @item = Chart.find(params.id)
    @render()

  edit: ->
    @navigate('/charts', @item.id, 'edit')


module.exports = Show
