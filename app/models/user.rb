class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :favorites

  validates :nickname, presence: true
  validates :lastname, presence: true
  validates :lastname_kana, presence: true
  validates :firstname, presence: true
  validates :firstname_kana, presence: true

end
