class CreateWebContentsTable < ActiveRecord::Migration
  def change
    create_table :web_contents_tables do |t|
      t.timestamps
      t.text :url, null: false
      t.text :content, null: true
      t.integer :status_code, null: false
    end
  end
end
