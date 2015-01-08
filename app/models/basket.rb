# encoding: utf-8
require "json"

class Basket

  # SAMPLE = {
  #   'merchants' => [1, 2, 10, 12],
  #   'bundles'   => [1],
  #   'charities' => {
  #     '10' => {
  #       'name' => 'Alameda dogs',
  #       'deals' => [
  #         {
  #           'code' => 'd1e2a3l4',
  #           'cents' => '1000',
  #           'name' => 'Pepe, Inc.'
  #         },
  #         {
  #           'code' => 'd1e2a3l4',
  #           'cents' => '2500',
  #           'name' => 'Books Inc.'
  #         },
  #       ],
  #     },
  #     '2' => {
  #       'name' => 'Food for all',
  #       'deals' => [
  #         {
  #           'code' => 'd1e2a3l4',
  #           'cents' => '1000',
  #           'name' => 'Pepe, Inc.'
  #         },
  #       ],
  #     },
  #   },
  # }

  def initialize(json_data = nil)
    @data = json_data ? JSON.parse(json_data) : {}
    # make sure merchants, charities and bundles structures exist
    @data['merchants'] ||= []
    @data['bundles']   ||= []
    @data['charities'] ||= {}
  end

  def to_json
    @data.to_json
  end

  def add(deal)
    if deal.bundle_id.present? && !@data['bundles'].include?(deal.bundle_id)
      @data['bundles'] << deal.bundle_id
      add_to_charities deal
    end
    if deal.merchant_id.present? && !@data['merchants'].include?(deal.merchant_id)
      @data['merchants'] << deal.merchant_id
      add_to_charities deal
    end
    self
  end

  def charities
    Charity.find(@data['charities'].keys)
  end

  def deals_for(charity)
    Deal.where('code in (?)',
      @data['charities'][charity.id.to_s]['deals'].map{ |d| d['code'] })
  end

  def remove(deal)
    @data['charities'].each do |chid, chdata|
      chdata['deals'].delete_if do |d|
        if d['code'] == deal.code
          @data['bundles'].delete(deal.bundle_id) if deal.bundle_id.present?
          @data['merchants'].delete(deal.merchant_id) if deal.merchant_id.present?
          true
        end
      end
    end
    @data['charities'].delete_if { |chid, chdata| chdata['deals'].empty? }
    self
  end

  def to_s
    @deals.to_s
  end

  private

  def add_to_charities(deal)
    ch_id = deal.charity.id.to_s
    @data['charities'][ch_id] ||= {}
    @data['charities'][ch_id]['name'] = deal.charity.name
    @data['charities'][ch_id]['deals'] ||= []
    @data['charities'][ch_id]['deals'] <<
      { 'code' => deal.code, 'cents' => deal.total_value.cents, 'text' => deal.merchant_names.to_sentence }
  end

end