class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :organization
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :organization_id
  end
end
