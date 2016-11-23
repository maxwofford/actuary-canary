class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def new_token!
    SecureRandom.hex(16).tap do |token|
      update_attributes token: token
      Rails.logger.info("Set new token for user #{id}")
    end
  end
end
