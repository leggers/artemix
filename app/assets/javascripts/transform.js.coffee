# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    window.images = {}
    window.ids = {}
    r_down = false
    l_down = false
    mouse_x = 0
    mouse_y = 0
    mirrored = false

    rcanvas = $("#right_leg")[0]
    c_width = rcanvas.width
    c_height = rcanvas.height

    r_context = rcanvas.getContext('2d')
    l_context = $('#left_leg')[0].getContext('2d')

    bind_listeners = ->
        $('#left_cover_canvas').mousedown(left_down)
        $('#left_cover_canvas').mousemove(left_move)
        $('#left_cover_canvas').mouseup(left_up)

        $('#right_cover_canvas').mousedown(right_down)
        $('#right_cover_canvas').mousemove(right_move)
        $('#right_cover_canvas').mouseup(right_up)

        $('#mirror').change(mirror_image)

    new_image_height = (slider_values) ->
        slider_values.values[1] - slider_values.values[0]

    get_origin_delta = (slider_values, slider_jquery) ->
        if slider_top_button(slider_values) then slider_jquery.data('most_recent_value') - slider_values.value else 0

    update_slider_value = (slider_jquery, slider_values) ->
        slider_jquery.data('most_recent_value', slider_values.value)

    slider_top_button = (ui) ->
        ui.value == ui.values[1]

    slider_left_button = (ui) ->
        ui.value == ui.values[0]

    resize_and_move_image_vertically = (image, slider_values, slider_jquery) ->
        new_height = new_image_height(slider_values)
        origin_delta = get_origin_delta(slider_values, slider_jquery)
        image.height = new_height
        image.origin.y += origin_delta

    resize_and_move_right_image_vertically = (slider_values, slider_jquery) ->
        resize_and_move_image_vertically(r_image, slider_values, slider_jquery)
        draw_right_image()
        if mirrored
            resize_and_move_image_vertically(l_image, slider_values, slider_jquery)
            draw_left_image()
        update_slider_value(slider_jquery, slider_values)

    resize_and_move_left_image_vertically = (slider_values, slider_jquery) ->
        resize_and_move_image_vertically(l_image, slider_values, slider_jquery)
        draw_left_image()
        if mirrored
            resize_and_move_image_vertically(r_image, slider_values, slider_jquery)
            draw_right_image()
        update_slider_value(slider_jquery, slider_values)

    resize_and_move_left_image_horizontally = () ->
        0

    resize_and_move_right_image_horizontally = () ->
        0

    create_sliders = ->
        $('#left_height').slider({
            orientation: 'vertical',
            range: true,
            min: 0,
            max: c_height,
            values: [0, c_height],
            start: (event, ui) ->
                $(this).data('most_recent_value', ui.value)
            slide: (event, ui) ->
                resize_and_move_left_image_vertically(ui, $(this))
        })
        $('#left_width').slider({
            range: true,
            min: 0,
            max: c_width,
            values: [0, c_width],
            start: (event, ui) ->
                $(this).data('most_recent_value', ui.value)
            slide: (event, ui) ->
                origin_delta = $(this).data('most_recent_value') - ui.value
                l_image.width = ui.values[1] - ui.values[0]
                l_image.origin.x -= origin_delta if slider_left_button(ui)
                draw_left_image()
                $(this).data('most_recent_value', ui.value)
        })
        $('#right_height').slider({
            orientation: 'vertical',
            range: true,
            min: 0,
            max: c_height,
            values: [0, c_height],
            start: (event, ui) ->
                $(this).data('most_recent_value', ui.value)
            slide: (event, ui) ->
                resize_and_move_right_image_vertically(ui, $(this))
        })
        $('#right_width').slider({
            range: true,
            min: 0,
            max: c_width,
            values: [0, c_width],
            start: (event, ui) ->
                $(this).data('most_recent_value', ui.value)
            slide: (event, ui) ->
                origin_delta = $(this).data('most_recent_value') - ui.value
                r_image.width = ui.values[1] - ui.values[0]
                r_image.origin.x -= origin_delta if slider_left_button(ui)
                draw_right_image()
                $(this).data('most_recent_value', ui.value)
        })

    mouse_up = () ->
        console.log('up')
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
        },
        width: c_width,
        height: c_height
    }

    l_image = {
        origin: {
            x: 0,
            y: 0
        },
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

    draw_right_image = ->
        r_context.clearRect(0, 0, c_width, c_height)
        if window.images.right != undefined
            r_context.drawImage(window.images.right, r_image.origin.x, r_image.origin.y, r_image.width, r_image.height)

    draw_left_image = ->
        l_context.clearRect(0, 0, c_width, c_height)
        if window.images.left != undefined
            l_context.drawImage(window.images.left, l_image.origin.x, l_image.origin.y, l_image.width, l_image.height)

    move_right_image = (diffs) ->
        r_image.origin.x -= diffs[0]
        r_image.origin.y -= diffs[1]
        draw_right_image()

    move_left_image = (diffs) ->
        l_image.origin.x -= diffs[0]
        l_image.origin.y -= diffs[1]
        draw_left_image()

    right_move = (event) ->
        if r_down && window.images.right != undefined
            diffs = get_diffs(event)
            if mirrored
                diffs[0] = -diffs[0] if window.ids.right == undefined
                move_left_image(diffs)
            move_right_image(diffs)

    left_move = (event) ->
        if l_down && window.images.left != undefined
            diffs = get_diffs(event)
            if mirrored
                diffs[0] = -diffs[0] if window.ids.left == undefined
                move_right_image(diffs)
            move_left_image(diffs)

    mirror_image = ->
        left_image = window.ids.left != undefined

        if left_image
            context = r_context
            image = window.images.left
            window.images.right = image
            r_image = $.extend(true, {}, l_image)
        else
            context = l_context
            image = window.images.right
            window.images.left = image
            l_image = $.extend(true, {}, r_image)

        if $(this).is(':checked')
            mirrored = true
            context.translate(c_width, 0)
            context.scale(-1, 1)
        else
            mirrored = false
            if left_image
                window.images.right = undefined
            else
                window.images.left = undefined
            context.clearRect(0, 0, c_width, c_height)
            context.scale(-1, 1)
            context.translate(-c_width, 0)

        draw_left_image()
        draw_right_image()

    bind_listeners()
    create_sliders()

    have_two_images = ->
        window.ids.left != undefined && window.ids.right != undefined

    window.add_leg = (leg, source) ->
        # remove option from dropdown and show mirror checkbox
        $("#leg option[value='#{leg}']").remove()
        $('#mirror_option').show()
        if have_two_images()
            $('#mirror_option').hide()
            $('#mirror').prop('checked', false)
            mirror_image() if mirrored
            $('#new_artwork').slideUp()

        # clear artwork name text box
        $('#artwork_name').val('')

        # add image to canvas
        canvas = $("##{leg}_leg")[0]
        context = canvas.getContext('2d')
        img = new Image()

        img.onload = ->
            context.drawImage(img, 0, 0, c_width, c_height)

        img.src = source
        window.images[leg] = img

    fill_in_form = (form, data) ->
        form.find('#transform_image_x').val(data.origin.x)
        form.find('#transform_image_y').val(data.origin.y)
        form.find('#transform_width').val(data.width)
        form.find('#transform_height').val(data.height)
        form.find('#transform_leg').val(data.leg)
        form.find('#transform_mirror').prop('checked', data.mirror)
        form.find('#transform_artwork_id').val(data.artwork_id)
        form.find('#transform_design_id').val(data.design_id)
        form.find('#transform_rotation')
        form.submit()

    window.design_created = (design_id) ->
        if window.ids.right != undefined
            right = $('#right_transform')
            r_image.leg = "right"
            r_image.artwork_id = window.ids['right']
            r_image.design_id = design_id
            r_image.mirror = $('#mirror').is(':checked')
            fill_in_form(right, r_image)

        if window.ids.left != undefined
            left = $('#left_transform')
            l_image.leg = "left"
            l_image.artwork_id = window.ids['left']
            l_image.design_id = design_id
            l_image.mirror = $('#mirror').is(':checked')
            fill_in_form(left, l_image)
