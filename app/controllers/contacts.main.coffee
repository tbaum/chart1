Spine   = require('spine')
Contact = require('models/contact')
$       = Spine.$

class Show extends Spine.Controller
  className: 'show'
  
  events:
    'click .edit': 'edit'
  
  constructor: ->
    super
    @active @change
  
  render: ->
    console.log "render"
    result = @html require('views/show')(@item)
    console.log result[0]

   drawChart = (target,options) ->
   (response) ->
    if response.isError()
      alert "Error in query: " + response.getMessage() + " " + response.getDetailedMessage()
      return

    data = response.getDataTable()
    cols = {}
    rows = {}

    outputData = new google.visualization.DataTable()
    outputData.addColumn "number", "Clients"
    outputData.addRow [undefined]

    i = 0
    while i < data.getNumberOfRows()
      _host = data.getValue(i, 0) + " " + data.getValue(i, 1)
      _clients = data.getValue i, 2
      _data = data.getValue i, 3

      colId = cols[_host]?= outputData.addColumn "number", _host
      rowId = rows[_clients]?= outputData.addRow()

      outputData.setCell rowId, 0, _clients if colId == 1
      outputData.setCell rowId, colId, _data
      i++

    chart = new google.visualization.LineChart target
    chart.draw outputData,options


   query = "select  host_type,db,clients,results_client from " + tableId + " where " + filter + " op starts with 'read' order by clients"
   gvizQuery = new google.visualization.Query "https://www.google.com/fusiontables/gvizdata?tq=" + encodeURIComponent(query)

   gvizQuery.send drawChart(document.getElementById("visualization-read"),
      title: "Requests/Client (read)"
      hAxis:
        logScale: true
        title: "Clients"
   )
    
  change: (params) =>
    @item = Contact.find(params.id)
    @render()
    
  edit: ->
    @navigate('/contacts', @item.id, 'edit')

class Edit extends Spine.Controller
  className: 'edit'
  
  events:
    'submit form': 'submit'
    'click .save': 'submit'
    'click .delete': 'delete'
    
  elements: 
    'form': 'form'
    
  constructor: ->
    super
    @active @change
  
  render: ->
    @html require('views/form')(@item)
    
  change: (params) =>
    @item = Contact.find(params.id)
    @render()
    
  submit: (e) ->
    e.preventDefault()
    @item.fromForm(@form).save()
    @navigate('/contacts', @item.id)
    
  delete: ->
    @item.destroy() if confirm('Are you sure?')
    
class Main extends Spine.Stack
  className: 'main stack'
    
  controllers:
    show: Show
    edit: Edit
    
module.exports = Main
