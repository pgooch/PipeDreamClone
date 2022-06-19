-- This file handles the flow, after trigger it "walks" areound the board, updating sprites as
-- it goes, based on level timings provided. Once it's over this will trigger whatever ends it

-- Load constants needed for this file
-- local GFX               <const> = playdate.graphics;
-- local CURSOR_GFX        <const> = GFX.imagetable.new('gfx/cursor')
-- local CURSOR_STATUS_GFX <const> = GFX.imagetable.new('gfx/cursor-status')
local TIMER                          <const> = playdate.timer;
local STANDARD_ANIMATION_FRAME_COUNT <const> = 28

-- The main cursor object that all this stuff is contained in
local WATER_TIMER = nil;
local WATER = {
    X = 1;
    Y = 1;
    flowing = false;
    speed = 13400; -- speed is ms for a standard piece, a standard piece is like a straight one
    currentTile = nil;
    currentDirection = '0';
}

-- Sets it up and places it where it needs to go. Called by playfield initialzie after the start is places
function prepareWaterWalker(x, y)
    WATER.X = x;
    WATER.Y = y;
    WATER.currentTile = nil;
    WATER.currentDirection = 'O';
    WATER.speed = 4200; -- max arond 4200 start, min ardoun 1600 end, maybe 100 turbo flow
end

-- This will rush the round over
function finishRound()
    WATER.speed = 100;
    endTimer();
end

-- Starts things off, called by either the timer or the player via menu
function startFlow()
    if WATER.flowing == false then
        WATER.flowing = true;
        WATER.currentTile = getTileAt(WATER.X, WATER.Y);
        WATER.currentDirection = 'O';

        WATER_TIMER = TIMER.new(  (WATER.currentTile.fillFrames / STANDARD_ANIMATION_FRAME_COUNT) * WATER.speed, stepWaterWalker)
    end
end

-- this steps the walker to the next tile, or ends the round
function stepWaterWalker()
    local heading <const> = WATER.currentTile.paths[WATER.currentDirection];

    -- Update the score and the objectives
    subtractFromDistance();
    if WATER.currentTile.name == "Cross" and WATER.currentTile.locked == true then
        addToScore(300)
    else
        addToScore(100)
    end

    -- Cleanup the display and set properties
    if WATER.currentTile.name ~= "Cross" or WATER.currentTile.locked == true then
        setTileSpriteFrame(WATER.X, WATER.Y, WATER.currentTile.sprites.full)
        setTileLocked(WATER.X, WATER.Y)
        setTileFilled(WATER.X, WATER.Y)
    elseif WATER.currentTile.name == "Cross" then
        setTileLocked(WATER.X, WATER.Y)
        if WATER.currentDirection == "N" or WATER.currentDirection == "S" then
            setTileSpriteFrame(WATER.X, WATER.Y, WATER.currentTile.sprites.vFull)
            addToScore(100)
        else -- Water flowing horizontally
            setTileSpriteFrame(WATER.X, WATER.Y, WATER.currentTile.sprites.hFull)
        end
    end

    -- Do the actual moving
    if heading == "N" then
        WATER.Y += 1;
    elseif heading == "E" then
        WATER.X -= 1;
    elseif heading == "S" then
        WATER.Y -= 1;
    else -- W
        WATER.X += 1;
    end

    -- set the new current tile information
    WATER.currentDirection = heading;
    WATER.currentTile = getTileAt(WATER.X, WATER.Y)

    -- Check if we have reached the end of the path
    if WATER.currentTile == nil or WATER.currentTile.filled or WATER.currentTile.paths[WATER.currentDirection] == " " then
        WATER.flowing = false;
        WATER_TIMER = nil;
        print('Game over man');

        -- There is still more path to go, set a new animation timer
    else
        WATER_TIMER = TIMER.new( (WATER.currentTile.fillFrames / STANDARD_ANIMATION_FRAME_COUNT) * WATER.speed, stepWaterWalker)
    end

end

-- this cycles through the crazy spritesheet
function waterAnimation()
    if WATER_TIMER ~= nil then

        local frame = nil

        if WATER.currentTile.name == "Cross" and WATER.currentTile.locked then
            if WATER.currentDirection == "N" or WATER.currentDirection == "S" then
                frame = WATER.currentTile.sprites.flow['hFull'..WATER.currentDirection] + math.floor((WATER_TIMER.currentTime/WATER_TIMER.duration) *  (WATER.currentTile.fillFrames-1) ) -- not technically rounding but I ain't bothering with that in lua
            else -- Water flowing horizontally
                frame = WATER.currentTile.sprites.flow['vFull'..WATER.currentDirection] + math.floor((WATER_TIMER.currentTime/WATER_TIMER.duration) *  (WATER.currentTile.fillFrames-1) ) -- not technically rounding but I ain't bothering with that in lua
            end
        else -- normal, not cross peices
            frame = WATER.currentTile.sprites.flow[WATER.currentDirection] + math.floor((WATER_TIMER.currentTime/WATER_TIMER.duration) *  (WATER.currentTile.fillFrames-1) ) -- not technically rounding but I ain't bothering with that in lua
        end

        setTileSpriteFrame( WATER.X, WATER.Y, frame )
    end
end
