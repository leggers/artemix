# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    r_down = false
    l_down = false
    mouse_x = 0
    mouse_y = 0

    rcanvas = $("#right_leg")[0]
    c_width = rcanvas.width
    c_height = rcanvas.height

    r_context = rcanvas.getContext('2d')
    l_context = $('#left_leg')[0].getContext('2d')

    bind_listeners = ->
        $('#right_cover').mousedown(right_down)
        $('#right_cover').mousemove(right_move)
        $('#right_cover').mouseup(right_up)

        $('#left_cover').mousedown(left_down)
        $('#left_cover').mousemove(left_move)
        $('#left_cover').mouseup(left_up)

        $('#mirror').change(mirror_image)

    mouse_up = () ->
        mouse_x = 0
        mouse_y = 0

    right_down = ->
        r_down = true

    right_up = ->
        r_down = false
        mouse_up()

    left_down = ->
        l_down = true

    left_up = ->
        l_down = false
        mouse_up()

    r_image = {
        origin: {
            x: 5,
            y: 5
        }
        width: c_width - 10,
        height: c_height - 10
    }

    l_image = {
        origin: {
            x: 5,
            y: 5
        }
        width: c_width - 10,
        height: c_height - 10
    }

    get_diffs = (event) ->
        diffs = [0, 0]

        if r_down || l_down
            mouse_x = event.pageX if mouse_x == 0
            mouse_y = event.pageY if mouse_y == 0

            diffs[0] = mouse_x - event.pageX
            diffs[1] = mouse_y - event.pageY

        mouse_x = event.pageX
        mouse_y = event.pageY

        diffs

    right_move = (event) ->
        if r_down && window.images.right != undefined
            r_context.clearRect(0, 0, c_width, c_height)
            diffs = get_diffs(event)
            r_image.origin.x -= diffs[0]
            r_image.origin.y -= diffs[1]

            r_context.drawImage(window.images.right, r_image.origin.x, r_image.origin.y, r_image.width, r_image.height)


    left_move = (event) ->
        if l_down && window.images.left != undefined
            l_context.clearRect(0, 0, c_width, c_height)
            diffs = get_diffs(event)
            l_image.origin.x -= diffs[0]
            l_image.origin.y -= diffs[1]

            l_context.drawImage(window.images.left, l_image.origin.x, l_image.origin.y, l_image.width, l_image.height)

    mirror_image = ->
        left_image = window.images.left != undefined

        if left_image
            context = r_context
            image = window.images.left
        else
            context = l_context
            image = window.images.right

        if $(this).is(':checked')
            context.translate(c_width, 0)
            context.scale(-1, 1)
        else
            context.translate(0, 0)
            context.scale(-1, 1)

        context.drawImage(image, 5, 5, c_width - 10, c_height - 10)

    bind_listeners()

    window.add_leg = (leg, source) ->
        # remove option from dropdown and show mirror checkbox
        $("#leg option[value='#{leg}']").remove()
        $('#mirror_option').show()

        # clear artwork name text box
        $('#artwork_name').val('')

        # add image to canvas
        canvas = $("##{leg}_leg")[0]
        context = canvas.getContext('2d')
        img = new Image()

        img.onload = ->
            context.drawImage(img, 5, 5, c_width - 10, c_height - 10)

        img.src = source
        window.images[leg] = img

        