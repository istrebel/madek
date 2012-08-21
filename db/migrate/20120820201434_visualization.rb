class Visualization < ActiveRecord::Migration
  def up
    create_table :visuazlizations do |t|
      t.string :resource_identifier
      t.integer :user_id
      t.text :control_settings
      t.text :layout
    end
  end

  def down
    drop_table :visuazlizations
  end
end
