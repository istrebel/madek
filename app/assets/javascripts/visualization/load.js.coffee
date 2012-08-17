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

  control_panel_model = new Visualization.Models.ControlPanel
      edge_length: 100
      component_separation: 5
      node_radius: 5
      max_set_radius: 25

  control_panel_view = new Visualization.Views.ControlPanel
    model: control_panel_model

  Visualization.Objects.controller = 
    Visualization.Functions.create_visualization_controller
      control_panel_model: control_panel_model
