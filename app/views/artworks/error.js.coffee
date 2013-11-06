window.alert(
    "err0r! err0r!, artwork could not be saved for the following reasons:
    <% @artwork.errors.full_messages.each do |m| %>
        <%= m %>,\n
    <% end %>"
    )