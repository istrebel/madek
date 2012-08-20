Visualization.Views.ResourceContext = Backbone.View.extend

  template: JST['visualization/templates/resource_context']

  initialize: ->
    @event = @options.event
    @svg_node = @options.svg_node
    @resource = @options.resource
    @render()
    @delegate_events()

  delegate_events: ->
    @$el.bind "mouseleave", => @$el.remove()
    $(window).bind "blur",  => @$el.remove()

  render: ->
    @setElement JST['visualization/templates/resource_context']({resource:@resource})
    $("#visualization").append @$el
    @$el.position
      my: "center"
      at: "center" 
      of: @svg_node





