require 'set'

module GraphQueries

  class << self

  def connected_arcs_query media_resource_ids
    "
      WITH RECURSIVE pair(p,c) as
      (
          SELECT parent_id as p, child_id as c FROM media_resource_arcs 
            WHERE parent_id in (#{media_resource_ids.join(", ")})
             OR child_id in (#{media_resource_ids.join(", ")})
        UNION
          SELECT parent_id as p, child_id as c FROM pair, media_resource_arcs
            WHERE parent_id = pair.c
            OR child_id = pair.p
      ) 
      SELECT id FROM media_resource_arcs, pair
        WHERE media_resource_arcs.parent_id = pair.p
        AND media_resource_arcs.child_id = pair.c
    "
  end

  def connected_arcs media_resource_s
    ids = 
      if media_resource_s.is_a? Array
        media_resource_s.map(&:id)
      else
        [media_resource_s.id]
      end

    if SQLHelper.adapter_is_postgresql? 
      MediaResourceArc.where(" id in ( #{connected_arcs_query(ids)} )")
    else 
      raise "implement me"
    end
  end




  def reachable_arcs_query media_resource_ids
    "
      WITH RECURSIVE pair(p,c) as
      (
          SELECT parent_id as p, child_id as c FROM media_resource_arcs 
            WHERE parent_id in (#{media_resource_ids.join(", ")})
        UNION
          SELECT parent_id as p, child_id as c FROM pair, media_resource_arcs
            WHERE parent_id = pair.c
      ) 
      SELECT id FROM media_resource_arcs, pair
        WHERE media_resource_arcs.parent_id = pair.p
        AND media_resource_arcs.child_id = pair.c
    "
  end

  def reachable_arcs media_resource_s
    ids = 
      if media_resource_s.is_a? Array
        media_resource_s.map(&:id)
      else
        [media_resource_s.id]
      end

    if SQLHelper.adapter_is_postgresql? 
      MediaResourceArc.where(" id in ( #{reachable_arcs_query(ids)} )")
    else 
      arc_ids = Set.new(MediaResourceArc.where("parent_id in (?)",ids).map(&:id))
      begin
        arcs = MediaResourceArc.where("id in ( ? )",arc_ids)
        prev_arc_ids = arc_ids
        arc_ids = arc_ids | MediaResourceArc.where("parent_id in ( ? ) ", arcs.map(&:child_id))
      end while prev_arc_ids != arc_ids
      MediaResourceArc.where("id in ( ? )", arc_ids)
    end
  end

  def descendants media_set_s
    MediaResource.where(" id in ( #{reachable_arcs(media_set_s).select("child_id").to_sql} ) ")
  end


  def user_sets_and_direct_descendant_resources user
    start_set = MediaSet.where(user_id: user.id)
    child_ids = MediaSet.joins(:out_arcs).where(user_id: user.id).select("media_resource_arcs.child_id").to_sql
    target_set = MediaResource.where("id in (#{child_ids})").where(user_id: user.id)
    MediaResource.where(" id in ( #{start_set.select("id").to_sql} UNION #{target_set.select("id").to_sql})")
  end


  def connecting_arcs media_resources
    MediaResourceArc.connecting(media_resources)
  end

  end

end

