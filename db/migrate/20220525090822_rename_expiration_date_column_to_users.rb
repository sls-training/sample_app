class RenameExpirationDateColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :expiration_date, :expiration_at
  end
end
