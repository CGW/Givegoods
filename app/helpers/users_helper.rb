module UsersHelper
  def user_policy
    @user_policy ||= case current_user.role
                     when 'charity'
                       ActiveCharityPolicy.new(current_user.charity)
                     else
                       nil
                     end
  end

  def policy_alert(policy, attribute)
    return "" if policy.active?

    message = policy.message_for(attribute)
    error = policy.errors[attribute].present?

    group_options = {}
    group_options[:class] = %w(alert alert-block alert-policy)
    group_options[:class].push(error ? 'alert-error' : 'alert-policy-success')
    
    content_tag(:div, group_options) do
      output_buffer << content_tag(:div, (error ? 'INCOMPLETE' : 'COMPLETE'), :class => 'alert-policy-status')
      output_buffer << content_tag(:p, "#{policy_alert_count}. #{message}")
    end
  end

  private 
  
  def policy_alert_count
    @policy_alert_count ||= 0
    @policy_alert_count += 1
  end
end
