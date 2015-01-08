jQuery ->
  $('a.offer_id_remove_link').live 'click', (e) ->
    e.preventDefault()
    $(this).parents('li.choice').remove()

  $('button#add_offer_button').click (e) ->
    e.preventDefault()
    merchant_id = $('#new_merchant_id').val()
    if (merchant_id != '')
      $.getScript '/admin/merchants/' + merchant_id + '/merchant_offer'

