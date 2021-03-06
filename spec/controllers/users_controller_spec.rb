require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title",
                                    :content => "Sign up")
    end
  end
  
  describe "Get 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("img", :class => "gravatar")
      #the :class attribute tests the CSS class's name
    end
    
    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Wat.")
      mp2 = Factory(:micropost, :user => @user, :content => "Lulz.")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
  end #get 'show'
  
  describe "POST create" do
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "test@user.com",
                  :password => "apples", :password_confirmation => "apples"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        # Note: =~ is a comparator for strings to regexs (regular expressions)
        # For practice with regexs, you can visit Rubular online
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end #end success
 
  end #end POST 'create'
  
  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, :content => "change picture")
    end
  end #Get 'edit'
  
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :email => "",
                   :name => "",
                   :password => "",
                   :password_confirmation => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should ahve the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end #end failure
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                   :password => "barbaz", :password_confirmation => "barbaz" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload #refresh the @user variable from the database
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end #success
    
  end #end PUT update
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end #for non-signed-in users
    
    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end #for signed-in users
    
  end #end authentication of edit/update pages
  
  describe "GET 'index'" do
    describe "for non-signed-in users" do
      
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        third = Factory(:user, :name => "Ben", :email => "another@example.net")
        
        @users = [@user, second, third]
        @users = @users + [Factory(:user, :email => "person-1@example.com"), 
                     Factory(:user, :email => "person-2@example.com"), 
                     Factory(:user, :email => "person-3@example.com"), 
                     Factory(:user, :email => "person-4@example.com"), 
                     Factory(:user, :email => "person-5@example.com"), 
                     Factory(:user, :email => "person-6@example.com"), 
                     Factory(:user, :email => "person-7@example.com"), 
                     Factory(:user, :email => "person-8@example.com"), 
                     Factory(:user, :email => "person-9@example.com"), 
                     Factory(:user, :email => "person-10@example.com"), 
                     Factory(:user, :email => "person-11@example.com"), 
                     Factory(:user, :email => "person-12@example.com"), 
                     Factory(:user, :email => "person-13@example.com"), 
                     Factory(:user, :email => "person-14@example.com"), 
                     Factory(:user, :email => "person-15@example.com"), 
                     Factory(:user, :email => "person-16@example.com"), 
                     Factory(:user, :email => "person-17@example.com"), 
                     Factory(:user, :email => "person-18@example.com"), 
                     Factory(:user, :email => "person-19@example.com"), 
                     Factory(:user, :email => "person-20@example.com"), 
                     Factory(:user, :email => "person-21@example.com"), 
                     Factory(:user, :email => "person-22@example.com"), 
                     Factory(:user, :email => "person-23@example.com"), 
                     Factory(:user, :email => "person-24@example.com"), 
                     Factory(:user, :email => "person-25@example.com"), 
                     Factory(:user, :email => "person-26@example.com"), 
                     Factory(:user, :email => "person-27@example.com"), 
                     Factory(:user, :email => "person-28@example.com"), 
                     Factory(:user, :email => "person-29@example.com"), 
                     Factory(:user, :email => "person-30@example.com")]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2", :content => "2")
        response.should have_selector("a", :href => "/users?page=2", :content => "Next")
      end
    end #signed in users
  end #get index
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "signed-in but not admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end #as an admin
  end #DELETE 'destroy'
  
  describe "follow pages" do
    describe "when not signed in" do
      
      it "should protect 'following'" do
        get :following, :id => 1
        response.should redirect_to(signin_path)
      end
      
      it "should protect 'followers'" do
        get :followers, :id => 1
        response.should redirect_to(signin_path)
      end
    end #when not signed in
    
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end
      
      it "should show user following" do
        get :following, :id => @user
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end
      
      it "should show user followers" do
        get :followers, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end #when signed in
  end #follow pages
  
end