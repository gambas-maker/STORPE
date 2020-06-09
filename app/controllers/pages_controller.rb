class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def about
  end

  def contact
    # Ajouter un moyen d'envoyer un formulaire titre, message, mail.
  end
end
