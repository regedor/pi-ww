class AddOrganizationIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :organization_id, :integer
  end
end
