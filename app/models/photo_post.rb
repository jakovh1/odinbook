class PhotoPost < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy

  has_one_attached :image

  before_destroy -> { image.purge_later }
end
