Spine = require('spine')
Chart = require('models/chart')
List = require('spine/lib/list')
$ = Spine.$

class Sidebar extends Spine.Controller
  className: 'sidebar'

  elements:
    '.items': 'items'
    'input': 'search'

  events:
    'keyup input': 'filter'
    'click footer button.import': 'importData'
    'click footer button.export': 'exportData'
    'click footer button.create': 'create'

  constructor: ->
    super
    @html require('views/sidebar')()

    @list = new List
      el: @items,
      template: require('views/item'),
      selectFirst: true

    @list.bind 'change', @change

    @active (params) ->
      @list.change(Chart.find(params.id))

    Chart.bind('refresh change', @render)

  filter: ->
    @query = @search.val()
    @render()

  render: =>
    charts = Chart.filter(@query)
    @list.render(charts)

  change: (item) =>
    @navigate '/charts', item.id

  create: ->
    item = Chart.create()
    @navigate('/charts', item.id, 'edit')

  importData: ->
    @navigate('/charts','', 'import')

  exportData: ->
    @navigate('/charts','', 'export')

module.exports = Sidebar