class RemoveUpdatedAtFromLogEntries < ActiveRecord::Migration[7.2]
  def change
    remove_column :log_entries, :updated_at, :datetime
  end
end
