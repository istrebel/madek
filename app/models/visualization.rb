require 'composite_primary_keys'
class Visualization < ActiveRecord::Base
   self.primary_keys =  :user_id, :resource_identifier
   serialize :control_settings
   serialize :layout

   def self.find_or_falsy user_id,resource_identifier
     begin
       super.find
     rescue 
       nil
     end
   end
end
