module Json
  module MetaContextHelper

    def hash_for_meta_context(meta_context, with = nil)
      h = {
        name: meta_context.name,
        label: meta_context.label.to_s,
        description: meta_context.description.to_s
      }
      
      if with ||= nil  
        if with[:meta_keys]
          h[:meta_keys] = meta_context.meta_key_definitions.map do |mkd|
            {
              name: mkd.meta_key.label, # TODO td: translate .label to .name
              label: mkd.label.to_s,
              hint: mkd.hint.to_s,
              description: mkd.description.to_s,
              type: MetaDatum.value_type_name(mkd.meta_key.meta_datum_object_type),
              settings: mkd.settings
            }
          end
        end 
      end 
      
      h
    end
  end
end
      