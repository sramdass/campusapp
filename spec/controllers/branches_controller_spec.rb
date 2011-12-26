require 'spec_helper'

describe BranchesController do
  render_views
#--------------------------------------#

  describe "GET 'new'" do 
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title",
                    :content => "New")
      end    
    end
#--------------------------------------#
#--we do not have a show action for the branch--#
=begin
  describe "GET 'show'" do
    
    before(:each) do
      @branch = Factory(:branch)
    end
    
    it "should be successful" do
      get :show, :id => @branch
      response.should be_success
    end

    it "should find the right branch" do
      get :show, :id => @branch
      assigns(:branch).should == @branch
    end
  end
=end
#--------------------------------------#

  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :address => "", :resource_type_id => -1}
      end

      it "should not create a branch" do
        lambda do
          post :create, :branch => @attr
        end.should_not change(Branch, :count)
      end
      
      it "should render the 'new' page" do
        post :create, :branch => @attr
        response.should render_template('new')
      end
    end #describe "failure" do
    
    describe "success" do
      before(:each) do
        @attr = { :name => "Cluny", :address => "Neyveli", :resource_type_id => ResourceType.find_by_name("School").id}
      end

      it "should create a branch" do
        lambda do
          post :create, :branch => @attr
        end.should change(Branch, :count).by(1)
      end
            
      it "should redirect to the dashboard page" do
        post :create, :branch => @attr
        response.should redirect_to dashboard_path
      end    
      
      it "should have a success notice" do
        post :create, :branch => @attr
        flash[:notice].should  match(/success/i)
      end
    end   #describe "success" do
  end
#--------------------------------------#

 # UPDATE
  describe "PUT branches/:id" do

    describe "with valid params" do
      before(:each) do
        @branch = mock_model(Branch, :update_attributes => true)
        Branch.stub!(:find).with("1").and_return(@branch)
      end
      
      it "should find branch and return object" do
        Branch.should_receive(:find).with("1").and_return(@branch)
      	@branch.should_receive(:update_attributes).and_return(true)
      	put :update, :id => "1", :branch => {}
      	flash[:notice].should match(/success/i) 
      	response.should redirect_to dashboard_path
      end
    end
  end
#--------------------------------------#

 # EDIT
  describe "GET edit" do

    before(:each) do
      #Using stub, optional!
      #@branch = stub_model(Branch)
      @branch = mock_model(Branch, :id => 1, :name => "aaa", :address => "aaa", :resource_type_id => 2)
      Branch.stub!(:find).with("1").and_return(@branch)
    end
      
    it "should find branch and return object" do
      Branch.should_receive(:find).with("1").and_return(@branch) 
      get :edit, :id => @branch
      #If we have used stub_model, then the call should be
      #get :edit, :id => "1", :branch => {}
      response.should be_success
      response.should have_selector("title", :content => "Edit")
    end
  end
end
