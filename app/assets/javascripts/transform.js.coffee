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

    r_image = null
    l_image = null

    rcanvas = $("#right_leg")[0]
    c_width = rcanvas.width
    c_height = rcanvas.height

    r_context = rcanvas.getContext('2d')
    l_context = $('#left_leg')[0].getContext('2d')

    # The "model contexts" are hidden canvases double the size of the ones on the page.
    # They are also horizontally flipped because the UV map of the model gets exported flipped.
    # They are used to "paint the mode" in the designs JavaScript.
    r_model_context = $('#right_model_image')[0].getContext('2d')
    r_model_context.translate(c_width * 2, 0)
    r_model_context.scale(-1, 1)
    l_model_context = $('#left_model_image')[0].getContext('2d')
    l_model_context.translate(c_width * 2, 0)
    l_model_context.scale(-1, 1)

    r_model_context.fillStyle = '#ed4faf'
    r_model_context.fillRect(0, 0, c_width * 2, c_height * 2)
    r_context.fillStyle = '#ed4faf'
    r_context.fillRect(0, 0, c_width, c_height)
    l_model_context.fillStyle = '#ed4faf'
    l_model_context.fillRect(0, 0, c_width * 2, c_height * 2)
    l_context.fillStyle = '#ed4faf'
    l_context.fillRect(0, 0, c_width, c_height)

    right_image_origin = ->
        r_image = {
            origin: {
                x: 0,
                y: 0
            },
            width: c_width,
            height: c_height
        }

    left_image_origin = ->
        l_image = {
            origin: {
                x: 0,
                y: 0
            },
            width: c_width,
            height: c_height
        }

    right_image_origin()
    left_image_origin()

    bind_listeners = ->
        $('#left_cover_canvas').mousedown(left_down)
        $('#left_cover_canvas').mousemove(left_move)
        $('#left_cover_canvas').mouseup(left_up)

        $('#right_cover_canvas').mousedown(right_down)
        $('#right_cover_canvas').mousemove(right_move)
        $('#right_cover_canvas').mouseup(right_up)

        $('#mirror').change(mirror_image)

        $('.file-upload').on('dragover', dragover_handler)
        $('.file-upload').on('drop', file_drop)
        $('input#design-image').on('change', file_button)

        $('.reveal-template').on('click', toggle_canvases)

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

    dragover_handler = (event) ->
        event.stopPropagation()
        event.preventDefault()

    file_drop = (event) ->
        event.stopPropagation()
        event.preventDefault()
        file_handler(event.originalEvent.dataTransfer.files[0])

    file_button = (event) ->
        file_handler(event.target.files[0])

    file_handler = (file) ->
        $('.drop-here').hide()
        $('.file-upload .loading').show()
        img = new Image()
        reader = new FileReader()

        reader.onload = (theFile) ->
            $('.file-upload .loading').hide()
            $('.drop-here').show()
            img.src = theFile.target.result
            window.images.left = img
            window.images.right = img
            r_image.origin.x = -c_width
            height = c_height + 135
            width = c_width * 2
            y = -20
            r_image.origin.y = y
            r_image.width = width
            r_image.height = height
            l_image.width = width
            l_image.height = height
            l_image.origin.y = y
            draw_left_image()
            draw_right_image()
            show_resize_sliders("left")
            show_resize_sliders("right")

        reader.readAsDataURL(file)

    toggle_canvases = (event) ->
        $('.left_wrapper').toggle('slide')
        $('.right_wrapper').toggle('slide')
        tooltip = $('.tooltip')

        if tooltip.is(":visible")
            tooltip.slideUp()
        else
            tooltip.slideDown()

    ############################################################################
    #
    # Everything below this comment was written with the intention of a having
    # an in-browser design creation tool. When we realized that we wanted a
    # previewing tool instead, all of this code became somewhat useless. It is
    # kept here so artists can tweak their designs a little and to make me
    # (@leggers) feel better about having toiled over it. Perhaps it will be
    # useful in future versions of Artemix.
    #
    ############################################################################

    draw_right_image = ->
        if window.images.right != undefined
            r_context.clearRect(0, 0, c_width, c_height)
            r_model_context.clearRect(0, 0, c_width * 2, c_height * 2)
            r_context.drawImage(window.images.right, r_image.origin.x, r_image.origin.y, r_image.width, r_image.height)
            r_model_context.drawImage(window.images.right, r_image.origin.x * 2, r_image.origin.y * 2, r_image.width * 2, r_image.height * 2)
            window.paint_model()

    draw_left_image = ->
        if window.images.left != undefined
            l_context.clearRect(0, 0, c_width, c_height)
            l_model_context.clearRect(0, 0, c_width * 2, c_height * 2)
            l_context.drawImage(window.images.left, l_image.origin.x, l_image.origin.y, l_image.width, l_image.height)
            l_model_context.drawImage(window.images.left, l_image.origin.x * 2, l_image.origin.y * 2, l_image.width * 2, l_image.height * 2)
            window.paint_model()

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
        left_image = window.original_leg == 'left'
        contexts = []

        if left_image
            contexts.push(r_context)
            contexts.push(r_model_context)
        else
            contexts.push(l_context)
            contexts.push(l_model_context)

        if $('#mirror').is(':checked')
            mirrored = true
            if left_image
                window.images.right = window.images.left
                r_image = $.extend(true, {}, l_image)
            else
                window.images.left = window.images.right
                l_image = $.extend(true, {}, r_image)
            contexts[0].translate(c_width, 0)
            contexts[1].translate(c_width * 2, 0)
            for context in contexts
                context.scale(-1, 1)
        else
            mirrored = false
            if left_image
                window.images.right = undefined
                right_image_origin()
            else
                window.images.left = undefined
                left_image_origin()
            contexts[0].fillRect(0, 0, c_width, c_height)
            contexts[1].fillRect(0, 0, c_width * 2, c_height * 2)
            for context in contexts
                context.scale(-1, 1)
            contexts[0].translate(-c_width, 0)
            contexts[1].translate(-c_width * 2, 0)

        draw_left_image()
        draw_right_image()

    create_sliders = ->
        $('#left_height').slider({
            orientation: 'vertical',
            min: 0,
            max: c_height * 2,
            value: c_height + 135,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                resize_and_move_left_image_vertically(ui, $(this))
            stop: (event, ui) ->
                $(this).slider('option', 'max', ui.value * 2)
        })
        $('#left_width').slider({
            min: 0,
            max: c_width * 4,
            value: c_width * 2,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                resize_and_move_left_image_horizontally(ui, $(this))
            stop: (event, ui) ->
                $(this).slider('option', 'max', ui.value * 2)
        })
        $('#right_height').slider({
            orientation: 'vertical',
            min: 0,
            max: c_height * 2,
            value: c_height + 135,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                resize_and_move_right_image_vertically(ui, $(this))
            stop: (event, ui) ->
                $(this).slider('option', 'max', ui.value * 2)
        })
        $('#right_width').slider({
            min: 0,
            max: c_width * 4,
            value: c_width * 2,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                resize_and_move_right_image_horizontally(ui, $(this))
            stop: (event, ui) ->
                $(this).slider('option', 'max', ui.value * 2)
        })
        $('#left_rotation').slider({
            min: -Math.PI,
            max: Math.PI,
            value: 0,
            step: .001,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                rotate_left_image(ui, $(this))
        })
        $('#right_rotation').slider({
            min: -Math.PI,
            max: Math.PI,
            value: 0,
            step: .001,
            start: (event, ui) ->
                update_slider_value($(this), ui)
            slide: (event, ui) ->
                rotate_right_image(ui, $(this))
        })

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

    resize_and_move_image_vertically = (image, slider_values, slider_jquery) ->
        new_height = slider_values.value
        delta_y = get_slider_delta(slider_values, slider_jquery) / 2
        image.height = new_height
        image.origin.y += delta_y

    resize_and_move_left_image_horizontally = (slider_values, slider_jquery) ->
        resize_and_move_image_horizontally(l_image, slider_values, slider_jquery)
        draw_left_image()
        if mirrored
            resize_and_move_image_horizontally(r_image, slider_values, slider_jquery)
            draw_right_image()
        update_slider_value(slider_jquery, slider_values)

    resize_and_move_right_image_horizontally = (slider_values, slider_jquery) ->
        resize_and_move_image_horizontally(r_image, slider_values, slider_jquery)
        draw_right_image()
        if mirrored
            resize_and_move_image_horizontally(l_image, slider_values, slider_jquery)
            draw_left_image()
        update_slider_value(slider_jquery, slider_values)

    resize_and_move_image_horizontally = (image, slider_values, slider_jquery) ->
        new_width = slider_values.value
        delta_x = get_slider_delta(slider_values, slider_jquery) / 2
        image.width = new_width
        image.origin.x += delta_x

    get_slider_delta = (slider_values, slider_jquery) ->
        slider_jquery.data('most_recent_value') - slider_values.value

    update_slider_value = (slider_jquery, slider_values) ->
        slider_jquery.data('most_recent_value', slider_values.value)

    rotate_right_image = (slider_values, slider_jquery) ->
        rotate_image(r_context, slider_values, slider_jquery)
        draw_right_image()
        if mirrored
            rotate_image(l_context, slider_values, slider_jquery)
            draw_left_image()
        update_slider_value(slider_jquery, slider_values)

    rotate_left_image = (slider_values, slider_jquery) ->
        rotate_image(l_context, slider_values, slider_jquery)
        draw_left_image()
        if mirrored
            rotate_image(r_context, slider_values, slider_jquery)
            draw_right_image()
        update_slider_value(slider_jquery, slider_values)

    rotate_image = (context, slider_values, slider_jquery) ->
        context.clearRect(0, 0, c_width, c_height)
        angle = get_slider_delta(slider_values, slider_jquery)
        context.rotate(angle)

    bind_listeners()
    create_sliders()

    have_two_images = ->
        window.ids.left != undefined && window.ids.right != undefined

    clear_artwork_info = ->
        $('#artwork_name').val('')
        $('#artwork_artist').val('')
        $('#artwork_attribution').val('')

    show_resize_sliders = (leg) ->
        $("##{leg}_width").show()
        $("##{leg}_height").show()

    window.add_leg = (leg, source) ->
        # remove option from dropdown and enable/disable mirroring
        $("#leg option[value='#{leg}']").remove()
        $('#mirror_option').show()
        if have_two_images()
            $('#mirror_option').hide()
            $('#mirror').prop('checked', false)
            mirror_image() if mirrored
            $('#new_artwork').slideUp()

        # add image to canvas
        canvas = $("##{leg}_leg")[0]
        context = canvas.getContext('2d')
        img = new Image()

        img.onload = ->
            draw_right_image()
            draw_left_image()

        img.src = source
        window.images[leg] = img

        clear_artwork_info()
        show_resize_sliders(leg)


    fill_in_form = (form, data) ->
        form.find('#transform_image_x').val(data.origin.x)
        form.find('#transform_image_y').val(data.origin.y)
        form.find('#transform_width').val(data.width)
        form.find('#transform_height').val(data.height)
        form.find('#transform_leg').val(data.leg)
        form.find('#transform_mirror').prop('checked', data.mirror)
        form.find('#transform_artwork_id').val(data.artwork_id)
        form.find('#transform_design_id').val(data.design_id)
        # form.find('#transform_rotation').val(data.rotation)
        form.submit()

    window.design_created = (design_id) ->
        if window.ids.right != undefined
            right = $('#right_transform')
            r_image.leg = "right"
            r_image.artwork_id = window.ids['right']
            r_image.design_id = design_id
            r_image.mirror = $('#mirror').is(':checked')
            r_image.rotation = $('#right_rotation').data('most_recent_value')
            fill_in_form(right, r_image)

        if window.ids.left != undefined
            left = $('#left_transform')
            l_image.leg = "left"
            l_image.artwork_id = window.ids['left']
            l_image.design_id = design_id
            l_image.mirror = $('#mirror').is(':checked')
            l_image.rotation = $('#left_rotation').data('most_recent_value')
            fill_in_form(left, l_image)
