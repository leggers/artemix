# $('#new_artwork').hide()

window.add_leg("<%= @leg %>", "<%= @artwork.image.url %>")

<% if @leg == 'both' %>
<% else %>
window.images["<%= @leg %>"] = img
<% end %>