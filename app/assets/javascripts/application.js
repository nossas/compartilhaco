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
//= require jquery-infinite-scroll
//= require datetimepicker
//= require meurio_ui
//= require foundation
//= require_tree .

$(function(){
  $(document).foundation();

  $('[data-datetimepicker]').datetimepicker({
    lang: 'pt',
    minDate:'0',
    maxDate:'+1970/02/20'
  });

  // facebook initializer
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0&appId=" + $("meta[name='facebook_app_id']").attr('content');
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  $("[maxlength]").parent().append("<span class='maxlength-count'></span>");
  $("[maxlength]").keyup(function(e){
    var remaining;
    remaining = parseInt($(e.target).attr("maxlength")) - $(e.target).val().length;
    $(e.target).parent().find(".maxlength-count").html(remaining);
  });

  if(location.hash == "#share"){
    $(".reveal-modal.share").foundation('reveal', 'open');
  }

  $(".share-on-facebook-button, .share-on-twitter-button").click(function(){
    window.open(
      $(event.target).attr("data-href"),
      'facebox-share-dialog',
      'width=626,height=436'
    );
    return false;
  });

  $(".campaigns-list .row").infinitescroll({
    navSelector: "nav.pagination",
    nextSelector: "nav.pagination a[rel=next]",
    itemSelector: ".campaigns-list .row .campaign",
    loading: {finishedMsg: null, msgText: "Carregando..."}
  });

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-26278513-24', 'auto');
  ga('send', 'pageview');

  // Campaign#new preview bindings
  $("#campaign_facebook_title").keyup(function(e){ $(".facebook-preview .share-title").html($(e.target).val()); })
  $("#campaign_facebook_message").keyup(function(e){ $(".facebook-preview .share-description").html($(e.target).val()); })
  $("#campaign_share_link").keyup(function(e){ $(".facebook-preview .share-link a").html($(e.target).val().split("http://")[1]); })

  $("#campaign_facebook_image").change(function(e){
    var file = e.target.files[0];
    var reader = new FileReader();
    reader.onload = function() { $(".facebook-preview .preview-image img").attr("src", reader.result) };
    reader.readAsDataURL(file);
  });

  $("#campaign_image").change(function(e){
    var file = e.target.files[0];
    var reader = new FileReader();
    reader.onload = function() { $(".campaign-form .preview-image img").attr("src", reader.result) };
    reader.readAsDataURL(file);
  });
});
