# == Schema Information
# Schema version: 20101024182213
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base

  # list attributes accessible from outside the model
  attr_accessible :content

  # linked models
  belongs_to :user

  # default scope informations
  default_scope :order => 'created_at DESC'

  # validations
  validates_presence_of :content, :user_id
  validates_length_of   :content, :maximum => 140
  
  default_scope :order => 'created_at DESC'

  # Return microposts from the users being followed by the given user.
  named_scope :from_users_followed_by, lambda { |user| followed_by(user) }

  
  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_ids = user.following.map(&:id)
      { :conditions => ["user_id IN (#{followed_ids}) OR user_id = :user_id",
                        { :user_id => user }] }
    end
    
    # class methods

    # v1 does it directly by IN [array]
    # def self.from_users_followed_by(user)
    #   followed_ids = user.following.map(&:id)
    #   all(:conditions => ["user_id IN (#{followed_ids}) OR user_id = ?", user])
    # end

    # v2 does it by supplying IN [array] to a named scope to allow pagination etc
    #   without the need to pull back a potentially huge array
    # def self.from_users_followed_by(user)
    #   followed_ids = user.following.map(&:id)
    #   all(:conditions => ["user_id IN (#{followed_ids}) OR user_id = ?", user])
    # end  

    # v3 Return an SQL subselect condition for users followed by the given user.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      { :conditions => ["user_id IN (#{followed_ids}) OR user_id = :user_id",
                        { :user_id => user }] }
    end
    
end
