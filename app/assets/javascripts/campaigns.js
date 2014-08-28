// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  if(location.hash == "#spread-on-twitter"){
    openTwitterForm();
  } else {
    openFacebookForm();
  }

  $("#facebook-form-button").click(openFacebookForm);
  $("#twitter-form-button").click(openTwitterForm);

  function openFacebookForm(){
    $("form.facebook-profile-campaign-spreader").show();
    $("form.twitter-profile-campaign-spreader").hide();
    $("#facebook-form-button").addClass("active");
    $("#twitter-form-button").removeClass("active");
    return false;
  }

  function openTwitterForm(){
    $("form.facebook-profile-campaign-spreader").hide();
    $("form.twitter-profile-campaign-spreader").show();
    $("#twitter-form-button").addClass("active");
    $("#facebook-form-button").removeClass("active");
    return false;
  }
});
