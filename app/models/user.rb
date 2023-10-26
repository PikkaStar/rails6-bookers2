class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites,dependent: :destroy
  has_many :books,dependent: :destroy
  has_many :book_comments,dependent: :destroy

  has_many :entries,dependent: :destroy
  has_many :messages,dependent: :destroy

  has_many :read_counts,dependent: :destroy

  has_many :relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
  has_many :reverse_of_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy
  has_many :followings,through: :relationships,source: :followed
  has_many :followers,through: :reverse_of_relationships,source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,length: {maximum: 50}


  def follow(user_id)
  relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def get_profile_image
    if profile_image.attached?
    profile_image
    else
      'no_image.jpg'
    end
  end

  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
      elsif search == "backward_match"
        @user = User.where("name LIKE?","%#{word}")
        elsif search == "partial_match"
          @user = User.where("name LIKE?","%#{word}%")
        else
          @user = User.all
        end
      end

end
