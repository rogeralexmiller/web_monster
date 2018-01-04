class CreateWebContentsTable < ActiveRecord::Migration
  def change
    create_table :web_contents do |t|
      t.timestamps
      t.text :url, null: false
      t.text :content, null: true
    end
  end
end
