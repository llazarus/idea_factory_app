class User < ApplicationRecord
  has_many :ideas, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: VALID_EMAIL_REGEX
end
