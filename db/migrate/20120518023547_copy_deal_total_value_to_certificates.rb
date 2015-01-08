class CopyDealTotalValueToCertificates < ActiveRecord::Migration
  def up
    Certificate.all.each do |certificate|
      begin
        certificate.deal_total_cents = Deal.find(certificate.deal_id).total_value.cents if certificate.deal_id
        certificate.save!
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
