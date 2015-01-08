class Users::MerchantsController < ApplicationController
  ssl_required :new, :create, :edit, :update
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]

  before_filter :redirect_if_merchant_exists, :only => [:new, :create]
  before_filter :load_user_merchant_or_redirect, :only => [:edit, :update]

  layout 'bootstrap/users'

  def new
    @merchant = Merchant.new
    @merchant.build_address
  end

  def create
    @merchant = current_user.build_merchant(params[:merchant])

    if @merchant.save
      flash[:success] = "Your merchant has been created and has been submitted for review by our team."
      redirect_to edit_user_merchant_path and return
    end

    render :new
  end

  def update
    if @merchant.update_attributes(params[:merchant])
      AdminMailer.update_merchant(@merchant).deliver
      flash[:success] = "Your merchant profile has been updated."
      redirect_to edit_user_merchant_path and return
    end

    render :edit
  end

  protected

  def redirect_if_merchant_exists
    redirect_to edit_user_merchant_path if current_user.merchant.present?
  end

  def load_user_merchant_or_redirect
    @merchant = current_user.merchant
    redirect_to new_user_merchant_path unless @merchant
  end
end
