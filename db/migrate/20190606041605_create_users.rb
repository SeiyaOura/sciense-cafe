class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.text :profile
      t.string :field
      t.string :position
      t.text :publication
      t.string :image

      t.timestamps
    end
  end
end
