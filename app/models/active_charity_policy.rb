
class ActiveCharityPolicy
  include Virtus 
  include ActiveModel::Validations

  attr_reader :charity, :basic_information, :picture, :description, :contact_information

  MESSAGES = {
    :basic_information   => 'Create a basic account.',
    :picture             => 'Add a picture to display on charity page.',
    :description         => 'Write a short description for your charity.',
    :contact_information => 'Enter your contact information.'
  }.freeze

  validate :basic_information_is_present, 
    :picture_is_not_default, 
    :description_is_present,
    :contact_information_is_complete

  def initialize(charity)
    @charity = charity
  end

  def active?
    @active ||= valid?
  end

  def message_for(attr)
    MESSAGES[attr]
  end

  private

  def basic_information_is_present
    errors.add(:basic_information, message_for(:basic_information)) unless charity.valid?
  end

  def picture_is_not_default 
    if charity.picture.url == charity.picture.default_url
      errors.add(:picture, message_for(:picture))
    end
  end

  def description_is_present
    errors.add(:description, message_for(:description)) unless charity.description.present?
  end

  def contact_information_is_complete
    if charity.email.blank? || !CompleteAddressPolicy.new(charity.address).complete?
      errors.add(:contact_information, message_for(:contact_information))
    end
  end

end
