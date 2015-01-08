class CertificatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:print]
  before_filter :load_merchant, :except => [:print]
  before_filter :build_certificate_action_filter, :except => [:print]
  before_filter :load_certificates, :except => [:print]

  def show
  end

  def update
    begin
      @certificate_action_filter.update! if params["_update"]
    rescue AASM::InvalidTransition => e
      flash[:error] = "Certificates cannot transition from 'canceled'." # e.message
    end
    render "show"
  end

  def print
    @certificate = Certificate.find params[:id]
    render :layout => "print"
  end

  protected

  def ssl_required?
    ssl_supported?
  end

  def load_merchant
    @merchant = current_user.merchant
  end

  def build_certificate_action_filter
    @certificate_action_filter = CertificateActionFilter.new (params[:certificate_action_filter] || {}).merge(:merchant => @merchant)
  end

  def load_certificates
    @certificates = @certificate_action_filter.certificates
  end

end
