require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {:name => "Example User", :email => "user@example.com"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    user = User.new(@attr.merge(:email => ""))
    user.should_not be_valid
  end
   
   it "should reject duplicate email addresses" do
     # Put a user with given email address into the database.
     upcased_email = @attr[:email].upcase
     User.create!(@attr.merge(:email => upcased_email))
     user_with_duplicate_email = User.new(@attr)
     user_with_duplicate_email.should_not be_valid
   end
   
   it "should reject names that are too long" do
     long_name = "a" * 16
     long_name_user = User.new(@attr.merge(:name => long_name))
     long_name_user.should_not be_valid
   end
   
   it "should reject emails that are too long" do
      long_email = "a" * 51
      long_email_user = User.new(@attr.merge(:name => long_email))
      long_email_user.should_not be_valid
    end
   
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
   
end
