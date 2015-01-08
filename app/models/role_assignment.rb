
class RoleAssignment
  include Virtus

  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveRecord::AttributeAssignment

  attr_accessible :role

  attribute :role, String
  attribute :user, User

  validates :role, :presence => true
  validates! :user, :presence => true

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else 
      false
    end
  end

  private 

  def persist! 
    @user.role = role
    @user.save!
  end
end
