jQuery ->
  $('a.featuring_remove_link').on 'click', (e) ->
    e.preventDefault()
    node = $(this).parents('li.choice')
    node.find('.featuring_destroy').val("1")
    node.fadeOut()

  $('button#add_feature_merchant').click (e) ->
    e.preventDefault()
    merchant_id = $('#new_featured_merchant_id').val()
    if (merchant_id != '')
      # clones the template and fills values
      new_content = $('#featuring_to_clone').find('li.choice').clone()

      $(new_content).find('.featuring_merchant').val(merchant_id)
      priority = $('#new_featured_merchant_priority').val()

      $(new_content).find('.featuring_priority').val(priority)

      random_key = Date.now()

      # renames input fields to match nested attributes conventions, see railscast #196
      $(new_content).find('input[type=hidden]').each ->
        name = $(this).attr('name')
        $(this).attr('name', "charity[featurings_attributes][#{random_key}][#{name}]")

      # appends content to existing list
      $(new_content).find('label').append("#{$('#new_featured_merchant_name').val()} (priority: #{priority})")
      $('#featuring_list').append(new_content)

      # clean up autocomplete and priority fields
      $('#new_featured_merchant_name').val("")
      $('#new_featured_merchant_priority').val("0")
      $('#new_featured_merchant_id').val("")

