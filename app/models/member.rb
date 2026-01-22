class Member < ApplicationRecord
  belongs_to :artist
  has_many :goods, dependent: :nullify
end
