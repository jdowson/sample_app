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
  
  # virtual attributes (not in data model)
  attr_accessor :password
    
  # list attributes accessible from outside the model
  attr_accessible :name, :email, :password, :password_confirmation

  # Constants
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # model level validation
  validates_presence_of     :name
  validates_length_of       :name,  :maximum => 50

  validates_presence_of     :email
  validates_length_of       :email, :maximum => 100
  validates_format_of 	    :email, :with => EmailRegex
  validates_uniqueness_of   :email, :case_sensitive => false
  
  # Automatically create the virtual attribute 'password_confirmation'.
  validates_confirmation_of :password

  # Password validations.
  validates_presence_of     :password
  validates_length_of       :password, :within => 6..40

  # ActiveRecord callbacks
  before_save :encrypt_password

  # Instance Methods
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypt(submitted_password) == self.encrypted_password
  end
  
  
  # Class Methods
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  
  private

   def encrypt_password
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end
