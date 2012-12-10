class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.references :user
      t.references :organization
      t.timestamps
    end
    add_index :watches, :user_id
    add_index :watches, :organization_id
  end
end
