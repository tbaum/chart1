Spine = require('spine')
Chart = require('models/chart')

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
    @html require('views/form')(item: @item, export: JSON.stringify([@item]))

  change: (params) =>
    @item = Chart.find(params.id)
    @render()

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(@form)
    try
      JSON.parse(@item.options)
    catch e
      @html require('views/form')(item: @item, export: JSON.stringify([@item]), error: e)
      return

    @item.save()
    @navigate('/charts', @item.id)

  delete: ->
    @item.destroy() if confirm('Are you sure?')

module.exports = Edit
