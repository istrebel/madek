# -*- encoding : utf-8 -*-

module MediaResourceModules
  module Filter

    def self.included(base)
      
      # returns a chainable collection of media_resources
      def base.filter(current_user, query = {})
        accepted_keys = [:accessible_action, :favorites, :group, :group_ids, :ids,
                         :media_set_id, :meta_key_id, :meta_term_id, :not_by_current_user,
                         :owner_ids, :permission_presets, :public, :query, :sort, :top_level, :type, :user]
        raise "invalid option" unless query.is_a?(Hash) and (query.keys - accepted_keys).blank?

        resources = if query[:favorites] == "true"
          current_user.favorites
        elsif query[:media_set_id]
          media_set = MediaSet.find(query[:media_set_id])
          media_set.children
        else
          self
        end

        resources = case query[:type]
          when "media_sets"
            r = resources.where(:type => "MediaSet")
            r = r.top_level if query[:top_level]
            r
          when "media_entries"
            resources.where(:type => "MediaEntry")
          when "media_entry_incompletes"
            resources.where(:type => "MediaEntryIncomplete")
          else
            if query[:ids]
              resources.where(:type => ["MediaEntry", "MediaSet", "MediaEntryIncomplete"])
            else
              resources.where(:type => ["MediaEntry", "MediaSet"])
            end
        end.accessible_by_user(current_user, query[:accessible_action])

        resources = resources.where(:id => query[:ids]) if query[:ids]

        resources = case query[:sort].to_s
          when "author"
            resources.ordered_by_author
          when "title"
            resources.ordered_by_title
          when "updated_at", "created_at"
            resources.order("media_resources.#{query[:sort]} DESC")
          when "random"
            if SQLHelper.adapter_is_mysql?
              resources.order("RAND()")
            elsif SQLHelper.adapter_is_postgresql? 
              resources.order("RANDOM()")
            else
              raise "SQL Adapter is not supported" 
            end
        end if query[:sort]

        resources = resources.accessible_by_group(query[:group]) if query[:group]

        resources = resources.where( %Q< media_resources.id  in (
          #{MediaResource
             .grouppermissions_not_disallowed(current_user, :view)
             .where("grouppermissions.group_id in ( ? )", query[:group_ids])
             .select("media_resource_id").to_sql})>) unless query[:group_ids].blank?

        resources = resources.by_user(query[:user]) if query[:user]

        resources = resources.where(:user_id => query[:owner_ids]) unless query[:owner_ids].blank?

        unless query[:permission_presets].blank? 
          presets = PermissionPreset.where(:id => query[:permission_presets])
          resources = resources.where_permission_presets_and_user presets, current_user
        end
        
        # FIXME use presets and :manage permission
        if query[:not_by_current_user]
          resources = resources.not_by_user(current_user)
          resources = case query[:public]
            when "true"
              resources.where(:view => true)
            when "false"
              resources.where(:view => false)
          end
        end

        resources = resources.search(query[:query]) unless query[:query].blank?

        if query[:meta_key_id] and query[:meta_term_id]
          meta_key = MetaKey.find(query[:meta_key_id])
          meta_term = meta_key.meta_terms.find(query[:meta_term_id])
          media_resource_ids = meta_term.meta_data(meta_key).collect(&:media_resource_id)
          resources = resources.where(:id => media_resource_ids)
        end

        resources
      end
    end

  end
end



