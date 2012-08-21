class Visualization < ActiveRecord::Migration
  def up
    create_table :visualizations, id: false do |t|
      t.string :resource_identifier
      t.integer :user_id
      t.text :control_settings
      t.text :layout
    end
    execute "ALTER TABLE visualizations ADD PRIMARY KEY (user_id,resource_identifier)"
  end

  def down
    drop_table :visualizations
  end
end
