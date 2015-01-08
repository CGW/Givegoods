class Users::CertificatesController < ApplicationController
  ssl_required  :show, :update

  before_filter :authenticate_user!

  before_filter :load_merchant_or_redirect
  before_filter :build_certificate_action_filter
  before_filter :load_certificates

  layout 'bootstrap/users'

  def show
  end

  def update
    begin
      if params["_update"]
        @certificate_action_filter.update!
        redirect_to user_merchant_certificates_path and return
      end
    rescue AASM::InvalidTransition => e
      flash[:error] = "Certificates cannot transition from 'canceled'." # e.message
    end

    render "show"
  end

  protected

  def load_merchant_or_redirect
    @merchant = current_user.merchant
    redirect_to new_user_merchant_path unless @merchant.present?
  end

  def build_certificate_action_filter
    @certificate_action_filter = CertificateActionFilter.new (params[:certificate_action_filter] || {}).merge(:merchant => @merchant)
  end

  def load_certificates
    @certificates = @certificate_action_filter.certificates
  end

end
