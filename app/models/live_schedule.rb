class LiveSchedule < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :venue
  belongs_to :user
  accepts_nested_attributes_for :venue
  mount_uploader :timetable, AvatarUploader
  mount_uploader :announcement_image, AvatarUploader
  validates :date, presence: true
  validate :ticket_sale_date_validation, if: :planned?
  before_save :clear_ticket_sale_date_if_not_unpurchased, if: :planned?
  validates :ticket_price, numericality: { greater_than_or_equal_to: 0, message: "はマイナスの値を設定できません。", allow_blank: true }
  validates :drink_price, numericality: { greater_than_or_equal_to: 0, message: "はマイナスの値を設定できません。", allow_blank: true }
  validates :memo, length: { maximum: 300, message: "は300文字以内で入力してください。" }
  validate :date_cannot_be_in_the_past, if: :planned?
  validate :date_cannot_be_in_the_future, if: :attended?
  validate :start_time_after_open_time
  validate :ticket_sale_time_before_start_time_on_same_day

  enum ticket_status: {
    未購入: 0,
    購入済: 1,
    当日のみ: 2,
    チケ無し: 3
  }
  
  scope :planned, -> { where("date >= ?", Time.zone.today) }
  scope :attended, -> { where("date < ?", Time.zone.today) }
  scope :live_records, -> { attended }
  scope :live_schedules, -> { planned }


  def ticket_sale_date_validation
    return if ticket_sale_date.blank?

    errors.add(:ticket_sale_date, "は作成日以降である必要があります。") if ticket_sale_date < Time.zone.today
    errors.add(:ticket_sale_date, "はライブの日付より後である必要があります。") if ticket_sale_date.to_date > date
  end

  def date_cannot_be_in_the_past
    return unless date.present? && date < Time.zone.today

    errors.add(:date, "は過去の日付を設定することはできません。")
  end

  def planned?
    date.present? && date >= Time.zone.today
  end

  def date_cannot_be_in_the_future
    return unless date.present? && date > Time.zone.today

    errors.add(:date, "は未来の日付を設定することはできません。")
  end

  def attended?
    date.present? && date < Time.zone.today
  end

  def days_until_live
    return nil unless date

    (date - Time.zone.today).to_i
  end

  def days_until_label
    return nil unless date

    days = days_until_live
    return "今日" if days.zero?

    "あと#{days}日"
  end

  def clear_ticket_sale_date_if_not_unpurchased
    return unless ticket_status != "未購入"

    self.ticket_sale_date = nil
  end

  def start_time_after_open_time
    return if open_time.blank? || start_time.blank?

    return unless open_time > start_time

    errors.add(:start_time, "は開場時間よりも後である必要があります。")
  end

  def ticket_sale_time_before_start_time_on_same_day
    return if ticket_sale_date.blank? || start_time.blank?

    return unless ticket_sale_date.to_date == date && ticket_sale_date.strftime('%H:%M:%S') > start_time.strftime('%H:%M:%S')

    errors.add(:ticket_sale_date, "はライブの開始時刻よりも早く設定する必要があります。")
  end
end
