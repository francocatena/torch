jQuery ->
  $('#feedback a, #feedback form').live 'ajax:success', (event, data) ->
    $('#feedback').html(data).find('textarea').focus()