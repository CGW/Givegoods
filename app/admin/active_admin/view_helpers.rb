def resource_status_tag(resource)
  if resource.respond_to?(:unconfirmed?) && resource.unconfirmed?
    status_tag(resource.aasm_human_state, :warning)
  elsif resource.respond_to?(:pending?) && resource.pending?
    status_tag(resource.aasm_human_state, :warning)
  elsif resource.respond_to?(:active?) && resource.active?
    status_tag(resource.aasm_human_state, :ok)
  elsif resource.respond_to?(:canceled?) && resource.canceled?
    status_tag(resource.aasm_human_state, :cancel)
  elsif resource.respond_to?(:redeemed?) && resource.redeemed?
    status_tag(resource.aasm_human_state, :ok)
  else
    status_tag(resource.status, :cancel)
  end
end
