class Good < ApplicationRecord
  belongs_to :user
  belongs_to :live_schedule, optional: true
  belongs_to :artist, optional: true
  belongs_to :member, optional: true
  belongs_to :category
  accepts_nested_attributes_for :category
  validates :price, numericality: { greater_than_or_equal_to: 0, message: "はマイナスの値を設定できません。", allow_blank: true }
  validates :quantity, numericality: { greater_than_or_equal_to: 1, message: "は1以上を設定してください。" }
  validates :name, length: { maximum: 15, message: "は15文字以内で入力してください。" }
  validate :date_cannot_be_in_the_future

  def date_cannot_be_in_the_future
    return unless date.present? && date > Time.zone.today

    errors.add(:date, "は未来の日付を設定することはできません。")
  end
end
