class AddAuthDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :auth_digest, :string
    add_column :users, :expiration_date, :datetime
  end
end
