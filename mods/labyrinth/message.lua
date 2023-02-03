function show_message(player, text, image)
    textID = player:hud_add({
        hud_elem_type = "text",
        position  = {x = 0.5, y = 0.85},
        offset    = {x = 0, y = 0},
        text      = text,
        alignment = 0,
        scale     = {x = 120, y = 50},
        number    = 0xFFFFFF,
        size      = {x = 2, y = 2},
    })
    imageID = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.15, y = 0.15},
        offset    = {x = 0, y = 0},
        text      = image,
        alignment = 0,
        scale     = {x = 1, y = 1},
    })
end