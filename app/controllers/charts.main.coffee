Spine = require('spine')

class Main extends Spine.Stack
  className: 'main stack'

  controllers:
    show: require("controllers/charts.main.Show")
    edit: require("controllers/charts.main.Edit")
    import: require("controllers/charts.main.Import")
    export: require("controllers/charts.main.Export")

module.exports = Main
