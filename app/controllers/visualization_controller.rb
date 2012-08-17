class VisualizationController < ApplicationController
  layout 'visualization'

  respond_to 'html'

  def index
  end

  def my_sets_and_direct_descendants
    render 'index'
  end

  def my_set_component
    connected_set_arcs = GraphQueries.connected_set_arcs MediaSet.find(params[:id])
    @resources = MediaSet.where(user_id: current_user.id).where("id in (?) OR id in (?)", connected_set_arcs.map(&:parent_id),connected_set_arcs.map(&:child_id))
    @arcs =  MediaResourceArc.connecting @resources
    render 'index'
  end

  def my_sets
    @resources = MediaSet.where(user_id: current_user.id)
    @arcs =  MediaResourceArc.connecting @resources
    render 'index'
  end


  def my_media_resources
    @resources = MediaResource.where(user_id: current_user.id)
    @arcs =  MediaResourceArc.connecting @resources
    render 'index'
  end

end
