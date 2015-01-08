//= require jquery
//= require jquery-ui
//= require autocomplete-rails

$(function() {
  $('a[data-popup]').live('click', function(e) {
    window.open($(this).attr("href"));
    e.preventDefault();
  });

  if($("#select-all").length > 0) {
    $("#select-all").change(function(event) {
      $("input.select").prop("checked", $("#select-all").prop("checked"));
    });
    $("input.select").change(function(event) {
      $("#select-all").prop("checked", false);
    });
  }
});
