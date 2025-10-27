class AddFullNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :fullname, :string
  end
end
