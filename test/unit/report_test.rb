require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  should validate_presence_of :name
  should validate_presence_of :date_from
  should validate_presence_of :date_to

  test "should validate date range" do
    report = Report.new name: 'test',
                   date_from: Date.parse('2012/04/02'),
                     date_to: Date.parse('2012/04/01')
    assert !report.valid?
    assert report.errors.messages[:date_from].include?("invalid date range")
  end

  test "should respond to export methods" do
    report = Report.new
    assert report.respond_to?(:export_data)
    assert report.respond_to?(:export_filename)
    assert report.class.respond_to?(:export_headers)
  end
end
