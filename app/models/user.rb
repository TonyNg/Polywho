# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, 
  :remember_me, :major, :year, :books_sell, :books_buy, :facebook, :restaurants,
  :interests

  attr_accessor :password

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
						     
  # Cal Poly email regex
  email_regex = /\A[\w+\-.]+@[csupomona\d\-.]+[edu]+\z/i
  
  #original email regex for all emails 
  #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
					
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }	
					 
  validates_acceptance_of :check
					   
  validates :major, :length		=> { :maximum => 60}
  validates :year, :length		=> { :maximum => 30}				
  validates :books_buy, :length		=> { :maximum => 200}																	
  validates :books_sell, :length		=> { :maximum => 200}																	
  validates :facebook, :presence => true,
					   :length		=> { :maximum => 80}																	
  validates :restaurants, :length		=> { :maximum => 80}																	
  validates :interests, :length		=> { :maximum => 160}																	
													
																	
					
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  
   
   define_index do
   indexes :name
   indexes year
   indexes major
   indexes books_buy
   indexes books_sell
   indexes facebook
   indexes restaurants
   indexes interests
   end
   
   def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end


  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
   
 def self.search(search)
  if search
    where 'LOWER (name) LIKE :search OR LOWER (year) LIKE :search 
	OR LOWER (major) LIKE :search OR LOWER (books_buy) LIKE :search
	OR LOWER (books_sell) LIKE :search OR LOWER (facebook) LIKE :search OR LOWER (restaurants) LIKE :search
	OR LOWER (interests) LIKE :search', :search => "%#{search.downcase}%"
  else 
    scoped
  end
end
    
  private
  
   def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
 # Automatically create the virtual attribute 'password_confirmation'.
 		
end
