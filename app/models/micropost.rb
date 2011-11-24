class Micropost < ActiveRecord::Base
  attr_accessible :content, :photo  
  belongs_to :user
#  has_attached_file :photo,
#  :styles =>{
#    :thumb  => "100x100",
#    :medium => "500x500",
#    :large => "600x400"
#  },
#   :storage => :s3,
#   :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
#	:url  => "/assets/photos/:id/:style/:basename.:extension",
#	:path => ":rails_root/public/assets/photos/:id/:style/:basename.:extension",
#	:url  => ":attachment/:id/:style.:extension"
#	:path => ":attachment/:id/:style.:extension",
#	:bucket => 'fashionappbucket'
	
#validates_attachment_presence :photo
#validates_attachment_size :photo, :less_than => 5.megabytes
#validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  validates :content, :presence => true, :length => { :maximum => 400 }
  validates :user_id, :presence => true
  
  default_scope :order => 'microposts.created_at DESC'
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  private
  
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end
