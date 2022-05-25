class RenameAuthDigestColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :auth_digest, :auth_token
  end
end
