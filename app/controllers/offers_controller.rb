class OffersController < ApplicationController
  # Need to force SSL so that calls from SSL areas don't blowup
  ssl_required :autocomplete_charity_name
  autocomplete :charity, :name, :extra_data => [:id], :scopes => [:active]

  def index
    @offers = Offer.active
  end

  # nothing to see here, move along
  #def show
    #@offer = Offer.active.find(params[:id])
  #end

end
