class RemovePictureFromDoctors < ActiveRecord::Migration[8.0]
  def change
    remove_column :doctors, :picture, :string
  end
end
