module OrdersHelper

  def transaction_fee_label(order)
    fee = TransactionFee.calculate(order.total)
    ("Yes, I'll also pay %s in processing fees so the charity doesn't have to. " % content_tag(:span, fee.format, :id => "transaction-fee-label")).html_safe
  end

  def transaction_fee(order)
    fee = TransactionFee.calculate(order.total)
    content_tag(:span, fee.cents, :class => "transaction-fees", :style => "display:none;")
  end

  def charity_donation_amount(charity, deals)
    amount = deals.map(&:total_value).reduce(:+)
    ("%s" % content_tag(:span,
      amount.format,
      :"data-cents" => amount.cents,
      :id => "donation-amount-#{charity}",
      :class => "charity-donation-amount")).html_safe
  end

  def donation_amount_all
    amount = donation_amount_money
    ("%s" % content_tag(:span,
      amount.format,
      :"data-cents" => amount.cents,
      :class => "donation-amount")).html_safe
  end

  def donation_amount_money
    amount = Money.new(0, "USD")
    @order_items.each_value do |item|
      amount += item[:deals].map(&:total_value).reduce(:+)
    end
    amount
  end

  def order_errors
    objects = ([@order, @credit_card, @customer]).compact.reject {|o| o.errors.empty?}
    objects << @payment if @payment && !@payment.success?
    cert_errors = errors_for_certificates
    unless objects.empty? && cert_errors.empty?
      html = tag(:div, {:id => "errorExplanation"}, true)
#       human_name = objects.map {|o| o.class.respond_to?(:model_name) ? o.class.model_name.human : "Credit Card"}.to_sentence
      html += content_tag(:h2, "Heads up. Looks like there's a couple errors with this transaction.")
      html += tag(:ul, {}, true)
      objects.each do |object|
        if object.is_a?(::MerchantSidekick::Payment)
          html += object.message
        else
          if object.is_a?(ActiveMerchant::Billing::CreditCard)
            %w(first_name last_name).each {|key| object.errors.delete(key)}
          end
          object.errors.full_messages.each do |msg|
            html += content_tag(:li, msg)
          end
        end
      end
      errors_for_certificates.each do |msg|
        html += content_tag(:li, msg)
      end
      html += "</ul>".html_safe
      html += "</div>".html_safe
      html
    end
  end

  def errors_for_certificates
    cert_errors = []
    @certificates.each{|c|c.errors.delete(:customer)}
    @certificates.map{|c|c.errors.full_messages}.each do |errors|
      errors.each {|error| cert_errors << error if !cert_errors.include?(error)}
    end
    cert_errors
  end

  def emails_from_charity_label(charities)
    text = charities.size > 1 ? "these charities" : "#{charities.first.name}"
    "Yes, send me news and exclusive rewards from #{text} and Givegoods."
  end

  def donation_reward_msg(certificates)
    "Your #{'reward'.pluralize(certificates.size)}:"
  end

end
