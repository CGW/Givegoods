// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery_lazyload
//= require jquery_scrollto
//= require basket
//= require autocomplete-rails
//= require iscroll

$(function() {
  $("img").lazyload({
    effect : "fadeIn"
  });

  $('a[data-popup]').live('click', function(e) {
    window.open($(this).attr("href"));
    e.preventDefault();
  });

  bindDonationRedemption();
  bindAdditionalRedemptionAmount();

  handleDonationRedemption();

  $('form.submit-once').bind('submit', function(e) {
    var $submit = $(this).find('input:submit');
    $submit.attr('disabled', 'disabled');
    $submit.attr('value', 'Please wait ...');
  })
});

$(document).bind("lightbox-loaded", function(event) {
  bindDonationRedemption();
});

function bindDonationRedemption() {
  if($("select#donation-redemption-select").length > 0) {
    $("#donation-redemption-rule-" + $("select#donation-redemption-select").val()).show();
  }
  $("select#donation-redemption-select").change(handleDonationRedemption);
  $("#donation-with-transaction-fee").change(handleDonationRedemption);
}

function handleDonationRedemption(event) {
  var fee = 0;
  var donationAmount = 0;
  var originalAmount = parseInt($("span.donation-amount").data('cents'), 10);

  if($("input.donation-amount").length > 0) {
    $("input.donation-amount").each(function(index) {
      if(!isNaN(parseFloat($(this).val()))) {
        val = parseFloat($(this).val()) * 100;
        donationAmount += val;
        charity_donation_val = parseInt($($('.charity-donation-amount')[index]).data('cents'), 10);
        $($('.charity-donation-amount')[index]).html('$' + ((charity_donation_val+val)/100).toFixed(2));
      }
    });
    // Note: by BVision: Very ugly, I know! Should be an AJAX call eventually.
    $("span.donation-amount").html("$" + ((originalAmount + donationAmount + fee) / 100).toFixed(2));
  }
}

function bindAdditionalRedemptionAmount() {
  if($("#with-additional-donation-amount").length > 0) {
    toggleDonationAmountField();
    $("#with-additional-donation-amount").change(toggleDonationAmountField);

    $("input.donation-amount").keypress(function(evt) {
      var charCode = (evt.which) ? evt.which : event.keyCode
      if (charCode != 46 && charCode > 31
        && (charCode < 48 || charCode > 57))
          return false;
      return true;
    });

    $("input.donation-amount").keyup(handleDonationRedemption);
  }
}

function toggleDonationAmountField(event) {
  if($("#with-additional-donation-amount").is(":checked")) {
    $(".additional-donation-amount-form-row").show();
  } else {
    $(".additional-donation-amount-form-row").hide();
    $("input.donation-amount").val("");
    handleDonationRedemption();
  }
}





/**
This allows the cart to scroll to a fixed position on iPad.
*/

  $(function() {
    if (navigator.platform == 'iPad' || navigator.platform == 'iPhone' || navigator.platform == 'iPod') {
      $("#cart").css("position", "absolute");
      $("#cart").css("top", "400px");
      $("#cart").css("left", "0px");
      $("#cart").css("width", "200px");
      $("#cart").css("bottom", "auto");
      $("#cart").css("border-left", "none");
      $("#cart").css("border-bottom", "5px solid #69A9C7");
      $("#cart").css("z-index", "5000");
      $("#page_effect").css("display", "block");

      var name = "#cart";
      var menuYloc = null;
      var scrollBottom = $(window).scrollTop() + $(window).height();

      menuYloc = parseInt($(name).css("top").substring(0,$(name).css("top").indexOf("px")), 10);
      $(window).scroll(function () {
        offset = menuYloc+$(document).scrollTop()+"px";
        $(name).animate({top:offset},{duration:700,queue:false});
      });
    }
  });

