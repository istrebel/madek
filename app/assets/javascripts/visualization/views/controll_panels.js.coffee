Visualization.Views.ControlPanel = Backbone.View.extend

  template: """
    <h1>Controls</h1>
    <form>

    <label>Edge-Length: <span id="edge_length_value"></span></label>
    <div id="edge_length"></div>

    <label>Component-Separation: <span id="component_separation_value"></span></label>
    <div id="component_separation"></div>

    <label>Default Node-Radius: <span id="node_radius_value"></span></label>
    <div id="node_radius"></div>

    <label>Maximal, Additional Radius: <span id="max_set_radius_value"></span></label>
    <div id="max_set_radius"></div>
    </form>
  """

  initialize: ->
    model = @options.model
    @el =  $("#controls")
    @render()

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

