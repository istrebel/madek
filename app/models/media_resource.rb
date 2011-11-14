class MediaResource < ActiveRecord::Base
  # it's a VIEW !! refactor to STI ??

  ### only for media_entries
  belongs_to :upload_session
  #has_and_belongs_to_many :favorites, :class_name => "MediaEntry", :join_table => "favorites"
  ###
  
  ### only for media_sets
  #tmp# has_and_belongs_to_many :media_entries, :join_table => "media_entries_media_sets", :foreign_key => "media_set_id"
  ###
  
  default_scope order("updated_at DESC")

  scope :media_entries, where(:type => "MediaEntry")
  #scope :media_sets, where(:type => "Media::Set")

  #scope :by_user, lambda {|user| media_entries.joins(:upload_session).where(:upload_sessions => {:user_id => user}) } 
  scope :by_user, lambda {|user| where(:user_id => user) } 
  #scope :not_by_user, lambda {|user| media_entries.joins(:upload_session).where(["upload_sessions.user_id != ?", user]) } 
  scope :not_by_user, lambda {|user| where(["user_id != ?", user]) }
  
  scope :favorites_for_user, lambda {|user|
    media_entries.
    joins("RIGHT JOIN favorites ON media_resources.id = favorites.media_entry_id").
    where(:favorites => {:user_id => user})
  }

  scope :by_media_set, lambda {|media_set|
    media_entries.
    joins("INNER JOIN media_entries_media_sets ON media_resources.id = media_entries_media_sets.media_entry_id").
    where(:media_entries_media_sets => {:media_set_id => media_set})
  } 
  
  def self.reindex
    all.map(&:reindex).uniq
  end
  
  def self.search(q)
    joins("LEFT JOIN full_texts ON (media_resources.id, media_resources.type) = (full_texts.resource_id, full_texts.resource_type)").
    where("MATCH (text) AGAINST (?)", q)    
  end

  def self.accessible_by_user(user, action = :view)
    i = 2 ** Permission::ACTIONS.index(action)

    # TODO complete permission refactoring from Permission#accessible_by_user    
    #1+3+5
    
    # select("r.*").
    # from("media_resources AS r").
    # joins("inner join permissions p ON p.resource_id=r.id AND p.resource_type=r.type").
    # where("(subject_type = 'Group' AND subject_id IN (?)) OR (subject_type = 'User' AND subject_id = ?)", user.groups, user.id).
    # where("action_bits & #{i} AND action_mask & #{i}").
    # group("r.id, r.type")

    where("(media_resources.id, media_resources.type) IN " \
            "(SELECT resource_id, resource_type from permissions " \
              "WHERE (subject_type IS NULL " \
                  "OR (subject_type = 'Group' AND subject_id IN (?)) " \
                  "OR (subject_type = 'User' AND subject_id = ?)) " \
                "AND action_bits & #{i} AND action_mask & #{i})", user.groups, user.id);

    #-# FIXME -2-4
      
  end
  
  
end