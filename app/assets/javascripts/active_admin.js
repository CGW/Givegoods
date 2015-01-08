//= require active_admin/base
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require bundle_offer
//= require featured_merchants
$(function() {
  $('a[data-popup]').live('click', function(e) { 
    window.open($(this).attr("href")); 
    e.preventDefault(); 
  });
});