class BundlesController < ApplicationController
  before_filter :find_charity
  before_filter :find_bundle

  def show
    redirect_to @charity unless request.format.js?
  end

  private

  def find_charity
    @charity = Charity.find params[:charity_id]
  end

  def find_bundle
    @bundle = @charity.bundles.find params[:id]
  end
end
