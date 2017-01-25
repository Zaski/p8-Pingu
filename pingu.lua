-- GUL game with a penguin

-- Buttons
BL = 0  -- LEFT
BR = 1  -- RIGHT
BU = 2  -- UP
BD = 3  -- DOWN
B1 = 4  -- ACTION BUTTON 1 (Z DEFAULT)
B2 = 5  -- ACTION BUTTON 2 (X DEFAULT)

-- Colors
COLOR_BG    = 5 -- background color

-- Debug
debug   =   true

-- Possible actions
actions     = {idle=0, walk=1, jump=2, crouch=3}
-- Possible movement directions
directions  = {front= 0, right=1, left=2}
-- Possible characters
characters  = {
    pingu   = {
        id          =   0,
        name        =   "Pingu",
        has_black   =   true,
        screen_pos  =   {
            x   =   59,
            y   =   59
        },
        x           =   59,
        y           =   59,
        jump_height =   3,
        speed       =   3,
        action      =   actions.idle,      -- Defalt action
        direction   =   directions.front,   -- Default direction
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
    }
}

-- Chosen character
player = characters.pingu    -- The default playable character is Pingu

--------------------- FUNCTIONS -------------------

function moveCharacter(character)
    -- Default: character is idle
    character.moving = false
    character.direction = directions.front      -- Default direction is look at front
    character.action = actions.idle             -- Default action is idle
    -- Character walks
    if btn(BR) or btn(LR) then
        character.action = actions.walk
        character.moving = true
        -- All walking animation's sprites of the character are expected to be consecutive
        if btn(BR) then
            character.direction = directions.right
        elseif btn(LR) then
            character.direction = directions.left
        end
    end
    -- Character jumps
    if btn(BU) then
        character.action = actions.jump
        character.jumping = true
    else
        character.jumping = false
    end
    -- Character crouches
    if btn(BD) then
        character.action = actions.crouch
        character.crouching = true
        if btn(BR) then
            character.moving = true
            character.direction = directions.right
        elseif btn(BL) then
            character.moving = true
            character.direction = directions.left
        end
    else
        character.crouching = false
    end
end

--------------------- INIT ------------------------
function _init()
end

--------------------- UPDATE ----------------------
-- _update() is called 30 times each second
function _update()
    moveCharacter(player)
end

--------------------- DRAW AUX FUNCTIONS ----------

function printDebug()
    print("playable character: " .. player.name, 12, 6, 1)
    print("player direction: " .. player.direction, 12, 12, 1)
    print("player action: " .. player.action, 12, 18, 1)
end

function resetPalette()
    palt(15, true)
    palt(0, false)
end

--[[ Animate character
-- Character o
-- Animation's name animation
-- Speed of the animation sp (frames/second)
-- Boolean fl (true if the animation should be flipped. Default is false) ]]

function anim(character, animation, flipped, speed)
    sprite = character.sprites[animation][1]
    num_of_sprites = #character.sprites[animation]
    if num_of_sprites == 1 then
        character.a_fr = sprite
    else
        if(not character.a_ct) character.a_ct=0
        if(not character.a_st) character.a_st=0

        character.a_ct+=1

        if(character.a_ct%(30/speed) == 0) then
        character.a_st+=1
        if(character.a_st == num_of_sprites) character.a_st=0
        end

        character.a_fr = sprite + character.a_st
    end
    spr(character.a_fr, character.screen_pos.x, character.screen_pos.y, 1, 1, flipped)
end


function drawPlayer()
    if player.has_black == true then
        palt(15,true)   -- We want to draw a black penguin, so we set beige (15) to be transparent
        palt(0, false)  -- Default transparent color is black (0), so we set as not transparent
    end
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
            if player.direction == directions.right then
                anim(player, "jump_side")
            else
                anim(player, "jump_side", true)
            end
        elseif player.crouching then
            if player.direction == directions.right then
                anim(player, "crouch_side", false, 5)
            else
                anim(player, "crouch_side", true, 5)
            end
        else
            if player.direction == directions.right then
                anim(player, "walk", false, 10)
            else
                anim(player, "walk", true, 10)
            end
        end
    end
    if player.has_black == true then
        resetPalette()  -- We reset the color palette (undo previous transparency changes)
    end
end

--------------------- DRAW ------------------------
-- _draw() is called always after each _update()
function _draw()
    -- clear the screen
    rectfill(0,0, 128,128, COLOR_BG)
    -- Debug
    if debug == true then
        printDebug()
    end
    -- Draw the playable character sprite
    drawPlayer()
end
