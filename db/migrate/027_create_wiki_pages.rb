class CreateWikiPages < ActiveRecord::Migration

  def up
    create_table :wiki_pages do |t|
      t.integer :creator_id, null: false
      t.integer :updator_id, null: false
      t.string :path
      t.string :title
      t.text :content
      t.timestamps
    end
    add_index :wiki_pages, :creator_id
    add_index :wiki_pages, :path, :unique => true
    add_foreign_key :wiki_pages, :users, column: :creator_id
    add_foreign_key :wiki_pages, :users, column: :updator_id
 
    create_table :wiki_page_versions do |t|
      t.integer :page_id, null: false # Reference to page
      t.integer :updator_id, null: false # Reference to user, updated page
      t.integer :number 
      t.string :comment
      t.string :path
      t.string :title
      t.text :content
      t.timestamp :updated_at
    end
    add_index :wiki_page_versions, :page_id
    add_index :wiki_page_versions, :updator_id
    add_foreign_key :wiki_page_versions, :users, column: :updator_id
    add_foreign_key :wiki_page_versions, :wiki_pages, column: :page_id

  end

  def down
    drop_table :wiki_page_versions
    drop_table :wiki_pages
  end

end
