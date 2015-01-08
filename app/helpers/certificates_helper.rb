module CertificatesHelper

  def collection_for_filter_state
    result = []
    result << ["All", ""]
    Certificate.aasm_states.each {|s| result << [s.name.to_s.humanize, s.name.to_s]}
    result
  end

  def collection_for_update_state
    [["Redeemed", "redeem"], ["Unredeemed", "unredeem"], ["Canceled", "cancel"]]
  end

end
