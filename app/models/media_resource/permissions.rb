# -*- encoding : utf-8 -*-
class MediaResource < ActiveRecord::Base

  has_many :userpermissions, :dependent => :destroy do
    def allows(user, action)
      where(:user_id => user, action => true).first
    end
    def disallows(user, action)
      where(:user_id => user, action => false).first
    end
  end
  
  has_many :grouppermissions, :dependent => :destroy do
    def allows(user, action)
      joins(:group => :users).where(action => true, :groups_users => {:user_id => user}).first
    end
  end


  class << self 

    def userpermissions_disallowed user,action
      Userpermission.where(action => false, :user_id => user)
    end

    def grouppermissions_not_disallowed user,action
      Grouppermission 
        .where(action => true)
        .joins("INNER JOIN groups_users ON groups_users.group_id = grouppermissions.group_id ")
        .where("groups_users.user_id = #{user.id}")
        .where <<-SQL  
            media_resource_id NOT IN ( 
                #{userpermissions_disallowed(user, action).select("media_resource_id").to_sql} 
            )
            SQL
    end


    def accessible_by_user(user, action = :view)
      action = action.to_sym

      unless user.try(:id)
        where(action => true)
      else
        resource_ids_by_userpermission = Userpermission.select("media_resource_id").where(action => true, :user_id => user)
        resource_ids_by_ownership_or_public_permission = MediaResource.select("media_resources.id").where(["media_resources.user_id = ? OR media_resources.#{action} = ?", user, true])

        where " media_resources.id IN  (
        #{resource_ids_by_userpermission.to_sql} 
          UNION
        #{grouppermissions_not_disallowed(user,action).select("media_resource_id").to_sql} 
          UNION
        #{resource_ids_by_ownership_or_public_permission.to_sql}
                )" 
      end
    end

  end


  def users_permitted_to_act(action)
    # do not optimize away this query as resource.user can be null
    owner_id = User.select("users.id").joins(:media_resources).where("media_resources.id" => id)
    user_ids_by_userpermission= Userpermission.select("user_id").where("media_resource_id" => id).where("userpermissions.#{action}" => true)
    user_ids_dissallowed_by_userpermission = Userpermission.select("user_id").where("media_resource_id" => id).where("userpermissions.#{action}" => false)
    user_ids_by_grouppermission_but_not_dissallowed= Grouppermission.select("groups_users.user_id as user_id").joins(:group).joins("INNER JOIN groups_users ON groups_users.group_id = groups.id").where("media_resource_id" => id).where("grouppermissions.#{action}" => true).where(" user_id NOT IN ( #{user_ids_dissallowed_by_userpermission.to_sql} )")
    user_ids_by_publicpermission= User.select("users.id").joins("CROSS JOIN media_resources").where("media_resources.#{action}" => true)

    User.where " users.id IN (
          #{owner_id.to_sql}
        UNION
          #{user_ids_by_userpermission.to_sql}
        UNION
          #{user_ids_by_grouppermission_but_not_dissallowed.to_sql}
        UNION
          #{user_ids_by_publicpermission.to_sql})"
  end

  def managers
    users_permitted_to_act :manage
  end

  def is_public?
    view?
  end

  def is_private?(user)
    (user_id == user.id and
      not is_public? and
      not userpermissions.where(:view => true).where(["user_id != ?", user]).exists? and
      not grouppermissions.where(:view => true).exists?)
  end


end

