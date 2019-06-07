class CreatePapers < ActiveRecord::Migration[5.2]
  def change
    create_table :papers do |t|
      t.references :user, foreign_key: true
      t.text :title
      t.text :author
      t.text :bibliograpy
      t.text :link
      t.text :comment
      t.string :image

      t.timestamps
    end
  end
end
