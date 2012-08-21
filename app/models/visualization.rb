require 'composite_primary_keys'

class JsonSerializer
  # Called to deserialize data to ruby object.
  def load(data)
    begin
      JSON.parse data
    rescue
      {}
    end
  end

  # Called to convert from ruby object to serialized data.
  def dump(obj)
    begin
     obj.to_json
    rescue
      "{}"
    end
  end
end

class Visualization < ActiveRecord::Base
   self.primary_keys =  :user_id, :resource_identifier
   serialize :control_settings, JsonSerializer.new
   serialize :layout, JsonSerializer.new

   def self.find_or_falsy user_id,resource_identifier
     begin
       Visualization.find user_id,resource_identifier
     rescue 
       nil
     end
   end
end
