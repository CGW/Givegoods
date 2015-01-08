class Users::RoleAssignmentsController < ApplicationController

  ssl_required :new, :create
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :redirect_if_role_is_set, :only => [:new, :create]

  layout 'bootstrap/application'

  def new 
    flash.delete :notice
  end

  def create
    @role_assignment = RoleAssignment.new(params[:role_assignment])
    @role_assignment.user = current_user

    if @role_assignment.save
      redirect_to after_sign_in_path_for(current_user)
      return
    end

    render :new
  end
  
  private

  def redirect_if_role_is_set
    redirect_to after_sign_in_path_for(current_user) if current_user.role.present?
    return
  end

end
