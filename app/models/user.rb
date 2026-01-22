class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_many :artists, dependent: :destroy
  has_many :live_schedules, dependent: :destroy
  has_many :live_records, -> { attended }, class_name: "LiveSchedule", dependent: :destroy
  has_many :venues, dependent: :destroy
  has_many :goods, dependent: :destroy
  has_many :categories, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { maximum: 10 }

  def self.guest
    find_or_create_by!(username: 'ゲスト', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
