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
local movingDirections = { X = 0, Y = 0 }

-- We need a few bits of data about the playfield, but we want to store it locally for performance
local PLAYFIELD <const> = getPlayfieldData();

-- The main cursor object that all this stuff is contained in
local CURSOR = {
    X = 1;
    Y = 1;
    locked = false;
    status = 0;
    sprites = {main = {}, fade = {}, next = {}, sub = {}};
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

-- These will let you move the cursor around
function moveCursor(x, y)
    CURSOR.X = x
    CURSOR.Y = y
    updateCursorSprite()
end
function moveCursorRelatively(x, y)
    if y == nil then
        x = movingDirections.X
        y = movingDirections.Y
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
    if getTileAt(CURSOR.X, CURSOR.Y).locked then
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
local moveDelay = nil
local cursorInputHanders <const> = {
    upButtonDown = function()
        movingDirections.Y -= 1;
        if moveDelay == nil then
            moveDelay = TIMER.keyRepeatTimer(moveCursorRelatively)
        end
    end,
    upButtonUp = function()
        movingDirections.Y += 1;
        if movingDirections.X == 0 and movingDirections.Y == 0 then
            moveDelay:remove()
            moveDelay = nil
        end
    end,
    rightButtonDown = function()
        movingDirections.X += 1;
        if moveDelay == nil then
            moveDelay = TIMER.keyRepeatTimer(moveCursorRelatively)
        end
    end,
    rightButtonUp = function()
        movingDirections.X -= 1;
        if movingDirections.X == 0 and movingDirections.Y == 0 then
            moveDelay:remove()
            moveDelay = nil
        end
    end,
    downButtonDown = function()
        movingDirections.Y += 1;
        if moveDelay == nil then
            moveDelay = TIMER.keyRepeatTimer(moveCursorRelatively)
        end
    end,
    downButtonUp = function()
        movingDirections.Y -= 1;
        if movingDirections.X == 0 and movingDirections.Y == 0 then
            moveDelay:remove()
            moveDelay = nil
        end
    end,
    leftButtonDown = function()
        movingDirections.X -= 1;
        if moveDelay == nil then
            moveDelay = TIMER.keyRepeatTimer(moveCursorRelatively)
        end
    end,
    leftButtonUp = function()
        movingDirections.X += 1;
        if movingDirections.X == 0 and movingDirections.Y == 0 then
            moveDelay:remove()
            moveDelay = nil
        end
    end,
    AButtonUp = function()
        print('A Button Up, place piece')
    end,
    BButtonUp = function()
        print('B Button Up, maybe do something')
    end,

}
-- done this way because I'll probably want to use do it differently for menus
playdate.inputHandlers.push(cursorInputHanders)




-- To get auto-repeating were managing moving, done on a framebases
-- vMoveRepeating = false;
-- vMoveTimer = 0;
-- hMoveRepeating = false;
-- hMoveTimer = 0;
-- updatedThisFrame = false;
-- function manageInputs()
--     if CURSOR.locked then return end

--     -- Buttons states updating if were moving
--     if playdate.buttonJustPressed(playdate.kButtonDown) or playdate.buttonJustPressed(playdate.kButtonUp) then
--         vMoveTimer = 1;
--     elseif playdate.buttonJustReleased(playdate.kButtonDown) or playdate.buttonJustReleased(playdate.kButtonUp) then
--         vMoveTimer = 0;
--         vMoveRepeating = false
--         updatedThisFrame = false;
--     end
--     if playdate.buttonJustPressed(playdate.kButtonLeft) or playdate.buttonJustPressed(playdate.kButtonRight) then
--         hMoveTimer = 1;
--     elseif playdate.buttonJustReleased(playdate.kButtonLeft) or playdate.buttonJustReleased(playdate.kButtonRight) then
--         hMoveTimer = 0;
--         hMoveRepeating = false
--         updatedThisFrame = false;
--     end

--     -- Vertical movement timer/reset
--     if vMoveTimer > 0 then
--         if vMoveTimer == 1 then
--             updatedThisFrame = true;
--             if playdate.buttonIsPressed(playdate.kButtonDown) then
--                 CURSOR.Y = math.min(PLAYFIELD_SIZE.Y, CURSOR.Y+1)
--             else
--                 CURSOR.Y = math.max(1, CURSOR.Y-1)
--             end
--             if vMoveRepeating then
--                 vMoveTimer = CURSOR_SUBSEQUENT_DELAYS
--             else
--                 vMoveTimer = CURSOR_FIRST_DELAY
--             end
--             vMoveRepeating = true
--         else
--             vMoveTimer -= 1
--         end
--     end

--     -- Horizontal movement timer/reset
--     if hMoveTimer > 0 then
--         if hMoveTimer == 1 then
--             updatedThisFrame = true;
--             if playdate.buttonIsPressed(playdate.kButtonRight) then
--                 CURSOR.X = math.min(PLAYFIELD_SIZE.X, CURSOR.X+1)
--             else
--                 CURSOR.X = math.max(1, CURSOR.X-1)
--             end
--             if hMoveRepeating then
--                 hMoveTimer = CURSOR_SUBSEQUENT_DELAYS
--             else
--                 hMoveTimer = CURSOR_FIRST_DELAY
--             end
--             hMoveRepeating = true
--         else
--             hMoveTimer -= 1
--         end
--     end

--     -- Placing tiles
--     if playdate.buttonJustPressed(playdate.kButtonA) then

--         -- CURSOR.locked = true;
--         -- CURSOR.isAnimatingPlacement = true;

--         if getTileAt(CURSOR.X, CURSOR.Y).locked == false then
--             updateTileAt( CURSOR.X, CURSOR.Y, playfield[CONST.preview.startIndex].index );
--             previewAdd();
--             updateCursorSprite();
--         end
--     --   updateTileAt(cursorSprite.X, cursorSprite.Y, playfield[PREVIEW_INDEX_START].index)
--     -- 	previewAdd()
--     -- else
--     --   print('kill it')
--     --   replaceTileAt(cursorSprite.X, cursorSprite.Y, playfield[PREVIEW_INDEX_START].index)
--     -- end


--     end
--     if playdate.buttonJustPressed(playdate.kButtonB) then
--         print("B")
--         printTable(playfield[1])
--     end

--     -- Update id needed
--     if updatedThisFrame then
--         updateCursorSprite()
--     end
-- end
