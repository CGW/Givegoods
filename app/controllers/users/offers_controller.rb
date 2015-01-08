class Users::OffersController < ApplicationController
  ssl_required :new, :create, :edit, :update
  autocomplete :charity, :name, :extra_data => [:id], :scopes => [:active]

  before_filter :authenticate_user!

  before_filter :load_merchant_or_redirect, :only => [:new, :create, :edit, :update]
  before_filter :redirect_if_offer_exists, :only => [:new, :create]
  before_filter :load_offer_or_redirect, :only => [:edit, :update]

  layout 'bootstrap/users'

  def new
    @offer = @merchant.build_offer
    render :edit
  end

  def create
    @offer = @merchant.build_offer(params[:offer])

    if @offer.save
      flash[:success] = 'Your reward has been successfully created.'
      redirect_to edit_user_merchant_offer_path and return
    end

    render :edit
  end

  def update
    if @offer.update_attributes(params[:offer])
      flash[:success] = 'Your reward settings have been updated.'
      redirect_to edit_user_merchant_offer_path and return
    end

    render :edit
  end

  private

  def load_merchant_or_redirect
    @merchant = current_user.merchant
    redirect_to new_user_merchant_path unless @merchant.present?
  end

  def redirect_if_offer_exists
    redirect_to edit_user_merchant_offer_path if @merchant.offer.present?
  end

  def load_offer_or_redirect
    @offer = @merchant.offer
    redirect_to new_user_merchant_offer_path unless @offer
  end
end
