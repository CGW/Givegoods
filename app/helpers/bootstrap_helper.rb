module BootstrapHelper
  def error_group_for(form, &block)
    resource = form.object
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map {|m| content_tag(:li, m)}.join

    content_tag(:div, :class => 'alert alert-block alert-error') do
      output_buffer << content_tag(:p, capture(&block)) if block_given?
      output_buffer << content_tag(:ul, messages.html_safe)
    end
  end

  def control_group_for(form, field, options={}, &block)
    error_message = form.error_message_on(field)

    group_options = {}
    group_options[:id] = options[:id].to_s      if options[:id]
    group_options[:class] = %w(control-group)
    group_options[:class].push(options[:class]) if options[:class]
    group_options[:class].push('error')         if error_message.present?

    label_text = options[:label] ? options[:label].to_s : form.object.class.human_attribute_name(field)

    content_tag(:div, group_options) do
      output_buffer << form.label(field, "#{label_text}:", :class => "control-label") if label_text.present?
      output_buffer << content_tag(:div, :class => 'controls') do
        block.call
      end
      #output_buffer << content_tag(:span, error_message, :class=>"help-block") if error_message.present?
    end
  end

end

