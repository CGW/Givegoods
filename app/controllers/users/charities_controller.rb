
class Users::CharitiesController < ApplicationController

  ssl_required :new, :create, :edit, :update
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]

  before_filter :redirect_if_charity_exists, :only => [:new, :create]
  before_filter :load_user_charity_or_redirect, :only => [:edit, :update]

  layout 'bootstrap/users'

  def new
    @charity = Charity.new
    @charity.build_address
  end

  def create
    @charity = current_user.build_charity(params[:charity])

    if @charity.save
      EmailService.new_charity(@charity)

      flash[:success] = "Congratulations, #{@charity.name}. Your charity account has been created."
      redirect_to edit_user_charity_path and return
    end

    render 'users/charities/new'
  end

  def update
    if @charity.update_attributes(params[:charity])
      flash[:success] = "Your charity profile has been updated."
      redirect_to edit_user_charity_path and return
    end

    render 'users/charities/edit'
  end

  private 
  
  def redirect_if_charity_exists
    redirect_to edit_user_charity_path if current_user.charity.present?
  end

  def load_user_charity_or_redirect
    @charity = current_user.charity
    redirect_to new_user_charity_path unless @charity
  end
end
