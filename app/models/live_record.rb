class LiveRecord < ApplicationRecord
  has_many :goods, dependent: :nullify
  belongs_to :artist, optional: true
  belongs_to :venue
  belongs_to :user
  accepts_nested_attributes_for :venue
  mount_uploader :timetable, AvatarUploader
  mount_uploader :announcement_image, AvatarUploader
  validates :date, presence: true
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0, message: "はマイナスの値を設定できません。", allow_blank: true }
  validates :drink_price, numericality: { greater_than_or_equal_to: 0, message: "はマイナスの値を設定できません。", allow_blank: true }
  validates :memo, length: { maximum: 300, message: "は300文字以内で入力してください。" }
  validate :date_cannot_be_in_the_future

  def date_cannot_be_in_the_future
    return unless date.present? && date > Time.zone.today

    errors.add(:date, "は未来の日付を設定することはできません。")
  end
end
