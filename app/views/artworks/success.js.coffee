window.add_leg("<%= @leg %>", "<%= @artwork.image.url %>")
window.ids["<%= @leg %>"] = <%= @artwork.id %>
btn = $('#upload')
btn.attr('disabled', false)
btn.val('Upload Image')