# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121211200336) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.integer "addressable_id"
    t.string  "addressable_type"
    t.integer "academic_title_id"
    t.string  "gender",            :limit => 1
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "last_name"
    t.text    "street"
    t.string  "city"
    t.string  "postal_code"
    t.string  "province"
    t.string  "province_code",     :limit => 2
    t.string  "country"
    t.string  "country_code",      :limit => 2
    t.string  "company_name"
    t.text    "note"
    t.string  "phone"
    t.string  "mobile"
    t.string  "fax"
    t.string  "type"
  end

  add_index "addresses", ["academic_title_id"], :name => "index_addresses_on_academic_title_id"
  add_index "addresses", ["addressable_id", "addressable_type"], :name => "fk_addresses_addressable"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["company_name"], :name => "index_addresses_on_company_name"
  add_index "addresses", ["country"], :name => "index_addresses_on_country"
  add_index "addresses", ["country_code"], :name => "index_addresses_on_country_code"
  add_index "addresses", ["fax"], :name => "index_addresses_on_fax"
  add_index "addresses", ["first_name"], :name => "index_addresses_on_first_name"
  add_index "addresses", ["gender"], :name => "index_addresses_on_gender"
  add_index "addresses", ["last_name"], :name => "index_addresses_on_last_name"
  add_index "addresses", ["middle_name"], :name => "index_addresses_on_middle_name"
  add_index "addresses", ["mobile"], :name => "index_addresses_on_mobile"
  add_index "addresses", ["phone"], :name => "index_addresses_on_phone"
  add_index "addresses", ["province"], :name => "index_addresses_on_state"
  add_index "addresses", ["province_code"], :name => "index_addresses_on_state_code"
  add_index "addresses", ["type"], :name => "index_addresses_on_type"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "bundles", :force => true do |t|
    t.integer  "donation_value_cents"
    t.integer  "charity_id"
    t.string   "status",               :default => "inactive"
    t.string   "image"
    t.string   "name"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "tagline"
    t.string   "notes"
  end

  add_index "bundles", ["charity_id"], :name => "index_bundles_on_charity_id"

  create_table "bundlings", :force => true do |t|
    t.integer  "bundle_id",  :null => false
    t.integer  "offer_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bundlings", ["bundle_id", "offer_id"], :name => "index_bundlings_on_bundle_id_and_offer_id", :unique => true
  add_index "bundlings", ["offer_id"], :name => "index_bundlings_on_offer_id"

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "tagline"
    t.integer  "charity_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cart_line_items", :force => true do |t|
    t.string   "item_number"
    t.string   "name"
    t.string   "description"
    t.integer  "quantity",                  :default => 1,       :null => false
    t.string   "unit",                      :default => "piece", :null => false
    t.integer  "pieces",                    :default => 0,       :null => false
    t.integer  "cents",                     :default => 0,       :null => false
    t.string   "currency",     :limit => 3, :default => "USD",   :null => false
    t.boolean  "taxable",                   :default => false,   :null => false
    t.integer  "product_id",                                     :null => false
    t.string   "product_type",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_line_items", ["item_number"], :name => "index_cart_line_items_on_item_number"
  add_index "cart_line_items", ["name"], :name => "index_cart_line_items_on_name"
  add_index "cart_line_items", ["pieces"], :name => "index_cart_line_items_on_pieces"
  add_index "cart_line_items", ["product_id", "product_type"], :name => "index_cart_line_items_on_product_id_and_product_type"
  add_index "cart_line_items", ["quantity"], :name => "index_cart_line_items_on_quantity"
  add_index "cart_line_items", ["unit"], :name => "index_cart_line_items_on_unit"

  create_table "certificates", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "merchant_id"
    t.string   "code"
    t.integer  "amount_cents"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",             :default => "USD", :null => false
    t.integer  "charity_id"
    t.string   "image"
    t.integer  "deal_id"
    t.integer  "offer_cap_cents"
    t.integer  "discount_rate"
    t.text     "rules"
    t.text     "tagline"
    t.integer  "donation_value_cents"
    t.integer  "deal_total_cents"
  end

  add_index "certificates", ["charity_id"], :name => "index_certificates_on_charity_id"
  add_index "certificates", ["customer_id"], :name => "index_certificates_on_customer_id"
  add_index "certificates", ["deal_id"], :name => "index_certificates_on_deal_id"
  add_index "certificates", ["merchant_id"], :name => "index_certificates_on_merchant_id"

  create_table "charities", :force => true do |t|
    t.string   "name",                    :limit => 100,                                                        :null => false
    t.string   "slug",                    :limit => 100,                                                        :null => false
    t.decimal  "lat",                                    :precision => 11, :scale => 8
    t.decimal  "lng",                                    :precision => 11, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.text     "website_url"
    t.text     "description"
    t.string   "ein"
    t.text     "temp_image_url"
    t.text     "temp_image_url2"
    t.string   "metro_area_name"
    t.string   "status",                                                                :default => "inactive", :null => false
    t.string   "campaign_bundle_tagline"
    t.string   "email"
    t.integer  "user_id"
  end

  add_index "charities", ["ein"], :name => "index_charities_on_ein", :unique => true
  add_index "charities", ["name"], :name => "index_charities_on_name_with_btree"
  add_index "charities", ["slug"], :name => "index_charities_on_slug", :unique => true
  add_index "charities", ["status"], :name => "index_charities_on_status"

  create_table "charities_merchants", :id => false, :force => true do |t|
    t.integer "charity_id",  :null => false
    t.integer "merchant_id", :null => false
  end

  add_index "charities_merchants", ["charity_id", "merchant_id"], :name => "fk_charity_merchant"

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anonymous_donation", :default => false
  end

  create_table "deals", :force => true do |t|
    t.integer  "charity_id"
    t.integer  "merchant_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount_cents"
    t.string   "currency",     :default => "USD", :null => false
    t.integer  "bundle_id"
  end

  add_index "deals", ["code"], :name => "index_deals_on_code", :unique => true

  create_table "donations", :force => true do |t|
    t.integer  "amount_cents"
    t.string   "currency",     :default => "USD", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "charity_id"
    t.integer  "order_id"
    t.integer  "campaign_id"
  end

  add_index "donations", ["campaign_id"], :name => "index_donations_on_campaign_id"
  add_index "donations", ["order_id", "charity_id"], :name => "index_donations_on_order_id_and_charity_id"
  add_index "donations", ["order_id"], :name => "index_donations_on_order_id"

  create_table "featurings", :force => true do |t|
    t.integer "charity_id",                 :null => false
    t.integer "merchant_id",                :null => false
    t.integer "priority",    :default => 0
  end

  add_index "featurings", ["charity_id"], :name => "index_featurings_on_charity_id"
  add_index "featurings", ["merchant_id"], :name => "index_featurings_on_merchant_id"

  create_table "invoices", :force => true do |t|
    t.integer  "buyer_id"
    t.string   "buyer_type"
    t.integer  "seller_id"
    t.string   "seller_type"
    t.integer  "net_cents",     :default => 0,         :null => false
    t.integer  "tax_cents",     :default => 0,         :null => false
    t.integer  "gross_cents",   :default => 0,         :null => false
    t.string   "currency",      :default => "USD",     :null => false
    t.string   "type"
    t.string   "number"
    t.string   "status",        :default => "pending", :null => false
    t.datetime "paid_at"
    t.integer  "order_id"
    t.datetime "authorized_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["buyer_id", "buyer_type"], :name => "index_invoices_on_buyer_id_and_buyer_type"
  add_index "invoices", ["number"], :name => "index_invoices_on_number"
  add_index "invoices", ["order_id"], :name => "index_invoices_on_order_id"
  add_index "invoices", ["seller_id", "seller_type"], :name => "index_invoices_on_seller_id_and_seller_type"
  add_index "invoices", ["type"], :name => "index_invoices_on_type"

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "invoice_id"
    t.integer  "sellable_id"
    t.string   "sellable_type"
    t.integer  "net_cents",                                     :default => 0,     :null => false
    t.integer  "tax_cents",                                     :default => 0,     :null => false
    t.integer  "gross_cents",                                   :default => 0,     :null => false
    t.string   "currency",                                      :default => "USD", :null => false
    t.decimal  "tax_rate",      :precision => 15, :scale => 10, :default => 0.0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["invoice_id"], :name => "index_line_items_on_invoice_id"
  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["sellable_id", "sellable_type"], :name => "index_line_items_on_sellable_id_and_sellable_type"

  create_table "merchants", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "website_url"
    t.string   "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "status",                                       :default => "unconfirmed"
    t.decimal  "lat",           :precision => 11, :scale => 8
    t.decimal  "lng",           :precision => 11, :scale => 8
    t.datetime "registered_at"
    t.datetime "activated_at"
  end

  add_index "merchants", ["name"], :name => "index_merchants_on_name_with_btree"
  add_index "merchants", ["slug"], :name => "index_merchants_on_slug", :unique => true
  add_index "merchants", ["status"], :name => "index_merchants_on_status"

  create_table "newsletter_subscriptions", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "charity_id"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "newsletter_subscriptions", ["charity_id"], :name => "index_newsletter_subscriptions_on_charity_id"
  add_index "newsletter_subscriptions", ["customer_id"], :name => "index_newsletter_subscriptions_on_customer_id"
  add_index "newsletter_subscriptions", ["email"], :name => "index_newsletter_subscriptions_on_email"
  add_index "newsletter_subscriptions", ["merchant_id"], :name => "index_newsletter_subscriptions_on_merchant_id"

  create_table "offers", :force => true do |t|
    t.integer  "merchant_id",                                                                         :null => false
    t.text     "rules"
    t.string   "currency",         :limit => 3,                                :default => "USD"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                                                       :default => "pending"
    t.integer  "charity_id"
    t.string   "charities_near"
    t.decimal  "lat",                           :precision => 11, :scale => 8
    t.decimal  "lng",                           :precision => 11, :scale => 8
    t.integer  "discount_rate"
    t.integer  "offer_cap_cents"
    t.integer  "max_certificates"
    t.text     "tagline"
  end

  add_index "offers", ["charity_id"], :name => "index_offers_on_charity_id"
  add_index "offers", ["merchant_id"], :name => "index_offers_on_user_id"

  create_table "orders", :force => true do |t|
    t.integer  "buyer_id"
    t.string   "buyer_type"
    t.integer  "seller_id"
    t.string   "seller_type"
    t.integer  "invoice_id"
    t.integer  "net_cents",                               :default => 0,         :null => false
    t.integer  "tax_cents",                               :default => 0,         :null => false
    t.integer  "gross_cents",                             :default => 0,         :null => false
    t.string   "currency",                   :limit => 3, :default => "USD",     :null => false
    t.string   "type"
    t.string   "status",                                  :default => "created", :null => false
    t.string   "number"
    t.string   "description"
    t.datetime "canceled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "transaction_costs_included"
  end

  add_index "orders", ["buyer_id", "buyer_type"], :name => "index_orders_on_buyer_id_and_buyer_type"
  add_index "orders", ["seller_id", "seller_type"], :name => "index_orders_on_seller_id_and_seller_type"
  add_index "orders", ["status"], :name => "index_orders_on_status"
  add_index "orders", ["type"], :name => "index_orders_on_type"

  create_table "payments", :force => true do |t|
    t.integer  "payable_id"
    t.string   "payable_type"
    t.boolean  "success"
    t.string   "reference"
    t.string   "message"
    t.string   "action"
    t.string   "params"
    t.boolean  "test"
    t.integer  "cents",                       :default => 0,     :null => false
    t.string   "currency",       :limit => 3, :default => "USD", :null => false
    t.integer  "position"
    t.string   "type"
    t.string   "paypal_account"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["action"], :name => "index_payments_on_action"
  add_index "payments", ["payable_id", "payable_type"], :name => "index_payments_on_payable_id_and_payable_type"
  add_index "payments", ["position"], :name => "index_payments_on_position"
  add_index "payments", ["reference"], :name => "index_payments_on_reference"
  add_index "payments", ["uuid"], :name => "index_payments_on_uuid"

  create_table "reports", :force => true do |t|
    t.string "name"
    t.date   "date_from"
    t.date   "date_to"
  end

  create_table "tiers", :force => true do |t|
    t.string   "tagline"
    t.integer  "amount_cents", :default => 0, :null => false
    t.integer  "campaign_id",                 :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "tiers", ["campaign_id"], :name => "index_tiers_on_campaign_id"

  create_table "transaction_fees", :force => true do |t|
    t.integer  "amount_cents"
    t.string   "currency",     :default => "USD", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  add_index "transaction_fees", ["order_id"], :name => "index_transaction_fees_on_order_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_uid"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.string   "role"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
