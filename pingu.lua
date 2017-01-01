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
actions     = {idle=0, walk=1, jump=2}
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
        jumping     =   true,
        sprites     =   {
            idle_1      =   1,
            idle_2      =   2,
            walk_1      =   3,
            walk_2      =   4,
            jump_still  =   5,
            jump        =   6
        },
    }
}

-- Chosen character
player = characters.pingu    -- The default playable character is Pingu

--------------------- FUNCTIONS -------------------

function moveCharacter(character)
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
    else    -- Character is idle
        character.moving = false
        character.direction = directions.front      -- Default direction is look at front
        character.action = actions.idle             -- Default action is idle
    end
    -- Character jumps
    if btn(BU) then
        character.action = actions.jump
        character.jumping = true
    else
        character.jumping = false
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
-- Animation's starting sprite sf
-- Animation's number of sprites nf
-- Speed of the animation sp (frames/second)
-- Boolean fl (true if the animation should be flipped. Default is false) ]]

function anim(o,sf,nf,sp,fl)
    if(not o.a_ct) o.a_ct=0
    if(not o.a_st) o.a_st=0

    o.a_ct+=1

    if(o.a_ct%(30/sp)==0) then
    o.a_st+=1
    if(o.a_st==nf) o.a_st=0
    end

    o.a_fr=sf+o.a_st
    spr(o.a_fr,o.screen_pos.x,o.screen_pos.y,1,1,fl)
end

function drawPlayer()
    if player.has_black == true then
        palt(15,true)   -- We want to draw a black penguin, so we set beige (15) to be transparent
        palt(0, false)  -- Default transparent color is black (0), so we set as not transparent
    end
    if not player.moving then
        if not player.jumping then
            anim(player, player.sprites.idle_1, 2, 3, false)
        else
            spr(player.sprites.jump_still, player.screen_pos.x, player.screen_pos.y)
        end
    else
        if not player.jumping then
            if player.direction == directions.right then
                anim(player, player.sprites.walk_1, 2, 10, false)
            else
                anim(player, player.sprites.walk_1, 2, 10, true)
            end
        else
            if player.direction == directions.right then
                spr(player.sprites.jump, player.screen_pos.x, player.screen_pos.y)
            else
                spr(player.sprites.jump, player.screen_pos.x, player.screen_pos.y, 1, 1, true)
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
