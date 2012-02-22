# coding: UTF-8
require Rails.root+'features/support/persona'

module PersonaFactory 
  extend self

  def create(_persona)
    persona = _persona.to_s
    if FileTest.exist? "features/data/persona/#{persona.downcase}.rb"
      if Persona.get(persona).blank?
        require Rails.root+"features/data/persona/#{persona.downcase}.rb"
        Persona.const_get(persona.camelize).new
        puts "#{persona} was created"
        return Persona.get(persona)
      else
        puts "#{persona} was already created"
      end
    else 
      raise "Persona #{persona} does not exist"
    end
  end
end
