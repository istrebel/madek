class VisualizationController < ApplicationController
  layout 'visualization'

  respond_to 'html'

  def index
  end

  def my_sets_and_direct_descendants
    render 'index'
  end

  def my_component
    binding.pry
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
