-- This handesl the cursor, moving it around, and doing stuff when actions are performed. The
-- cursor is actually mulple parts moving in concert to get the effect I wanted. The extra
-- effort were most certainly not worth it.

-- Load constants needed for this file
local GFX               <const> = playdate.graphics;
local CURSOR_GFX        <const> = GFX.imagetable.new('gfx/cursor')
local CURSOR_STATUS_GFX <const> = GFX.imagetable.new('gfx/cursor-status')
local TIMER             <const> = playdate.timer;

-- These constants are for fine positioning the elements relative to the tile, in case I change my mind again
local CURSOR_OFFSET        <const> = -4;
local CURSOR_NEXT_OFFSET   <const> = 0;
local CURSOR_STATUS_OFFSET <const> = 7;

-- This keeps track of the current cursor movment, to get the behavior I wanted
local directionsPressed = { up = false, down = false, left = false, right = false }
local moveDelay = nil

-- Animations need timers, timers need variables
local animation = 'none';
local animationTimer = nil;

-- Cursor locks while doing things to build tension when the end is near
local LOCK_DURATION_ADD    <const> = 120 -- 60 theoretical minimum
local LOCK_DURATION_ERROR  <const> = 240 -- 160 theoretical minimum
local LOCK_DURATION_REMOVE <const> = 480 -- 191 theoretical minimum

-- We need a few bits of data about the playfield, but we want to store it locally for performance
local PLAYFIELD <const> = getPlayfieldData();

-- The main cursor object that all this stuff is contained in
local CURSOR = {
    X = 1;
    Y = 1;
    locked = false;
    status = 0;
    sprites = {main = {}, fade = {}, next = {}, sub = {}};
    hasPlaced = false;
}

-- Sets up all the sprites and not much else
function initializeCursor()
  -- Sub-icon for special states
  CURSOR.sprites.sub = GFX.sprite.new(CURSOR_STATUS_GFX);
  CURSOR.sprites.sub:setZIndex(2400);
  CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[6]);
  CURSOR.sprites.sub:setCenter(0, 0);
  CURSOR.sprites.sub:add();
  -- The main cursor surround, minus any notice icons
  CURSOR.sprites.main = GFX.sprite.new(CURSOR_GFX);
  CURSOR.sprites.main:setZIndex(2300);
  CURSOR.sprites.main:setImage(CURSOR_GFX[2]);
  CURSOR.sprites.main:setCenter(0, 0);
  CURSOR.sprites.main:add();
  -- The Next Piece
  CURSOR.sprites.next = GFX.sprite.new(GFX.imagetable.new('gfx/pipes'));
  CURSOR.sprites.next:setZIndex(2100);
  -- We dont need to set a sprite for this
  CURSOR.sprites.next:setCenter(0, 0);
  CURSOR.sprites.next:add();
  -- The fade that helps cover whatevers below
  CURSOR.sprites.fade = GFX.sprite.new(CURSOR_GFX);
  CURSOR.sprites.fade:setZIndex(2000);
  CURSOR.sprites.fade:setImage(CURSOR_GFX[4]);
  CURSOR.sprites.fade:setCenter(0, 0);
  CURSOR.sprites.fade:add();
end

-- reset it between rounds
function resetCursor()
  CURSOR.locked = false;
  CURSOR.hasPlaced = false;
end

-- These will let you move the cursor around
function moveCursor(x, y)
    CURSOR.X = x
    CURSOR.Y = y
    updateCursorSprite()
end
function moveCursorRelatively(x, y, manual)
    if CURSOR.locked then return end
    if y == nil then
        x = 0
        y = 0
        if directionsPressed.up    then y = -1 end;
        if directionsPressed.right then x =  1 end;
        if directionsPressed.down  then y =  1 end;
        if directionsPressed.left  then x = -1 end;
    end
    CURSOR.X = math.max(1, math.min(CURSOR.X + x, PLAYFIELD.size.X))
    CURSOR.Y = math.max(1, math.min(CURSOR.Y + y, PLAYFIELD.size.Y))
    updateCursorSprite()
end

-- Updates the preview for the next piece, sprite data comes from playfield
function setCursorPreview(previewSprite)
    CURSOR.sprites.next:setImage( previewSprite );
end

-- This just repositions the sprites
function updateCursorSprite()
    -- before we move lets check the status and see if it needs a sprite change
    if getTileAt(CURSOR.X, CURSOR.Y).locked or getTileAt(CURSOR.X, CURSOR.Y).filled then
        CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[6]);
        CURSOR.sprites.sub:setVisible(true)
    elseif getTileAt(CURSOR.X, CURSOR.Y).empty == false then
        CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[1]);
        CURSOR.sprites.sub:setVisible(true)
    else
        CURSOR.sprites.sub:setVisible(false)
    end
    -- now we can move
     CURSOR.sprites.sub:moveTo( ((CURSOR.X - 1) * 28 ) + PLAYFIELD.drawOffset.X + CURSOR_STATUS_OFFSET, ((CURSOR.Y - 1) * 28 ) + PLAYFIELD.drawOffset.Y + CURSOR_STATUS_OFFSET )
    CURSOR.sprites.main:moveTo( ((CURSOR.X - 1) * 28 ) + PLAYFIELD.drawOffset.X + CURSOR_OFFSET,        ((CURSOR.Y - 1) * 28 ) + PLAYFIELD.drawOffset.Y + CURSOR_OFFSET        )
    CURSOR.sprites.next:moveTo( ((CURSOR.X - 1) * 28 ) + PLAYFIELD.drawOffset.X + CURSOR_NEXT_OFFSET,   ((CURSOR.Y - 1) * 28 ) + PLAYFIELD.drawOffset.Y + CURSOR_NEXT_OFFSET   )
    CURSOR.sprites.fade:moveTo( ((CURSOR.X - 1) * 28 ) + PLAYFIELD.drawOffset.X + CURSOR_OFFSET,        ((CURSOR.Y - 1) * 28 ) + PLAYFIELD.drawOffset.Y + CURSOR_OFFSET        )
end

-- Handle the inputs and the repeate timers
local cursorInputHanders <const> = {
    upButtonDown    = function()   directionalInputDown( 'up' )    end,
    upButtonUp      = function()       directionInputUp( 'up' )    end,
    downButtonDown  = function()   directionalInputDown( 'down' )  end,
    downButtonUp    = function()       directionInputUp( 'down' )  end,
    leftButtonDown  = function()   directionalInputDown( 'left' )  end,
    leftButtonUp    = function()       directionInputUp( 'left' )  end,
    rightButtonDown = function()   directionalInputDown( 'right' ) end,
    rightButtonUp   = function()       directionInputUp( 'right' ) end,
    AButtonUp       = function() mainActionInputHandler()          end,
    BButtonUp = function()
        print('B Button Up, maybe do something')
    end,
}
playdate.inputHandlers.push(cursorInputHanders)

-- manages the directional input, a surprising complex task when you very particular on how it should work
function directionalInputDown( direction )
    directionsPressed[direction] = true
    if moveDelay == nil then
        moveDelay = TIMER.keyRepeatTimer(moveCursorRelatively);
    elseif moveDelay.duration ~= 100 then
        if direction == 'up' then moveCursorRelatively(0,-1) end
        if direction == 'down' then moveCursorRelatively(0,1) end
        if direction == 'left' then moveCursorRelatively(-1,0) end
        if direction == 'right' then moveCursorRelatively(1,0) end
    end
end
function directionInputUp( direction )
    directionsPressed[direction] = false
    if directionsPressed.up == false and directionsPressed.right == false and directionsPressed.down == false and directionsPressed.left == false then
        moveDelay:remove()
        moveDelay = nil
    end
end

-- Manges places, remplacement, and error when trying to do something you can't
function mainActionInputHandler(force)
    if force == nil then force = false end
    if force or CURSOR.locked == false then
        -- Start by lockikng things down and getting details on the current tile
        CURSOR.locked = true;
        local currentTile <const> = getTileAt(CURSOR.X, CURSOR.Y)
        local timerDuration = 0

        -- This can do one of several things depending on currentTile
        -- Filled or a game-placed tile, cannot be changed
        if currentTile.locked or currentTile.filled then
            animation = 'error'
            animationTimer = TIMER.new(LOCK_DURATION_ERROR, function()
                animation = 'none'
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[6]) -- reset error to center
                CURSOR.locked = false;
            end)

        -- filled but not locked, can be removed then added to
        elseif currentTile.empty == false then
            setTileLocked(CURSOR.X, CURSOR.Y)
            animation = 'remove'
            animationTimer = TIMER.new(LOCK_DURATION_REMOVE, function()
                updateTileAt(CURSOR.X, CURSOR.Y, 0)
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[1])
                mainActionInputHandler(true)
            end)

        -- just a boring empty tile, add
        else
            animation = 'add'
            startPreviewAnimation()
            animationTimer = TIMER.new(LOCK_DURATION_ADD, function()
                updateTileAt(CURSOR.X, CURSOR.Y, getNextTile().index)
                previewAdd()
                animation = 'none'
                CURSOR.sprites.main:setImage(CURSOR_GFX[2]); -- reset cursor to normal size
                updateCursorSprite()
                resetPreviewAnimation();
                CURSOR.locked = false;
            end)
            if CURSOR.hasPlaced == false then
            startTimer()
            CURSOR.hasPlaced = true
            end;
        end
    end
end

-- Manges the cursor and sub-status animations
local ADD_LOCK_THIRD           <const> = LOCK_DURATION_ADD/3;
local ERROR_LOCK_SINGLE_FRAME  <const> = LOCK_DURATION_ERROR/11;
local REMOVE_LOCK_SINGLE_FRAME <const> = LOCK_DURATION_REMOVE/11;
function cursorAnimation()
    if animation ~= 0 then

        -- add animation, frames 1-3 of the sheet
        if animation == 'add' then
            if animationTimer._currentTime < ADD_LOCK_THIRD then
                CURSOR.sprites.main:setImage(CURSOR_GFX[1]);
            elseif animationTimer._currentTime < ADD_LOCK_THIRD*2 then
                CURSOR.sprites.main:setImage(CURSOR_GFX[2]);
            else
                CURSOR.sprites.main:setImage(CURSOR_GFX[3]);
            end
        end

        -- error animation, back and forth, starting from frame 6
        if animation == 'error' then
            local frameNumber <const> = math.floor(animationTimer._currentTime / ERROR_LOCK_SINGLE_FRAME) + 1;
            if frameNumber == 1 or frameNumber == 3 or frameNumber == 9 or frameNumber == 11 then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[5])
            elseif frameNumber == 2 or frameNumber == 10  then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[4])
            elseif frameNumber == 5 or frameNumber == 7  then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[7])
            elseif frameNumber == 6  then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[8])
            else -- 4, 8, 12
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[6])
            end
        end

        -- remove animation, turns the wrench 3x
        if animation == 'remove' then
            local frameNumber <const> = math.floor(animationTimer._currentTime / REMOVE_LOCK_SINGLE_FRAME) + 1;
            if frameNumber == 1 or frameNumber == 3 or frameNumber == 5 or frameNumber == 7 or frameNumber == 9 or frameNumber == 11 then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[2])
            elseif frameNumber == 2 or frameNumber == 6 or frameNumber == 10 then
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[3])
            else -- 4, 8
                CURSOR.sprites.sub:setImage(CURSOR_STATUS_GFX[1])
            end
        end
    end
end
