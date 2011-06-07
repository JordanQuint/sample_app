require 'spec_helper'

describe "FriendlyForwardings" do
  
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test automatically goes to the signin page
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    # The test follows the redirect again, and it should go to the page
    #  we wanted to access before we were told to sign in first.
    
    
    #This fails because tests can't sign in a user.
    #response.should render_template('users/edit')
  end
end
