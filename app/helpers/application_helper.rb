module ApplicationHelper
  def page_title
    @title || "#{t("site.title")}"
  end

  # TODO implement for Facebook page title
  # <meta property="og:title" content="<%= fb_page_title %>" />
  def fb_page_title
    ""
  end

  # TODO implement for Facebook page thumbnail URL
  # <meta property="og:image" content="<%= fb_page_thumbnail_url %>" />
  def fb_page_thumbnail_url
    ""
  end

  # Set and return merged body options
  def body_options(options = {})
    @body_options ||= {}
    @body_options.merge!(options)
  end

  def render_if_present(value, &block)
    return "" unless value.present?
    capture(&block)
  end
  
  def render_unless_present(value, &block)
    return "" if value.present?
    capture(&block)
  end
end
