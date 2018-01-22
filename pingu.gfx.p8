pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- test of animations and characters

-- buttons
bl = 0  -- left
br = 1  -- right
bu = 2  -- up
bd = 3  -- down
b1 = 4  -- action button 1 (z default)
b2 = 5  -- action button 2 (x default)

-- colors
color_bg    = 3 -- background color

-- debug
debug   =   true

-- possible actions
actions     = {idle=0, walk=1, jump=2, crouch=3}
-- possible movement directions
directions  = {front= 0, right=1, left=2}
-- possible characters
characters  = {
    pingu   = {
        id          =   0,
        name        =   "pingu",
        has_black   =   true,
        x           =   59,
        y           =   59,
        map_pos  =   {
            x   =   59,
            y   =   59
        },
        jump_height =   3,
        speed       =   3,
        action      =   actions.idle,       -- defalt action
        direction   =   directions.front,   -- default direction
        moving      =   false,
        jumping     =   false,
        crouching   =   false,
        sprites     =   {
            idle            =   {1, 2},
            walk            =   {3, 4},
            jump_still      =   {5},
            jump_side       =   {6},
            crouch_still    =   {7},
            crouch_side     =   {8, 9}
        }
    },
    dog   = {
        id          =   1,
        name        =   "dog",
        has_black   =   false,
        x           =   59,
        y           =   59,
        map_pos  =   {
            x   =   59,
            y   =   59
        },
        jump_height =   2,
        speed       =   4,
        action      =   actions.idle,       -- defalt action
        direction   =   directions.front,   -- default direction
        moving      =   false,
        jumping     =   false,
        crouching   =   false,
        sprites     =   {
            idle            =   {},
            walk            =   {32, 33, 34, 35},
            jump_still      =   {},
            jump_side       =   {},
            crouch_still    =   {},
            crouch_side     =   {}
        }
    }
}

-- chosen character
player = characters.pingu    -- the default playable character is pingu

--------------------- functions -------------------

function movecharacter(character)
    -- default: character is idle
    character.moving = false
    character.direction = directions.front      -- default direction is look at front
    character.action = actions.idle             -- default action is idle
    -- character walks
    if btn(br) or btn(lr) then
        character.action = actions.walk
        character.moving = true
        -- all walking animation's sprites of the character are expected to be consecutive
        if btn(br) then
            character.direction = directions.right
        elseif btn(lr) then
            character.direction = directions.left
        end
    end
    -- character jumps
    if btn(bu) then
        character.action = actions.jump
        character.jumping = true
    else
        character.jumping = false
    end
    -- character crouches
    if btn(bd) then
        character.action = actions.crouch
        character.crouching = true
        if btn(br) then
            character.moving = true
            character.direction = directions.right
        elseif btn(bl) then
            character.moving = true
            character.direction = directions.left
        end
    else
        character.crouching = false
    end
end

--------------------- init ------------------------
function _init()
end

--------------------- update ----------------------
-- _update() is called 30 times each second
function _update()
    movecharacter(player)
end

--------------------- draw aux functions ----------

function printdebug()
    print("playable character: " .. player.name, 12, 6, 1)
    print("player direction: " .. player.direction, 12, 12, 1)
    print("player action: " .. player.action, 12, 18, 1)
end

--[[
-- animate character
-- character character
-- animation's name animation
-- boolean flipped (true if the animation should be flipped. default is false)
-- speed of the animation speed (frames/second)
--]]

function anim(character, animation, flipped, speed, x, y)
    sprite = character.sprites[animation][1]
    num_of_sprites = #character.sprites[animation]
    if (not x) x = character.x
    if (not y) y = character.y

    if num_of_sprites == 1 then
        character.a_fr = sprite
    else
        if(not character.a_ct) character.a_ct=0
        if(not character.a_st) character.a_st=0

        character.a_ct+=1

        if(character.a_ct%(flr(30/speed)) == 0) then
        character.a_st+=1
        if(character.a_st == num_of_sprites) character.a_st=0
        end

        character.a_fr = sprite + character.a_st
    end

    spr(character.a_fr, x, y, 1, 1, flipped)
end


function drawplayer()
    if not player.moving then
        if player.jumping then
            anim(player, "jump_still")
        elseif player.crouching then
            anim(player, "crouch_still")
        else
            anim(player, "idle", false, 3)
        end
    else
        if player.jumping then
            anim(player, "jump_side", player.direction == directions.left)
        elseif player.crouching then
            anim(player, "crouch_side", player.direction == directions.left, 5)
        else
            anim(player, "walk", player.direction == directions.left, 10)
        end
    end
end

--------------------- draw ------------------------
-- _draw() is called always after each _update()
function _draw()
    -- clear the screen
    rectfill(0,0, 128,128, color_bg)
    -- debug
    if debug == true then
        printdebug()
    end

    -- draw all characters without black
    if not player.has_black then
        drawplayer()
    end
    anim(characters.dog, "walk", false, 7, 59, 68)

    -- draw all characters with black
    palt(15, true)  -- we want to draw a black penguin, so we set beige (15) to be transparent
    palt(0, false)  -- default transparent color is black (0), so we set as not transparent
    if player.has_black then
        drawplayer()
    end

    palt()  -- we reset the color palette (undo previous transparency changes)
end
__gfx__
00000000fffffffffffffffffffffffffffffffff0f00f0ff0f00f0fffffffffffffffffffffffffffffff0fffffffffffffffffffffffff0000000000000000
00000000fff00ffffff00ffffff00ffffff00fffffc00cffff00c0fffffffffffffffffffffffffff0f00f0ff0f00f0ff0f00f0ff0f00f0f0000000000000000
00700700ffc00cffffc00cffff00c0ffff00c0ffff0990ffff0099ffffffffffffffffffffffffffff0000ffffc00cffff00c0ffff00c0ff0000000000000000
00077000ff0990fff009900fff0099fff000990fff0770ffff0077fffff00ffffff00ffffff00fffff0000ffff0990ffff0099ffff0099ff0000000000000000
00077000f007700fff0770fff000770fff0077ffff0770ffff0077ffffc00cffff00c0ffff00c0ffff0000ffff0770ffff0077ffff0077ff0000000000000000
00700700ff0770ffff0770ffff0077ffff0077ffff0770ffff0077fff009900ff000990fff0099ffff0000ffff0770ffff0077ffff0077ff0000000000000000
00000000ff0770ffff0770ffff0077ffff0077ffff9ff9ffff9ff9ffff0770ffff0077fff000770fff0000ffff0770ffff0077ffff0077ff0000000000000000
00000000f99ff99ff99ff99fff99f99ffff999ffff9ff9fffff9ff9ff99ff99fff99f99ffff999ffff9ff9fff99ff99fff99f99ffff999ff0000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000600000006000000060000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060006c5600006c5060006c5006006c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000666060006660600066606000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666608066666080666660006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600066666000666660006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06500560066006500560065006500660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60505060050006005060605006000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
