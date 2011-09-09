jQuery ->
  if $('#hints').length > 0
    style = /large|medium|thumb/
    
    $('figure:not(.avoid_fancybox) img').each ->
      largeImage = $(this).attr('src').replace(style, 'original')
      link = $('<a></a>').attr('href', largeImage).fancybox(type: 'image')

      $(this).wrap(link)