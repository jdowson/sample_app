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
  
end
