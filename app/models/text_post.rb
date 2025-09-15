class TextPost < ApplicationRecord
  has_one :post, as: :postable
  validates :content, presence: true, length: { minimum: 3, maximum: 40000 }
end
