class Category < ApplicationRecord
  has_many :goods, dependent: :nullify
  belongs_to :user, optional: true
  validates :name, length: { maximum: 15, message: "は15文字以内で入力してください。" }
end
