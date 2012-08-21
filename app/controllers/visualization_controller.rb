class VisualizationController < ApplicationController
  layout 'visualization'
  respond_to 'html','json'

  def index
  end

  def my_component_with
    connected_user_arcs = GraphQueries.connected_user_arcs MediaResource.find(params[:id]), current_user
    @resources = MediaResource.where("id in (?) OR id in (?)", connected_user_arcs.map(&:parent_id),connected_user_arcs.map(&:child_id))
    @arcs =  MediaResourceArc.connecting @resources
    render 'index'
  end

  def my_sets
    @resources = MediaSet.where(user_id: current_user.id)
    @arcs = MediaResourceArc.connecting @resources
    render 'index'
  end

  def my_descendants_of
    set = MediaSet.find(params[:id])
    @resource_identifier = "descendants-#{set.id}"
    set_layout_and_control_variables
    @resources = MediaResource.descendants_and_set(set,MediaResource.where("user_id = ?",current_user.id))
    @arcs = MediaResourceArc.connecting @resources
    render 'index'
  end

  def my_media_resources
    @resources = MediaResource.where(user_id: current_user.id)
    @arcs =  MediaResourceArc.connecting @resources
    render 'index'
  end

  def put
     if visualization = Visualization.find_or_falsy(current_user.id,params[:resource_identifier])
       visualization.update_attribute :control_settings, params[:control_settings]
     else
       visualization = Visualization.create user_id: current_user.id, 
         resource_identifier: params[:resource_identifier], 
         control_settings: params[:control_settings]
     end
     respond_with visualization
  end

  def set_layout_and_control_variables
    if visualization = Visualization.find_or_falsy(current_user.id, @resource_identifier)
      @control_settings = visualization.control_settings
      @layout = visualization.layout
    else
      @control_settings = {}
      @layout = {}
    end
  end

end
