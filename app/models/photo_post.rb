class PhotoPost < ApplicationRecord
  has_one :post, as: :postable

  has_one_attached :image
end
