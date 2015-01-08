//= require jquery
//= require bootstrap-tooltip
//= require jquery_ujs
//= require knockout

function CampaignView() {
  this.donationAmount = ko.observable(0);

  this.formattedDonationAmount = ko.computed({
    read: function () {
      return this.donationAmount().toFixed(2);
    },
    write: function (value) {
      // Strip out unwanted characters, parse as float, then write the raw data back to the underlying "amount" observable
      value = parseFloat(value.replace(/[^\.\d]/g, ""));
      this.donationAmount(isNaN(value) ? 0 : value); // Write to underlying storage
    },
    owner: this
  });
}

$(function(){
  $('[rel=tooltip]').tooltip({
    'placement': 'right'  
  });
});
