class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy

  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy

  has_many :followings, through: :following_relationships

  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy

  has_many :followers, through: :follower_relationships

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
  attachment :profile_image, destroy: false

  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
       if how_search == "1"
          User.where(['name LIKE ?' , "#{search}"])
       elsif how_search == "2"
          User.where(['name LIKE ?' , "#{search}%"])
       elsif how_search == "3"
          User.where(['name LIKE ?' , "%#{search}"])
        elsif how_search == "4"
          User.where(['name LIKE ?' , "%#{search}%"])
    else
      User.all
      end
    end
  end

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}
end
