require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => '1 TRAINING SESSION',
      'class' => 'two',
      'image' =>  'cream-tooltip.jpg'
    },
    {
      'count' => 10,
      'html' => '3 TRAINING SESSIONS',
      'class' => 'three',
      'image' => 'truman.jpg'
    },
    {
      'count' => 25,
      'html' => '6 TRAINING SESSIONS',
      'class' => 'four',
      'image' => 'blade-explain.jpg'
    },
    {
      'count' => 50,
      'html' => '12 TRAINING SESSIONS',
      'class' => 'five',
      'image' => 'winston.jpg'
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
