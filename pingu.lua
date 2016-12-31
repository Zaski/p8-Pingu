-- GUL game with a penguin

-- Buttons
BL = 0  -- LEFT
BR = 1  -- RIGHT
BU = 2  -- UP
BD = 3  -- DOWN
B1 = 4  -- ACTION BUTTON 1 (Z DEFAULT)
B2 = 5  -- ACTION BUTTON 2 (X DEFAULT)

-- Colors
COLOR_BG    = 6 -- background color

-- Debug
debug   =   true

-- Possible actions
actions     = {still=0, walk=1, jump=2}
-- Possible movement directions
directions  = {right=0, left=1}
-- Possible characters
characters  = {
    pingu   = {
        id          =   0,
        name        =   "Pingu",
        has_black   =   true,
        screen_pos  =   {
            x       =   59,
            y       =   59
        },
        x           =   59,
        y           =   59,
        jump_height =   3,
        speed       =   3,
        action      =   actions.still,      -- Defalt action
        direction   =   directions.right,    -- Default direction
        sprites     =   {
            still   =   1,
            walk    =   2,
            jump    =   3
        }
    }
}

-- Chosen character
character = characters.pingu    -- The default playable character is Pingu

--------------------- FUNCTIONS -------------------

function moveCharacter()
    character.action = actions.still        -- Default action is stand STILL
    character.direction = directions.right  -- Default direction is right movement
    -- Character walks
    if btn(BR)  then
        character.action = actions.walk
        character.direction = directions.right
    elseif btn(BL) then
        character.action = actions.walk
        character.direction = directions.left
    end
    -- Character jumps
    if btn(BU) then
        character.action = actions.jump
    end
end

--------------------- UPDATE ----------------------
-- _update() is called 30 times each second
function _update()
    moveCharacter(character)
end

--------------------- DRAW AUX FUNCTIONS ----------

function printDebug()
    print("playable character: " .. character.name, 12, 6, 1)
    print("character direction: " .. character.direction, 12, 12, 1)
    print("character action: " .. character.action, 12, 18, 1)
end

function resetPalette()
    palt(15, true)
    palt(0, false)
end

function printPlayer()
    if character.has_black == true then
        palt(15,true)   -- We want to draw a black penguin, so we set beige (15) to be transparent
        palt(0, false)  -- Default transparent color is black (0), so we set as not transparent
    end
    if character.action == actions.still  then
        spr(character.sprites.still, character.screen_pos.x, character.screen_pos.y)
    elseif character.action == actions.walk then
        if character.direction == directions.right then
            spr(character.sprites.walk, character.screen_pos.x, character.screen_pos.y)
        elseif character.direction == directions.left then
            spr(character.sprites.walk, character.screen_pos.x, character.screen_pos.y, 1, 1, true)
        end
    elseif character.action == actions.jump then
        if character.direction == directions.right then
            spr(character.sprites.jump, character.screen_pos.x, character.screen_pos.y)
        elseif character.direction == directions.left then
            spr(character.sprites.jump, character.screen_pos.x, character.screen_pos.y, 1, 1, true)
        end
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
    printPlayer(character)
    resetPalette() -- We reset the color palette (undo previous transparency changes)
end
