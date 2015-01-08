require 'test_helper'

class BaskedTest < ActiveSupport::TestCase
  EMPTY_SAMPLE = {
    'merchants' => [],
    'bundles'   => [],
    'charities' => {},
  }

  SAMPLE = {
    'merchants' => [1, 2, 10, 12],
    'bundles'   => [1],
    'charities' => {
      '10' => {
        'name' => 'Alameda dogs',
        'deals' => [
          {
            'code' => 'd1e2a3l4',
            'cents' => '1000',
            'name' => 'Pepe, Inc.'
          },
          {
            'code' => 'd1e2a3l4',
            'cents' => '2500',
            'name' => 'Books Inc.'
          },
        ],
      },
      '2' => {
        'name' => 'Food for all',
        'deals' => [
          {
            'code' => 'd1e2a3l4',
            'cents' => '1000',
            'name' => 'Pepe, Inc.'
          },
        ],
      },
    },
  }

  test "create empty basket" do
    basket = Basket.new
    assert_equal basket.to_json, EMPTY_SAMPLE.to_json
  end

  test "create from json" do
    basket = Basket.new SAMPLE.to_json
    assert_equal basket.to_json, SAMPLE.to_json
  end

  test "remove item" do
    basket = Basket.new
    deal = FactoryGirl.create(:deal)
    basket.add deal
    assert_not_equal basket.to_json, EMPTY_SAMPLE.to_json
    basket.remove deal
    assert_equal basket.to_json, EMPTY_SAMPLE.to_json
  end

  test "add simple deal" do
    deal = FactoryGirl.create(:deal)
    desired_struct = {
      "merchants" => [deal.merchant_id],
      "bundles" => [],
      "charities" => {
        deal.charity.id.to_s => {
          "name" => deal.charity.name,
          "deals" => [
            { "code" => deal.code,
              "cents" => deal.total_value.cents,
              "text"  => deal.merchant_names.to_sentence
            }]}}}
    basket = Basket.new
    basket.add deal
    assert_equal basket.to_json, desired_struct.to_json
  end

  test "add bundle deal" do
    deal = FactoryGirl.create(:bundle_deal)
    desired_struct = {
      "merchants" => [],
      "bundles"   => [deal.bundle_id],
      "charities" => {
        deal.charity.id.to_s => {
          "name" => deal.charity.name,
          "deals" => [
            { "code" => deal.code,
              "cents" => deal.total_value.cents,
              "text"  => deal.merchant_names.to_sentence
            }]}}}
    basket = Basket.new
    basket.add deal
    assert_equal basket.to_json, desired_struct.to_json
  end

  test "can chain methods" do
    deal = FactoryGirl.create(:deal)
    result = Basket.new.add(deal).remove(deal).to_json
    assert_equal result, EMPTY_SAMPLE.to_json
  end
end
