# == Schema Information
# Schema version: 20101022152043
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
  
  # list attributes accessible from outside the model
  attr_accessible :name, :email

  # Constants
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # model level validation
  validates_presence_of   :name, :email

  validates_length_of     :name,  :maximum => 50

  validates_length_of     :email, :maximum => 100
  validates_format_of 	  :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  
end
