class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :title
      t.string :subtitle
      t.string :slug
      t.text :description

      t.timestamps
    end
  end
end
