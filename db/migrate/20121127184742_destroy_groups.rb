class DestroyGroups < ActiveRecord::Migration
  def up
    drop_table :groups
  end

  def down
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.references :organization

      t.timestamps
    end
    add_index :groups, :organization_id
  end
end
