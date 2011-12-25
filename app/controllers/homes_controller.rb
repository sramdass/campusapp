class HomesController < ApplicationController
  def home
  	@title = 'Home'
    @branch = current_profile.branch
  end
end
