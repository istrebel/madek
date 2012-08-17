window.Visualization.Functions.create_visualization_controller= (options) ->

  graph = Visualization.Data.graph = {}
  state = Visualization.State

  # graph datastructure
  graph.nodes_hash =  {} # hash with id's as given by the database
  graph.arcs =  []
  $("#graph-data").data("nodes").forEach (n)->
    n.children = []
    n.parents = []
    graph.nodes_hash[n.id] = n
  $("#graph-data").data("arcs").forEach (arc)->
    arc.source = graph.nodes_hash[arc.parent_id]
    arc.target = graph.nodes_hash[arc.child_id]
    graph.arcs.push arc
    graph.nodes_hash[arc.parent_id].children.push arc.child_id
    graph.nodes_hash[arc.child_id].parents.push arc.parent_id
  graph.nodes_array = d3.values(graph.nodes_hash) # for some things a sparse arrays is more convenient
  graph.N = graph.nodes_array.length
  graph.M = graph.arcs.length

  svg = d3.select("svg#drawing").attr("width", 800).attr("height", 800)

  svg_height = ->
    $("#visualization svg").attr("height")
  svg_width = ->
    $("#visualization svg").attr("width")

  layouter = Visualization.Objects.layouter = d3.layout.mds()

  layouter.nodes(graph.nodes_array).links(graph.arcs)

  svg_graph = svg.append("svg:g").attr("id","graph")

  links_vis = svg_graph.selectAll(".link")
    .data(layouter.links()).enter().append("line").attr("class", "link")

  nodes_vis= svg_graph.selectAll("circle.node")
    .data(layouter.nodes()).enter().append("circle").attr("class",(n)->"node #{n.type}").attr("r",10).attr("id",(n)->"resource-#{n.id}")

  redraw = ->
      nodes_vis.attr("cx",(n)->n.x).attr("cy",(n)->n.y)
      links_vis.attr("x1",((e)-> e.source.x)).attr("y1",((e)-> e.source.y))
        .attr("x2",((e)-> e.target.x)).attr("y2",((e)-> e.target.y))
      bbox = state.bbox = Visualization.Functions.bbox  $("#drawing .node")
      bbox_center = state.bbox_center= Visualization.Functions.center_of_box bbox
      svg_graph.select("rect#bbox").remove()
      svg_graph.append("svg:rect").attr("id","bbox").attr("x",bbox[0]).attr("y",bbox[1]).attr("width",bbox[2]-bbox[0]).attr("height",bbox[3]-bbox[1])
      svg_graph.select("circle#center").remove()
      svg_graph.append("svg:circle").attr("id","center").attr("r",2).attr("cx",bbox_center[0]).attr("cy",bbox_center[1])
      scale = state.scale  =  Math.min(svg_width() / (bbox[2] - bbox[0]), svg_height() / (bbox[3] - bbox[1]))
      scaled_bbox_center = bbox_center.map( (x)-> x * scale)
      tx = state.tx =  svg_width()/2 - scaled_bbox_center[0] 
      ty = state.ty = svg_height()/2 - scaled_bbox_center[1] 
      svg_graph.attr("transform","translate(#{tx},#{ty}) scale(#{scale},#{scale}) ")  


  layouter.on "initalization_done", ->
    console.log "mds-layouter initalization_done"
    console.log "current stress #{layouter.stress()}"
    redraw()


  iteration_count = 0
  state.prev_stress = Number.MAX_VALUE
  state.current_stress = NaN
  state.stress_improvement = 1
  state.stress_threshold = 1 / Math.pow(graph.N,2)

  layouter.on "iteration_end", () ->
    console.log "mds-layouter iteration_end #{iteration_count++}"
    if iteration_count % 20 == 0
      redraw()
      state.current_stress = layouter.stress()
      state.stress_improvement = (state.prev_stress - state.current_stress)/state.prev_stress
      state.prev_stress = state.current_stress
      console.log "current stress #{state.current_stress}"
      console.log "state.stress_improvement #{state.stress_improvement}"
    if (state.stress_improvement > state.stress_threshold) 
      setTimeout(layouter.iterate,1)

  layouter.iterate()

 
