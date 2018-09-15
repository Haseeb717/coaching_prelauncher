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
      'html' => '1 FREE SESSION OR COURT RENTAL',
      'class' => 'two',
      'image' =>  'cream-tooltip.jpg'
    },
    {
      'count' => 10,
      'html' => '3 FREE SESSIONS OR COURT RENTALS',
      'class' => 'three',
      'image' => 'truman.jpg'
    },
    {
      'count' => 25,
      'html' => '6 FREE SESSIONS OR COURT RENTALS',
      'class' => 'four',
      'image' => 'blade-explain.jpg'
    },
    {
      'count' => 50,
      'html' => '12 FREE SESSIONS OR COURT RENTALS',
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
