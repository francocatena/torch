jQuery ->
  $('#loading_caption').bind
    ajaxStart: -> $(this).stop(true, true).slideDown(100)
    ajaxStop: -> $(this).stop(true, true).slideUp(100)