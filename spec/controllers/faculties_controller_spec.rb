require 'spec_helper'
describe FacultiesController do
  render_views
#--------------------------------------#

  describe "GET 'new'" do 
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New")
      end    
    end
#--------------------------------------#
  describe "GET 'show'" do
    before(:each) do
      @faculty=FactoryGirl.create(:faculty)    	
    end
    
    it "should be successful" do
      get :show, :id => @faculty
      response.should be_success
    end

    it "should find the right faculty" do
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
        @attr = { :name => "aa", :id_no => "aa", :female => true, :date_joined => Date.today-2, :date_departed => Date.today-1, :branch_id => Branch.first.id, :resource_type_id => 4}
      end

      it "should create a faculty" do
        lambda do
          post :create, :faculty => @attr
        end.should change(Faculty, :count).by(1)
      end
            
      it "should redirect to the faculty show page" do
        post :create, :faculty => @attr
        response.should redirect_to(faculty_path(:id => "1"))  #I guess any ID can be given here, not necessarily the id of the object just been created
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

    describe "with valid params" do
      before(:each) do
        @faculty = mock_model(Faculty, :update_attributes => true)
        Faculty.stub!(:find).with("1").and_return(@faculty)
      end
      
      it "should find faculty and return object" do
        Faculty.should_receive(:find).with("1").and_return(@faculty)
      	@faculty.should_receive(:update_attributes).and_return(true)
      	put :update, :id => "1", :faculty => {}
      	flash[:notice].should match(/success/i) 
      	response.should redirect_to(faculty_path(@faculty))
      end
    end
  end
#--------------------------------------#

 # EDIT
  describe "GET edit" do

    before(:each) do
      @faculty = stub_model(Faculty)
      #@faculty = mock_model(Faculty, :id => 1, :name => "aaa", :address => "aaa", :resource_type_id => 2)
      Faculty.stub!(:find).with("1").and_return(@faculty)
    end
      
    it "should find faculty and return object" do
      Faculty.should_receive(:find).with("1").and_return(@faculty) 
      #get :edit, :id => @faculty
      get :edit, :id => "1", :faculty => {}
      response.should be_success
      response.should have_selector("title", :content => "Edit")
    end
  end
end

