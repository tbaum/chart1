Spine = require('spine')
Chart = require('models/chart')
$ = Spine.$

class Import extends Spine.Controller
  className: 'import'

  events:
    'submit form': 'submit'
    'click .save': 'submit'

  elements:
    'textarea': 'importData'

  constructor: ->
    super
    @active @change

  render: ->
    @html require('views/import')()

  change: (params) =>
    @render()

  submit: (e) ->
    e.preventDefault()

    for entry in JSON.parse(@importData.val())
      unless Chart.exists entry['id']
        Chart.fromJSON(entry).save()
        
    @navigate('/charts')

module.exports = Import
