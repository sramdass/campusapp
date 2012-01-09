require 'spec_helper'

describe MarksController do

  describe "GET 'subject_marks'" do
    it "returns http success" do
      get 'subject_marks'
      response.should be_success
    end
  end

end
