class ActsAsMetaCountry < ActiveRecord::Migration
  def self.up
    MetaKey.update_all({:object_type => "MetaCountry"}, {:label => "portrayed object country code"})    
  end

  def self.down
    MetaKey.update_all({:object_type => nil}, {:label => "portrayed object country code"})    
  end
end
