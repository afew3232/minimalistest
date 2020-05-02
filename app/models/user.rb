class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :favorites
  has_many :comment

  validates :nickname, presence: true, length: {maximum: 20}
  validates :lastname, presence: true, length: {maximum: 20}
  validates :lastname_kana, presence: true, length: {maximum: 20}
  validates :firstname, presence: true, length: {maximum: 20}
  validates :firstname_kana, presence: true, length: {maximum: 20}

end
