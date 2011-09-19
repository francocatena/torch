jQuery ->
  if $('#apps').length > 0
    $('.app a.toggle-expand').click (event) ->
      $(this).parents('.app').toggleClass('expanded')
      
      if $(this).parents('.app').hasClass('expanded')
        $(this).text $(this).data('contract-label')
      else
        $(this).text $(this).data('expand-label')

      event.stopPropagation()
      event.preventDefault()