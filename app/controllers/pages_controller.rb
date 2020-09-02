class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def about
  end

  def contact
  end

  def settings
    @blasons = Blason.all
  end
end
