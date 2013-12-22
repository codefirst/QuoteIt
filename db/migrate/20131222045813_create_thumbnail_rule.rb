class CreateThumbnailRule < ActiveRecord::Migration
  def change
    create_table :services do|t|
      t.string :name
      t.string :url
    end

    create_table :thumbnail_rules do |t|
      t.string  :regexp
      t.string  :thumbnail
      t.integer :service_id
    end

    create_table :html_rules do |t|
      t.string :regexp
      t.string :clip
      t.text :transform
      t.integer :service_id
    end
  end
end
