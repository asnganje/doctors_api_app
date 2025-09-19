class AddImgUrlToDoctors < ActiveRecord::Migration[8.0]
  def change
    add_column :doctors, :image_url, :string
  end
end
