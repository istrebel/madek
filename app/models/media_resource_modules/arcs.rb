# -*- encoding : utf-8 -*-

module MediaResourceModules
  module Arcs

    def self.included(base)
      base.class_eval do
        has_many :out_arcs, :class_name => "MediaResourceArc", :foreign_key => :parent_id
        has_many :in_arcs, :class_name => "MediaResourceArc", :foreign_key => :child_id
  
        has_many :parent_sets, :through => :in_arcs, :source => :parent
  
  
        # TODO move down to MediaSet, it's currently here because the favorites
        scope :top_level, joins("LEFT JOIN media_resource_arcs ON media_resource_arcs.child_id = media_resources.id").
                          where(:media_resource_arcs => {:parent_id => nil})
        
        scope :relative_top_level, select("DISTINCT media_resources.*").
                                    joins("LEFT JOIN media_resource_arcs msa ON msa.child_id = media_resources.id").
                                    joins("LEFT JOIN media_resources mr2 ON msa.parent_id = mr2.id AND mr2.user_id = media_resources.user_id").
                                    where(:mr2 => {:id => nil})
      end
    end

    def size
      GraphQueries.descendants(self).size
    end

    def parents 
      case type
        when "MediaSet"
          parent_sets
        when "MediaEntry"
          media_sets
        else
          raise "parents is not supported (yet) for your type"
      end
    end

    ### Descendants #######################################
    
    # set condition must be a query that returns media_resources; 
    # condition is on the inclution of the arcpoints
    def self.descendant_resources(media_set, set_condition=nil)
      where <<-SQL
      id in  (
        WITH RECURSIVE pair(p,c) AS
        (
          SELECT parent_id as p, child_id as c FROM media_resource_arcs 
            WHERE parent_id in (#{media_set.id})
            #{ "AND parent_id in (#{set_condition.select("media_resources.id").to_sql })" if set_condition }
            #{ "AND child_id in (#{set_condition.select("media_resources.id").to_sql})" if set_condition }
          UNION
            SELECT media_resource_arcs.parent_id as p, media_resource_arcs.child_id as c FROM pair, media_resource_arcs
            WHERE media_resource_arcs.parent_id = pair.c
            #{ "AND media_resource_arcs.parent_id in (#{set_condition.select("media_resources.id").to_sql})"  if set_condition }
        )
        SELECT pair.c from pair
      )
      SQL
    end

  end
end



