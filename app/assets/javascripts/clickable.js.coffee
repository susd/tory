$(document).on 'ready page:load', ->
  $('.clickable').on 'click', ->
    Turbolinks.visit($(this).attr('href'))