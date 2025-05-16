-- Table of particle types and their textures
particles = {}
particles.active_players = {}

local particle_types = {
    sparkle = "sparkle.png",
    leaf = "leaf.png",
    flame = "flame.png",
    ice = "ice.png",
    rainbow = "rainbow.png",
    music = "music.png",
    petals = "petals.png",
    heart = "heart.png",
    apple = "default_apple.png",
    diamond = "diamond.png",
    mese = "mese.png", -- or custom apple particle
}

for name, texture in pairs(particle_types) do
    minetest.register_craftitem("particles:" .. name .. "_fruit", {
        description = name:gsub("^%l", string.upper) .. " Fruit",
        inventory_image = texture,
        on_use = function(itemstack, user)
            local pname = user:get_player_name()
            particles.active_players[pname] = {
                start_time = minetest.get_gametime(),
                texture = texture,
            }
            minetest.chat_send_player(pname, "You activated the " .. name .. " particles!")
            itemstack:take_item()
            return itemstack
        end,
    })
end


local emission_timer = 0

minetest.register_globalstep(function(dtime)
    emission_timer = emission_timer + dtime
    if emission_timer < 0.3 then return end  -- spawn every ~0.3 seconds (~3x/sec)
    emission_timer = 0

    local current_time = minetest.get_gametime()

    for _, player in ipairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        local data = particles.active_players[name]

        if data then
            if current_time - data.start_time > 10 then
                particles.active_players[name] = nil
                minetest.chat_send_player(name, "The particle effect has ended.")
            else
                local vel = player:get_velocity()
                if math.abs(vel.x) > 0.1 or math.abs(vel.z) > 0.1 or vel.y > 0.1 then
                    local pos = vector.add(player:get_pos(), {x = 0, y = 0.1, z = 0})
                    minetest.add_particlespawner({
                        amount = 3,
                        time = 0.1,
                        minpos = pos,
                        maxpos = pos,
                        minvel = {x = -0.1, y = 0.2, z = -0.1},
                        maxvel = {x = 0.1, y = 0.4, z = 0.1},
                        minacc = {x = 0, y = -0.2, z = 0},
                        maxacc = {x = 0, y = -0.3, z = 0},
                        minexptime = 0.3,
                        maxexptime = 0.6,
                        minsize = 2,
                        maxsize = 4,
                        texture = data.texture,
                    })
                end
            end
        end
    end
end)
-- Crafting recipes for each fruit
minetest.register_craft({
    output = "particles:sparkle_fruit",
    recipe = {
        {"default:torch", "default:diamond", "default:torch"},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "particles:leaf_fruit",
    recipe = {
        {"", "default:leaves", ""},
        {"default:leaves", "default:apple", "default:leaves"},
        {"", "default:leaves", ""},
    },
})

minetest.register_craft({
    output = "particles:flame_fruit",
    recipe = {
        {"default:coal_lump", "default:torch", "default:coal_lump"},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "particles:ice_fruit",
    recipe = {
        {"default:snow", "default:ice", "default:snow"},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "particles:rainbow_fruit",
    recipe = {
        {"default:cobble", "default:mese_crystal", "default:desert_stone"},
        {"default:wood", "default:apple", "default:stone"},
        {"", "", ""},
    },
})


minetest.register_craft({
    output = "particles:music_fruit",
    recipe = {
        {"default:stick", "default:steel_ingot", "default:stick"},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "particles:petals_fruit",
    recipe = {
        {"default:leaves", "default:dirt", "default:leaves"},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})


minetest.register_craft({
    output = "particles:heart_fruit",
    recipe = {
        {"", "default:apple", ""},
        {"default:apple", "default:mese_crystal", "default:apple"},
        {"", "default:apple", ""},
    },
})

minetest.register_craft({
    output = "particles:apple_fruit",
    recipe = {
        {"", "", ""},
        {"", "default:apple", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    output = "particles:diamond_fruit",
    recipe = {
        {"", "default:apple", ""},
        {"default:apple", "default:diamond", "default:apple"},
        {"", "default:apple", ""},
    },
})

minetest.register_craft({
    output = "particles:mese_fruit",
    recipe = {
        {"", "default:apple", ""},
        {"default:apple", "default:mese", "default:apple"},
        {"", "default:apple", ""},
    },
})
