class VisualizationController < ApplicationController
  layout 'visualization'

  respond_to 'html'

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
    binding.pry
  end

end
