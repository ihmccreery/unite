class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.references :user
      t.references :organization
      t.timestamps
    end
    add_index :stars, :user_id
    add_index :stars, :organization_id
  end
end
