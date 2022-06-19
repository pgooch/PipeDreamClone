-- Load constants needed for this file
local GFX <const> = playdate.graphics;
local TIMER <const> = playdate.timer;

-- Settings for various thins
local PREVIEW_ANIMATION_DURATION = 240 -- keep cusor.lua LOCK_DURATION_ADD in mind

-- Defines the clipping box for the preview animation
local PREVIEW_MASK_X <const> = 42
local PREVIEW_MASK_Y <const> = 5
local PREVIEW_MASK_W <const> = 34
local PREVIEW_MASK_H <const> = 236


-- Load tile graphics
local PIPES_GFX <const> = GFX.imagetable.new('gfx/pipes');

local PLAYFIELD_DRAW_OFFSET <const> = { X = 87, Y = 7 } -- this is also in; cursor
local PLAYFIELD_SIZE        <const> = { X = 10, Y = 8 }
local PLAYFIELD_MAX_INDEX   <const> = PLAYFIELD_SIZE.X * PLAYFIELD_SIZE.Y;
local PREVIEW_COUNT         <const> = 10;
local PREVIEW_DRAW_OFFSET   <const> = { X = 45, Y = 7 }
local PREVIEW_INDEX_START   <const> = PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y+1;

local PLAYFIELD = {};
playfield = {};



-- Load all the assets we are going to need
local PLAYFIELD_GRAPHICS = {
    BACKDROP = {},
    TILES = {},
}
function loadPlayfieldGraphics()
	PLAYFIELD_GRAPHICS.BACKDROP = GFX.image.new('gfx/backdrop.png');
	PLAYFIELD_GRAPHICS.PIPES = GFX.imagetable.new('gfx/pipes');
end



function buildPlayfield()
	-- First just create the basics for the playfield and preview
	for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y) do -- All are stored inthe single playfield object, first group is the field, then preview
		PLAYFIELD[n] = {}

		-- Handle the X/Y, N, and index for future reference
		PLAYFIELD[n].Y = math.floor((n-1)/PLAYFIELD_SIZE.X) + 1;
		PLAYFIELD[n].X = ((n-1) % PLAYFIELD_SIZE.X) + 1;
		PLAYFIELD[n].N = n;

		-- Prepare the sprite
        PLAYFIELD[n].sprite = GFX.sprite.new(PLAYFIELD_GRAPHICS.PIPES[14]);
		PLAYFIELD[n].sprite:setZIndex( 1000 + n );
		PLAYFIELD[n].sprite:setCenter(0, 0);
		PLAYFIELD[n].sprite:add();
	end

	-- Move all the playfield sprites
	for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y) do
		PLAYFIELD[n].sprite:moveTo( PLAYFIELD_DRAW_OFFSET.X + ((PLAYFIELD[n].X-1)*28), PLAYFIELD_DRAW_OFFSET.Y + ((PLAYFIELD[n].Y-1)*28) );
	end
end



function setupBoard()
    -- clear the field
    for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y) do
		updateTile( n, 0 );
    end

    -- Place the starting point
    startX = math.random(3,PLAYFIELD_SIZE.X-2);
    startY = math.random(3,PLAYFIELD_SIZE.Y-2);
    startF = math.random(1,4); -- F for Facing, up down left right
    -- logic to prevent it from poiting outword if placed in the furthest edges
    if startY == 3 and startF == 1 then
        startF = 2;
    elseif startY == PLAYFIELD_SIZE.Y-2 and startF == 2 then
        startF = 1;
    end
    if startX == 3 and startF == 3 then
        startF = 4;
    elseif startX == PLAYFIELD_SIZE.X-2 and startF == 4 then
        startF = 3;
    end
    -- place the starting peice
    updateTileAt(startX, startY, START_TILES[startF])

end


-- -- import "intermission"
-- function setupBoard()
-- end



-- -- Handle main gameplay
-- function playfieldInitializer()
--     -- dra
--     -- local test = GFX.image.new('gfx/1471649305979.png')
--     -- test:draw(0,0, playdate.graphics.kImageUnflipped);
--     -- setLoadingMessage('Preparing Playfield');
--     --     loadIntermissionGraphics();
--     --     loadPlayfieldGraphics();
--     --     loadIntermissionGraphics();
--     --     loadPlayfieldGraphics();
--     -- setLoadingMessage('Let\'s Pipe!');
--     -- leaveIntermission();
-- end
function playfieldUpdater();
--     -- local test = GFX.image.new('gfx/1471649305979.png')
--     -- test:draw(0,0, playdate.graphics.kImageUnflipped);
end


















-- local DEBUG_PLAYFIELD <const> = {
-- 	0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
-- 	0 , 3 , 1 , 4 , 0 , 0 , 3 , 1 , 4 , 0 ,
-- 	0 , 2 , 0 , 2 , 0 , 0 , 2 , 0 , 2 , 0 ,
-- 	0 , 5 , 1 , 7 , 1 , 2 , 7 , 1 , 6 , 0 ,
-- 	0 , 3 , 1 , 7 , 1 ,11 , 1 , 1 , 4 , 0 ,
-- 	0 , 2 , 0 , 2 , 0 , 2 , 2 , 0 , 2 , 0 ,
-- 	0 , 5 , 1 , 6 , 0 , 0 , 5 , 1 , 6 , 0 ,
-- 	0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
-- 	0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 -- extra row for preview, remember to disable default start tile placement
-- }
-- prepareWaterWalker(6, 5)

-- create a fresh clean playfield
-- function playfieldInitialize()

-- 	-- First just create the basics for the playfield and preview
-- 	for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y)+PREVIEW_COUNT do -- All are stored inthe single playfield object, first group is the field, then preview
-- 		PLAYFIELD[n] = {}

-- 		-- Handle the X/Y, N, and index for future reference
-- 		if n <= (PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y) then
-- 			PLAYFIELD[n].Y = math.floor((n-1)/PLAYFIELD_SIZE.X) + 1;
-- 			PLAYFIELD[n].X = ((n-1) % PLAYFIELD_SIZE.X) + 1;
-- 		else
-- 			PLAYFIELD[n].Y = -1;
-- 			PLAYFIELD[n].X = -1;
-- 		end
-- 		PLAYFIELD[n].N = n;

-- 		-- Prepare the sprite
--         PLAYFIELD[n].sprite = GFX.sprite.new(PIPES_GFX);
-- 		PLAYFIELD[n].sprite:setZIndex( 1000 + n );
-- 		PLAYFIELD[n].sprite:setCenter(0, 0);
-- 		PLAYFIELD[n].sprite:add();
-- 	end

-- 	-- Move all the playfield sprites
-- 	for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y) do
-- 		PLAYFIELD[n].sprite:moveTo( PLAYFIELD_DRAW_OFFSET.X + ((PLAYFIELD[n].X-1)*28), PLAYFIELD_DRAW_OFFSET.Y + ((PLAYFIELD[n].Y-1)*28) );
-- 	end
--     -- Move the Preview sprites, set the clipping rect for the animation
-- 	resetPreviewAnimation()
-- 	for n = PREVIEW_COUNT-1,0,-1 do
-- 		PLAYFIELD[PREVIEW_INDEX_START+n].sprite:setClipRect(PREVIEW_MASK_X, PREVIEW_MASK_Y, PREVIEW_MASK_W, PREVIEW_MASK_H)
-- 	end

-- 	-- initialize others things that need to be started with the playfield
-- 	initializeCursor();
-- end

-- -- This is the function thats called at the start of a round
-- function playfieldStart()

--     -- clear the field
--     for n = 1,(PLAYFIELD_SIZE.X*PLAYFIELD_SIZE.Y)+PREVIEW_COUNT do
-- 		updateTile( n, 0 );
-- 		-- updateTile( n, DEBUG_PLAYFIELD[n] );
--     end

--     -- Place the starting point
--     startX = math.random(3,PLAYFIELD_SIZE.X-2);
--     startY = math.random(3,PLAYFIELD_SIZE.Y-2);
--     startF = math.random(1,4); -- F for Facing, up down left right
--     -- logic to prevent it from poiting outword if placed in the furthest edges
--     if startY == 3 and startF == 1 then
--         startF = 2;
--     elseif startY == PLAYFIELD_SIZE.Y-2 and startF == 2 then
--         startF = 1;
--     end
--     if startX == 3 and startF == 3 then
--         startF = 4;
--     elseif startX == PLAYFIELD_SIZE.X-2 and startF == 4 then
--         startF = 3;
--     end
--     -- place the starting peice
--     updateTileAt(startX, startY, START_TILES[startF])
-- 	prepareWaterWalker(startX, startY)

--     -- Move the cursor to the start
--     if startF == 1 then
--         moveCursor(startX +1, startY)
--     elseif startF == 2 then
--         moveCursor(startX, startY +1)
--     elseif startF == 3 then
--         moveCursor(startX -1, startY)
--     else
--         moveCursor(startX, startY -1)
--     end

-- 	-- get the needed number of preview peices and place them
-- 	for n = 1,PREVIEW_COUNT do
-- 		previewAdd();
-- 	end

--     -- Finally initialize the flow start timer
-- 	clearScore();
-- 	resetCursor();
-- 	initializeTimerFlowBar();
-- end

-- -- Call when you place a peice or during setup
-- function previewAdd()
-- 	for n = 0,PREVIEW_COUNT-2 do
-- 		updateTile(PREVIEW_INDEX_START+n, PLAYFIELD[PREVIEW_INDEX_START+n+1].index)
-- 	end
--     nextTile = getRandomTile()
-- 	updateTile(PREVIEW_INDEX_START+PREVIEW_COUNT-1, nextTile.index )
--     setCursorPreview(PIPES_GFX[PLAYFIELD[PREVIEW_INDEX_START].sprites.empty])
-- end

-- Ways to update tiles, will update the sprite graphics and all the associated data
function updateTileAt(x, y, new)
	local n = ((y-1) * PLAYFIELD_SIZE.X) + x;
	updateTile(n, new);
end
function updateTile(n, new)
	local originalTile = getTileDetails(new);
	for k, v in pairs(originalTile) do
		if k ~= "sprite" then
			if type(v) == "table" then
				PLAYFIELD[n][k] = table.shallowcopy(v)
			else
				PLAYFIELD[n][k] = v
			end
		end
	end
	PLAYFIELD[n].sprite:setImage(PIPES_GFX[originalTile.sprites.empty]);
end

-- -- Ways to simply set a tiles animation frame, used by the water walker to animate the flow
-- function setTileSpriteFrame(x,y,frame)
-- 	local n = ((y-1) * PLAYFIELD_SIZE.X) + x;
-- 	PLAYFIELD[n].sprite:setImage(PIPES_GFX[frame]);
-- end

-- -- Sets a tile to filled, called by the walker once it's done with a space.
-- function setTileFilled(x,y)
-- 	local n = ((y-1) * PLAYFIELD_SIZE.X) + x;
-- 	PLAYFIELD[n].filled = true;
-- end
-- function setTileLocked(x,y)
-- 	local n = ((y-1) * PLAYFIELD_SIZE.X) + x;
-- 	PLAYFIELD[n].locked = true;
-- end

-- -- Ways to get details about tiles at specified locatins
-- function getTileAt(x, y)
-- 	if x < 1 or x > PLAYFIELD_SIZE.X or y < 0 or y > PLAYFIELD_SIZE.Y then
-- 		return getTile(-1);
-- 	end
-- 	local n = ((y-1) * PLAYFIELD_SIZE.X) + x;
-- 	return getTile(n);
-- end
-- function getTile(n)
--     return PLAYFIELD[n]
-- end

-- -- gets the next tile from the preview
-- function getNextTile()
-- 	return PLAYFIELD[PREVIEW_INDEX_START]
-- end

-- -- Returns data about the playfield so other places can keep a local copy
-- function getPlayfieldData()
--     return {
--         drawOffset = PLAYFIELD_DRAW_OFFSET,
--         size = PLAYFIELD_SIZE,
--     };
-- end

-- -- This is for the preview animation, it is started by getNextTile and it ends itself
-- local animationOffsetTimer = nil;
-- function startPreviewAnimation()
-- 	offsetTimer = TIMER.new(PREVIEW_ANIMATION_DURATION, 0, 29, playdate.easingFunctions.outBack)
-- end
-- function previewAnimation()
-- 	if offsetTimer ~= nil then
-- 		for n = PREVIEW_COUNT-1,0,-1 do
-- 			PLAYFIELD[PREVIEW_INDEX_START+n].sprite:moveTo( PREVIEW_DRAW_OFFSET.X , PREVIEW_DRAW_OFFSET.Y + (n*28) - offsetTimer.value );
-- 		end
-- 	end
-- end
-- function resetPreviewAnimation()
-- 	for n = PREVIEW_COUNT-1,0,-1 do
-- 		PLAYFIELD[PREVIEW_INDEX_START+n].sprite:moveTo( PREVIEW_DRAW_OFFSET.X , PREVIEW_DRAW_OFFSET.Y + (n*28) );
-- 	end
-- 	offsetTimer = nil;
-- end
