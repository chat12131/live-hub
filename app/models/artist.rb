class Artist < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :live_records, -> { attended }, class_name: "LiveSchedule", dependent: :nullify
  has_many :live_schedules, dependent: :nullify
  has_many :goods, dependent: :nullify
  accepts_nested_attributes_for :members, allow_destroy: true, reject_if: :all_blank
  mount_uploader :image, AvatarUploader
  validates :name, presence: true, length: { maximum: 25 }
  validates :nickname, length: { maximum: 10 }
  validate :nickname_required_if_mode_on
  validate :founding_date_not_in_future
  validate :first_show_date_after_founding_date
  validate :first_show_date_not_in_future

  def display_name
    nickname_mode && nickname.present? ? nickname : name
  end

  def non_display_name
    nickname_mode && nickname.present? ? name : nickname
  end

  def combined_name
    return display_name if non_display_name.blank?

    "#{display_name}(#{non_display_name})"
  end

  private

  def nickname_required_if_mode_on
    return unless nickname_mode && nickname.blank?

    errors.add(:nickname, "ニックネームモードが有効の場合、ニックネームは必須です")
  end

  def founding_date_not_in_future
    return unless founding_date && founding_date > Time.zone.today

    errors.add(:founding_date, "結成日は今日より前に設定してください")
  end

  def first_show_date_after_founding_date
    return unless founding_date && first_show_date && first_show_date < founding_date

    errors.add(:first_show_date, "初めて見た日は結成日より前に設定することはできません")
  end

  def first_show_date_not_in_future
    return unless first_show_date && first_show_date > Time.zone.today

    errors.add(:first_show_date, "初めて見た日は今日より前に設定してください")
  end
end
