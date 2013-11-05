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
        $('#right_cover').on('mousedown', right_down)
        $('#right_cover').on('mousemove', right_move)
        $('#right_cover').on('mouseup', right_up)

        $('#left_cover').on('mousedown', left_down)
        $('#left_cover').on('mousemove', left_move)
        $('#left_cover').on('mouseup', left_up)

        # $('#mirror').on('click', mirror_image)

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
            x: 0,
            y: 0
        }
        width: c_width,
        height: c_height
    }

    l_image = {
        origin: {
            x: 0,
            y: 0
        }
        width: c_width,
        height: c_height
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

    bind_listeners()

    mirror_image = ->
        console.log(this)

    window.add_leg = (leg, source) ->
        # remove option from dropdown
        $("#leg option[value='#{leg}']").remove()

        # clear artwork name text box
        $('#artwork_name').val('')

        # add image to canvas
        canvas = $("##{leg}_leg")[0]
        width = canvas.width
        height = canvas.height

        context = canvas.getContext('2d')
        img = new Image()

        img.onload = ->
            context.drawImage(img, 5, 5, width - 10, height - 10)

        img.src = source
        window.images[leg] = img

        