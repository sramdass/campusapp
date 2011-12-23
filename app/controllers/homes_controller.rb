class HomesController < ApplicationController
  def home
  	@title = 'Home'
    @branch = Branch.first
  end
end
