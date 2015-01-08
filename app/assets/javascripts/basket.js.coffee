class Util
  # Can't believe this has to be implemented here
  @getCookie: (name) ->
    cookieValue = null
    if document.cookie and document.cookie != ""
      cookies = document.cookie.split(";")
      for cookie in cookies
        cookie = jQuery.trim(cookie)
        if cookie.substring(0, (name.length + 1)) == ("#{name}=")
          rawCookie = cookie.substring(name.length + 1)
          # Rails encodes spaces with + and decodeURIComponent doesn't take care of them
          cookieValue = decodeURIComponent(rawCookie.replace(/\+/g, ' '))
          break
    cookieValue

  @arrayIntersection: (a, b) ->
    [a, b] = [b, a] if a.length > b.length
    value for value in a when value in b

class window.Basket

  constructor: ->
    json_data = Util.getCookie('shopping_basket')
    @data = jQuery.parseJSON(json_data) || {}

  render: ->
    @total = 0

    if @data['charities']?
      $('#cart_charities').empty()
      for charity_id, charity_data of @data['charities']
        html = "<span class='cart-charity-name'>For #{charity_data['name']}</span>"
        html += "<ul class='cart-items'>"
        for deal in charity_data['deals']
          html += "<li class='cart-item'><a href='/deals/#{deal.code}' class='deal-remove'><span class='cart-item-remove'>&times;</span></a> $#{deal.cents/100} | #{deal.text}</li>"
          @total += deal.cents/100
        html += "</ul>"
        $('#cart_charities').append html

    @show_or_hide_cart()
    @mark_used_merchants()

  show_or_hide_cart: ->
    $('#cart_total').html("$#{@total}")
    if @total > 0
      $('#cart').slideDown()  # Despite the name, it shows the cart
    else
      $('#cart').slideUp()    # Despite the name, it hides the cart

  merchants_for: (bundle_lnk) ->
    # Extracts merchants list and convert items to integer
    for x in $(bundle_lnk).attr('data-merchants').split(',')
      parseInt(x)

  deactivate: (node) ->
    $(node).addClass('inactive')
    if ($(node).attr('data-remote'))
      $(node).removeAttr('data-remote')
      $(node).attr('data-remote-disabled', 'true')

  activateAll: ->
    $('a.inactive').removeClass('inactive')
    $('a[data-remote-disabled]').attr('data-remote', 'true').removeAttr('data-remote-disabled')

  mark_used_merchants: ->
    @activateAll()
    if @data['merchants']?
      # Individual deals
      for merchant_id in @data['merchants']
        @deactivate $("#merchant_#{merchant_id}.card a")

    if @data['bundles']?
      # Bundled deals
      for bundle_id in @data['bundles']
        @deactivate $("#bundle_#{bundle_id}.card a")

jQuery ->
  # Handles removing a deal from the basket
  $('a.deal-remove').live 'click', (e) ->
    e.preventDefault()
    $.ajax
      url: $(this).attr('href')
      dataType: "script"
      type: "DELETE"

  basket = new Basket
  basket.render()

  $('a.inactive').live 'click', (e) ->
    e.preventDefault()

  #Hack to fix cart position
  if (navigator.platform == 'iPad' || navigator.platform == 'iPhone' || navigator.platform == 'iPod')
    $("#cart").css("position", "static")

