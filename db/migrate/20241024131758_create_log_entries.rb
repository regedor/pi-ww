class CreateLogEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :log_entries do |t|
      t.string :controller_name
      t.text :info

      t.timestamps
    end
  end
end
