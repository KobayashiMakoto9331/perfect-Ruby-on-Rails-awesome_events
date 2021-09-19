class User < ApplicationRecord
  before_destroy :check_all_events_finished
  
  has_many :tickets, dependent: :nullify
  has_many :created_events, class_name: "Event", foreign_key: "owner_id"
  has_many :events, through: :tickets
  

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = nickname
      user.image_url = image_url
    end
  end

  private

  def check_all_events_finished
    now = Time.zone.now
    if created_events.where(":now < end_at", now: now).exists?
      errors[:base] << "公開中のイベントが存在します。"
    end

    if events.where(":now < end_at", now: now).exists?
      errors[:base] << "未終了の公開イベントが存在します。"
    end
  end
end
