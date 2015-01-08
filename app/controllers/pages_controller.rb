class PagesController < ApplicationController

  def index
  end

  def show
    if template_exists? params[:page], ['pages']
      @title = "#{params[:page].titleize} :: #{t("site.title")}"
      render params[:page]
    else
      render file: Rails.root.join("public/404"), status: 404, layout: false
    end
  end
end
