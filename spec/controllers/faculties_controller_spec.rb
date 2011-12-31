require 'spec_helper'
describe FacultiesController do
  render_views
  before(:all) do
      @c=UserProfile.find_by_login("xxxx") || Factory(:current_user)    	
      ApplicationController.stub!(:current_profile).and_return(@c)  	
  end
#--------------------------------------#
  describe "GET" do
    before(:each) do
      @faculty = Factory(:faculty)
      Faculty.stub!(:find).with("#{@faculty.id}").and_return(@faculty)
    end
    it "new should return http success" do
      get 'new'
      response.should be_success
    end
    it "new should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New")
    end        
    it "edit should find faculty and return object" do
      Faculty.should_receive(:find).with("#{@faculty.id}").and_return(@faculty) 
      get :edit, :id => @faculty
      response.should be_success
      response.should have_selector("title", :content => "Edit")
    end
    it "show should be successful" do
      get :show, :id => @faculty
      response.should be_success
    end
    it "show should find the right faculty" do
      get :show, :id => @faculty
      assigns(:faculty).should == @faculty
    end    
  end
#--------------------------------------#

  describe "POST 'create'" do
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :id_no => "", :female => nil, :date_joined => nil, :date_departed => nil, :branch_id => -1, :resource_type_id => -1}
      end

      it "should not create a faculty" do
        lambda do
          post :create, :faculty => @attr
        end.should_not change(Faculty, :count)
      end
      
      it "should render the 'new' page" do
        post :create, :faculty => @attr
        response.should render_template('new')
      end
    end #describe "failure" do
    
    describe "success" do
      before(:each) do
      	#not  sure how to get the attributes from Factory girl
        @attr = FactoryGirl.attributes_for(:faculty)
      end

      it "should create a faculty" do
        lambda do
          post :create, :faculty => @attr
        end.should change(Faculty, :count).by(1)
      end
            
      it "should redirect to the faculty show page" do
        post :create, :faculty => @attr
        response.should redirect_to(faculty_path(:id => Faculty.find_by_id_no(@attr[:id_no])))  
      end
      
      it "should have a success notice" do
        post :create, :faculty => @attr
        flash[:notice].should =~ /successfully created/i
      end
    end   #describe "success" do
  end
#--------------------------------------#

 # UPDATE
  describe "PUT faculties/:id" do

    before do
      @faculty = Factory(:faculty)
      Faculty.stub!(:find).with("#{@faculty.id}").and_return(@faculty)
    end
    describe "with valid params" do
      before do        
        @faculty.stub!(:update_attributes).and_return(true)
      end
      it "should find faculty and return object" do
        Faculty.should_receive(:find).with("#{@faculty.id}").and_return(@faculty)
      	@faculty.should_receive(:update_attributes).and_return(true)
      	put :update, :id => @faculty
      	flash[:notice].should match(/success/i) 
      	response.should redirect_to(faculty_path(@faculty))
      end
    end
    
    describe "with invalid params" do 
      before do
        @faculty.stub!(:update_attributes).and_return(false)
      end
      it "should find and update the particular instance" do 
        Faculty.should_receive(:find).with("#{@faculty.id}").and_return(@faculty)  
      	@faculty.should_receive(:update_attributes).and_return(false)      	
      	put :update, :id => @faculty
      end
      it "should render the edit template" do 
      	put :update, :id => @faculty
 		response.should be_successful
  		response.should render_template(:edit)
      end   
    end    
  end
#--------------------------------------#

  describe "get current_profile" do
    it "should return the current profile" do
      @c=UserProfile.find_by_login("xxxx") || Factory(:current_user)    	
      @controller.stub!(:current_profile).and_return(@c)
      @c.branch.name == "Jawahar"
    end
  end

end

