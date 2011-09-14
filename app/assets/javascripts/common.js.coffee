jQuery ->
  $('#loading_caption').bind
    ajaxStart: -> $(this).stop(true, true).slideDown(100)
    ajaxStop: -> $(this).stop(true, true).slideUp(100)
  
  $('form').submit ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr(
      'disabled', true
    )