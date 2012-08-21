# -*- encoding : utf-8 -*-
class CreatePeople < ActiveRecord::Migration
  include SQLHelper

  def self.up

    create_table    :people do |t|
      t.string      :firstname
      t.string      :lastname
      t.string      :pseudonym
      t.date        :birthdate
      t.date        :deathdate
      t.string      :nationality
      t.text        :wiki_links

      t.boolean     :delta, :null => false, :default => true
      t.timestamps
    end

    sql = <<-SQL
      ALTER TABLE users ADD CONSTRAINT person_id_fkey
        FOREIGN KEY (person_id) REFERENCES people (id); 
    SQL
    sql.split(/;\s*$/).each {|cmd| execute cmd} if adapter_is_mysql?
    execute sql if adapter_is_postgresql?


  end

  def self.down
    drop_table :people
  end
end
