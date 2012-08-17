#= require_self
#= require_tree ./d3
#= require_tree ./functions
#= require_tree ./controllers
#= require_tree ./modules
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Visualization =
  Collections: {}
  Data: {}
  Functions: {}
  Models: {}
  Modules: {}
  Objects: {}
  Routers: {}
  Views: {}
  State: {}

 

window.Visualization.init = ->

  Visualization.Objects.router = new Visualization.Routers.Router()
  Backbone.history.start({pushState:true})
  
  Visualization.Objects.visualization_controller = Visualization.Functions.create_visualization_controller()
