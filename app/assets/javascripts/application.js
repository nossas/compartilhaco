// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require meurio_ui
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){
  $(document).foundation();

  $("[maxlength]").parent().append("<span></span>");
  $("[maxlength]").keyup(function(e){
    var remaining;
    remaining = parseInt($(e.target).attr("maxlength")) - $(e.target).val().length;
    $(e.target).next("span").html(remaining);
  });

  if(location.hash == "#share"){
    $(".reveal-modal.share").foundation('reveal', 'open');
  }

  $(".share-on-facebook-button").click(function(){
    window.open(
      $(event.target).attr("data-href"),
      'facebox-share-dialog',
      'width=626,height=436'
    );
    return false;
  });
});
