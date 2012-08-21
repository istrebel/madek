# -*- encoding : utf-8 -*-
class CreatePreviews < ActiveRecord::Migration

  def up
    create_table :previews, :force => true do |t|
      t.belongs_to :media_file

      t.integer    :height
      t.integer    :width
      t.string     :content_type
      t.string     :filename
      t.string     :thumbnail

      t.timestamps
    end

    add_index :previews, :media_file_id

    add_foreign_key :previews, :media_files , dependent: :delete
  end

  def down
    drop_table :previews
  end

end
