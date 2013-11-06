# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    $('#new_artwork').submit ->
        btn = $('#upload')
        btn.attr('disabled', true)
        btn.val('Uploading.... may take a while for large images')