require 'spec_helper'

describe BranchesController do
  render_views
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
  before do
  	#Branch.delete_all
  	Faculty.delete_all
  	Subject.delete_all
  	Clazz.delete_all  	
  end

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
      before do
        @attr = FactoryGirl.attributes_for(:branch)
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
      
      after(:each) do
	    #Branch.delete_all
	  end
    end   #describe "success" do
  end  # describe "POST 'create'" do
#--------------------------------------#

 # UPDATE
  describe "PUT branches/:id" do

    describe "with valid params" do
      before do
      	#Here the update_attributes() of @branch is stubbed, not that of Branch.
        @branch = Factory(:branch)
        Branch.stub!(:find).with("1").and_return(@branch)
        @branch.stub!(:update_attributes).and_return(true)
      end
      it "should find and update the branch" do
        Branch.should_receive(:find).with("1").and_return(@branch)
      	@branch.should_receive(:update_attributes).and_return(true)
      	put :update, :id => "1", :branch => {}
      end
      it "should display success notice and redirect to dashboard" do
      	put :update, :id => "1", :branch => {}
      	flash[:notice].should match(/success/i) 
      	response.should redirect_to dashboard_path
      end      
      after do
      	#Branch.delete_all
      end
    end
    
    describe "with invalid params" do 
      before do
	    @branch = Factory(:branch)
        Branch.stub!(:find).with("#{@branch.id}").and_return(@branch)
        @branch.stub!(:update_attributes).and_return(false)
      end
      it "should find and update the particular instance" do 
        Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch)  
      	@branch.should_receive(:update_attributes).and_return(false)      	
      	put :update, :id => @branch
      end
      it "should render the edit template" do 
      	put :update, :id => @branch
 		response.should be_successful
  		response.should render_template(:edit)
      end   
      after do
      	#Branch.delete_all
      end         
    end
  end #End -   describe "PUT branches/:id" do
#--------------------------------------# 
  describe "GET" do
    before do
      @branch = Factory(:branch_with_all)
      Branch.stub!(:find).with("#{@branch.id}").and_return(@branch)
    end     
    it "new returns http success" do
      get :new
      response.should be_success
    end
    it "new should have the right title" do
      get :new
      response.should have_selector("title", :content => "New")
    end        
    it "edit should find branch and return object" do
      Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch) 
      get :edit, :id => @branch
      #If we have used stub_model, then the call should be
      #get :edit, :id => "1", :branch => {}
      response.should be_success
      response.should have_selector("title", :content => "Edit")
    end   
    it " facultynew should find and update branch " do
      Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch) 
      get :facultynew, :id => @branch
      response.should be_success
      response.should have_selector("title", :content => "New Faculty")
    end  
    it "subjectnew should find and update branch" do
      Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch) 
      get :subjectnew, :id => @branch
      response.should be_success
      response.should have_selector("title", :content => "New Subject")
    end
    it " clazznew should find and update branch" do
      Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch) 
      get :clazznew, :id => @branch
      response.should be_success
      response.should have_selector("title", :content => "New Class")
    end    
    after do
      #Branch.delete_all
      Faculty.delete_all
      Subject.delete_all
      Clazz.delete_all
    end    
  end
#--------------------------------------# 
  describe "PUT facultycreate/:id" do
  	before do 
      @branch = Factory(:branch_with_all)
      Branch.stub!(:find).with("#{@branch.id}").and_return(@branch)
    end
  	describe "with valid values for update" do 
      before do
       @branch.stub!(:update_attributes).and_return(true)
      end
      it "should find and update the particular instance" do 
        Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch)  
     	@branch.should_receive(:update_attributes).and_return(true)      	
     	put :facultycreate, :id => @branch
      end
      it "should redirect to dashboard with success notice" do 
     	put :facultycreate, :id => @branch
     	flash[:notice].should match(/success/i) 
     	response.should redirect_to dashboard_path 
      end      
    end
    
    describe "with valid invaid values for update" do
      before do
        @branch.stub!(:update_attributes).and_return(false)
      end
      it "should find and update the particular instance" do 
        Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch)  
      	@branch.should_receive(:update_attributes).and_return(false)      	
      	put :facultycreate, :id => @branch
      end
      it "should render the facultynew template" do 
      	put :facultycreate, :id => @branch
      	response.should render_template(:facultynew)		
      end   
    end    
    after do
  	  #Branch.delete_all
      Faculty.delete_all
      Subject.delete_all
      Clazz.delete_all
    end    
  end #End of describe "PUT facultycreate/:id" do
  
#--------------------------------------#   

  describe "PUT clazzcreate/:id" do
  	before do
      @branch = Factory(:branch_with_all)
      Branch.stub!(:find).with("#{@branch.id}").and_return(@branch)
    end
  	describe "with valid values for update" do
      before do
       @branch.stub!(:update_attributes).and_return(true)
      end
     it "should find and update the particular instance" do 
       Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch)  
     	@branch.should_receive(:update_attributes).and_return(true)      	
     	put :clazzcreate, :id => @branch
     end
     it "should redirect to dashboard with success notice" do 
     	put :clazzcreate, :id => @branch
     	flash[:notice].should match(/success/i) 
     	response.should redirect_to dashboard_path  		
     end      
    end
    
    describe "with valid invaid values for update" do
      before do
        @branch.stub!(:update_attributes).and_return(false)
      end
      it "should find and update the particular instance" do 
        Branch.should_receive(:find).with("#{@branch.id}").and_return(@branch)  
      	@branch.should_receive(:update_attributes).and_return(false)      	
      	put :clazzcreate, :id => @branch
      end
      it "should render the clazznew template" do 
      	put :clazzcreate, :id => @branch
      	response.should render_template(:clazznew)		
      end   
    end    
    after do
      #Branch.delete_all
      Faculty.delete_all
      Subject.delete_all
      Clazz.delete_all
    end    
  end #End of describe "PUT clazzcreate/:id" do
  
#--------------------------------------#   
  after do
  	#Branch.delete_all
  	Faculty.delete_all
  	Subject.delete_all
  	Clazz.delete_all  	
  end
end
