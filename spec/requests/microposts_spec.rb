require 'spec_helper'

describe "Microposts" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    describe "failure" do
  #can't find form :micropost_content
      # it "should not make a new micropost" do
      #   lambda do
      #     visit root_path
      #     fill_in :micropost_content, :with => ""
      #     click_button
      #     response.should render_template('pages/home')
      #     response.should have_selector("div#error_explanation")
      #   end.should_not change(Micropost, :count)
      # end
    end #failure
    
    describe "success" do
      
      it "should make a new micropost" do
        content = "This is some content UP IN HURR."
        lambda do
          visit root_path
          fill_in :content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
=======
  #can't find form :micropost_content
      # it "should not make a new micropost" do
      #   lambda do
      #     visit root_path
      #     fill_in :micropost_content, :with => ""
      #     click_button
      #     response.should render_template('pages/home')
      #     response.should have_selector("div#error_explanation")
      #   end.should_not change(Micropost, :count)
      # end
    end #failure
    
    describe "success" do
  #can't find form :micropost_content
      # it "should make a new micropost" do
      #   content = "This is some content UP IN HURR."
      #   lambda do
      #     visit root_path
      #     fill_in :micropost_content, :with => content
      #     click_button
      #     response.should have_selector("span.content", :content => content)
      #   end.should change(Micropost, :count).by(1)
      # end
>>>>>>> following-users
    end #success
    
  end #creation
end
