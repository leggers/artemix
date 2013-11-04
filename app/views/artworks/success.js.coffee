# $('#new_artwork').hide()
canvas = $("#<%= @leg %>_leg")[0]
width = canvas.width
height = canvas.height

context = canvas.getContext('2d')
img = new Image()

img.onload = ->
    context.drawImage(img, 0, 0, width, height)

img.src = "<%= @artwork.image.url %>"

window.images["<%= @leg %>"] = img