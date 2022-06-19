-- Load needed core libraries
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"

-- Load constants needed for this file
local GFX   <const> = playdate.graphics;
local TIMER <const> = playdate.timer;



-- Image the other files that keep things clean(er, sorta)
import "intermission"
import "tiles"
import "playfield"
-- import "water_walker"
-- import "timer_flow_bar"
import "cursor"
-- import "system_menu"
-- import "message_box"

-- Set some Playdate settings
playdate.display.setRefreshRate(50)


-- Handle loading, this is the starting state
local loadingSubState = 1;
local LOAD_ORDER <const> = {
    function() setLoadingMessage('Loading Graphics…'); end,
    function()
        loadIntermissionGraphics();
        loadPlayfieldGraphics();
    end,
    -- function() setLoadingMessage('Setting Background...'); end,
    -- function()
    -- playdate.wait(1000)
    --     setBackground();
    -- playdate.wait(1000)
    -- end,
    function() setLoadingMessage('Building Playfield…'); end,
    function()
        playdate.wait(1000)
        buildPlayfield();
        playdate.wait(1000)
    end,
};
function loadingUpdater();
    if LOAD_ORDER[loadingSubState] ~= nil then
        LOAD_ORDER[loadingSubState]()
    else
        changeGameState('playing');
    end
    loadingSubState += 1;
end



-- Current idea is that this part of the background is ever-present, the menus and such going inside the playfield.
function setBackground()
    backgroundImage = GFX.sprite.new(GFX.image.new('gfx/backdrop'))
    backgroundImage:setCenter(0, 0)
    backgroundImage:moveTo(0,0);
    -- backgroundImage:add();
    backgroundImage:setZIndex(0);
end


-- Setup gamestate managmented
local CURRENT_UPDATER = function() end;
function changeGameState(desiredState)
    if desiredState == 'loading' then
        CURRENT_UPDATER = loadingUpdater;
    elseif desiredState == 'playing' then
        setLoadingMessage('Preparing Board...');
        setupBoard()
        setLoadingMessage('Let\'s Pipe!');
        leaveIntermission();
        CURRENT_UPDATER = playfieldUpdater;
    else
        print('Attempted to chainge to unknown state.', desiredState);
    end
end



-- Handle the actual main loop and start by loading
function playdate.update()
    GFX.sprite.update();
    TIMER.updateTimers();

    CURRENT_UPDATER();

    intermissionAnimations();

    playdate.drawFPS(43, 228);
end
changeGameState('loading')



-- Manage game state
-- local GAMESTATE <const> = {
--     loading = { init = loadingInitializer,   update = loadingUpdater, sub = 0 },
--     playing = { init = playfieldInitializer, update = playfieldUpdater },
--     intermission = 100,
-- }
-- local CURRENT_GAME_STATE = 'loading';

-- function changeGameState(desiredState)
--     GAMESTATE[desiredState].init();
--     CURRENT_UPDATER = GAMESTATE[desiredState].update;
-- end

-- The actual main loop
-- local CURRENT_UPDATER = loadingUpdater;
-- function playdate.update()
--     GFX.sprite.update();
--     TIMER.updateTimers();

--     CURRENT_UPDATER();

--     intermissionAnimations();
-- end























-- Start things off by loading
-- loadingInitializer();


    -- local test = GFX.image.new('gfx/1471649305979.png')
    -- test:setMaskImage(INTERMISSION_GRAPHICS.OUT_MASKS[fnum])
    -- test:draw(0,0, playdate.graphics.kImageUnflipped);

    -- fnum += 1;
    -- if fnum >38 then
    --     fnum = 1;
    -- end

    -- print('this works')


-- start with the loading
-- playdate.update = loadingUpdater;
-- local currentUpdater = loadingUpdate;
-- function playdate.update()
    -- GFX.sprite.update();
    -- TIMER.updateTimers();

--     print(currentUpdater)
--     currentUpdater();
-- end


--[[
-- Initialize Things
playfieldInitialize()
initializeSystemMenu()
initializeMessagebox()

playfieldStart()

-- Load up and place the background
backgroundImage = GFX.sprite.new(GFX.image.new('gfx/backdrop'))
backgroundImage:setCenter(0, 0)
backgroundImage:moveTo(0,0);
backgroundImage:add();
backgroundImage:setZIndex(0);

-- Setup the font, probably will get moved
-- GFX.setFont(GFX.font.new('gfx/W95FA'))

-- The main loop
local line1 <const> = "Stage Dist. Distance Close Pipe\nScore 0 1 2 3 4 5 6 7 8 9 , + \nRead End No Leads Use Pipe Storage Tank Boiler"
-- local line2 <const> = "Ⅷ↉Ⅸ⅟Ⅳ"
-- local line3 <const> = "Here"
-- local line4 <const> = "Here"

comeFromIntermission();

-- function playdate.update()
    GFX.sprite.update()
    TIMER.updateTimers()

    cursorAnimation()
    updateTimerDisplay()
    previewAnimation()
    waterAnimation()
    intermissionAnimation()
-- local PLAYFIELD_DRAW_OFFSET <const> = { X = 87, Y = 7 } -- this is also in; cursor

    playdate.drawFPS(43, 228);

    -- GFX.setClipRect(85, 5, 285, 229);
    -- GFX.fillCircleAtPoint(85, 5, 3)  -- 365
    -- Tharr be memory memory leaks ahead
    -- GFX.setFont( GFX.font.new('gfx/W95FA'))
    -- GFX.drawTextAligned(line1, 88, 196, kTextAlignment.left )
    -- GFX.drawTextAligned(line2, 42, 210, kTextAlignment.center )
    -- GFX.drawTextAligned(line3, 42, 222, kTextAlignment.center )
    -- GFX.drawTextAligned(line4, 42, 236, kTextAlignment.center )
    -- collectgarbage()
end

-- function playdate.debugDraw()
--     -- playdate.graphics.drawRect(42, 0, 34, 176) 
-- end

]]--
