desc "Reset all end-user transaction data"
task :reset_transaction_data => :environment do
  ActiveRecord::Base.transaction do
    # Order is very important here, please do not re-sort the following lines.
    NewsletterSubscription.destroy_all
    MerchantSidekick::Invoice.destroy_all
    Deal.destroy_all
    Donation.destroy_all
    TransactionFee.destroy_all
    MerchantSidekick::PurchaseOrder.destroy_all
    Customer.destroy_all

    # Destroy stale data. These are leftover records from previous versions.
    # These should not be needed with the current models.
    Certificate.destroy_all
    MerchantSidekick::LineItem.destroy_all
  end
end
