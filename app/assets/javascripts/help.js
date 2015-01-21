$(document).on('ready', function(){
  $('#messages_form').on('ajax:success', function(){
    $(this).trigger('reset');
  });
  $('.help').on('ajax:success', function(data, e){
    if ($('.help_button_active')[0]) {
      $('.help_button_active').attr('value', 'Flag');
      $('.help_button_active')[0].className = 'help_button_inactive';
    } else if ($('.help_button_inactive')[0]) {
      $('.help_button_inactive').attr('value', 'Unflag');
      $('.help_button_inactive')[0].className = 'help_button_active';
    }
  });
});