class Doctor < ApplicationRecord
  has_one_attached :picture

  def picture_url
    Rails.application.routes.url_helpers.rails_blob_url(picture, only_path: true) if picture.attached?
  end
end
