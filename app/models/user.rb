# == Schema Information
# Schema version: 20110519200042
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
  attr_accessor :password #indicating that it's a virtual attribute, not a stored one
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 15}
  validates :email, :presence => true,
                    :length => { :maximum => 50},
                    :format => { :with => email_regex},
                    :uniqueness => { :case_sensitive => false}
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6 .. 40}
                       
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypt(submitted_password) == encrypted_password
  end
  
  def User.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    #If we don't return on either of those statements,
    # we'll return nil here at the end. Oh, magical Ruby.
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
    #the line above is equivalent to the two lines here:
    # return nil if user.nil?
    # return user if user.salt == cookie_salt
  end
  
  private
    def encrypt_password
      self.salt = make_salt if new_record? #only store the salt if
                                           # this is a new record
      self.encrypted_password = encrypt(password)
      #have to put self.encrypted_password so it doesn't
      # create a local variable, and instead assigns it to
      # the global variable of encrypted_password
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
end