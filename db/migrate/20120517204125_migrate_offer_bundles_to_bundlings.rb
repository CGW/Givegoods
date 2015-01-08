class MigrateOfferBundlesToBundlings < ActiveRecord::Migration
  class Bundle < ActiveRecord::Base
    has_many :bundlings
    has_many :offers, :through => :bundlings
  end

  class Offer < ActiveRecord::Base
    belongs_to :single_bundle, :class_name => "::Bundle", :foreign_key => "bundle_id"
    has_many :bundlings
    has_many :bundles, :through => :bundlings
  end

  class Bundlings < ActiveRecord::Base
    belongs_to :bundle
    belongs_to :offer
  end

  def up
    Offer.all.each do |offer|
      offer.bundles << offer.single_bundle if offer.single_bundle
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
