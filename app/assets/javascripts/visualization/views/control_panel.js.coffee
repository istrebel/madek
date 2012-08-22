Visualization.Views.ControlPanel = Backbone.View.extend

  template: JST['visualization/templates/control_panel']

  initialize: ->
    model = @options.model
    @el =  $("#controls")
    @render()
    $("a#save").bind ("click"), @save_layout_and_control_settings

    $("#edge_length").slider
      min: 10
      step: 10
      max: 200
      change: (event,ui) ->
        $("#edge_length_value").html(ui.value)
      slide: (event,ui) ->
        $("#edge_length_value").html(ui.value)
      stop: (event,ui) ->
        model.set("edge_length",ui.value)
    $("#edge_length").slider('option','value',model.get("edge_length"))

    $("#add_set_set_edge_length").slider
      min: 0
      step: 10
      max: 200
      change: (event,ui) ->
        $("#add_set_set_edge_length_value").html(ui.value)
      slide: (event,ui) ->
        $("#add_set_set_edge_length_value").html(ui.value)
      stop: (event,ui) ->
        model.set("add_set_set_edge_length",ui.value)
    $("#add_set_set_edge_length").slider('option','value',model.get("add_set_set_edge_length"))


    $("#component_separation").slider
      min: 2
      step: 1
      max: 20
      change: (event,ui) ->
        $("#component_separation_value").html(ui.value)
      slide: (event,ui) ->
        $("#component_separation_value").html(ui.value)
      stop: (event,ui) ->
        model.set("component_separation",ui.value)
    $("#component_separation").slider('option','value',model.get("component_separation"))

    $("#node_radius").slider
      min: 2.5
      step: 2.5
      max: 10
      change: (event,ui) ->
        $("#node_radius_value").html(ui.value)
      slide: (event,ui) ->
        $("#node_radius_value").html(ui.value)
      stop: (event,ui) ->
        model.set("node_radius",ui.value)
    $("#node_radius").slider('option','value',model.get("node_radius"))

    $("#max_set_radius").slider
      min: 0
      step: 5
      max: 50
      change: (event,ui) ->
        $("#max_set_radius_value").html(ui.value)
      slide: (event,ui) ->
        $("#max_set_radius_value").html(ui.value)
      stop: (event,ui) ->
        model.set("max_set_radius",ui.value)
    $("#max_set_radius").slider('option','value',model.get("max_set_radius"))


  render: ->
    $(@el).html @template


  save_layout_and_control_settings: =>
    #TODO get the control_panel in a different way
    data= 
      layout: Visualization.Objects.controller.export_layout()
      control_settings: Visualization.Objects.control_panel_model.attributes
      resource_identifier: $("#layout-data").data("resource-identifier")
    $.ajax
      type: 'PUT'
      url: "/visualization"
      data: data


