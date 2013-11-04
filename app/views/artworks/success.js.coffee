window.alert("<%= @leg %>_leg, <%= @artwork.image.url %>")

# $('#new_artwork').hide()
context = $("#<%= @leg %>_leg")[0].getContext('2d')
img = new Image()

console.log(context)
console.log(img)

img.onload = ->
    context.drawImage(img, 0, 0, 250, 500)

img.src = "<%= @artwork.image.url %>"
