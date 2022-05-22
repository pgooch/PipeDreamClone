-- Load needed core libraries
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"

-- Load constants needed for this file
local GFX   <const> = playdate.graphics;
local TIMER <const> = playdate.timer;

-- Image the other files that keep things clean(er, sorta)
import "tiles"
import "water_walker"
import "playfield"
import "timer_flow_bar"
import "cursor"
import "system_menu"

-- Set some Playdate settings
playdate.display.setRefreshRate(50)

-- Initialize Things
playfieldInitialize()
initializeSystemMenu()

playfieldStart()

-- Load up and place the background
backgroundImage = GFX.sprite.new(GFX.image.new('gfx/backdrop'))
backgroundImage:setCenter(0, 0)
backgroundImage:moveTo(0,0);
backgroundImage:add();
backgroundImage:setZIndex(0);

-- Setup the font, probably will get moved
GFX.setFont(GFX.font.new('gfx/Nontendo-Bold'))

-- The main loop
-- local line1 <const> = "Stage 1⁃1"
-- local line2 <const> = "Ⅷ↉Ⅸ⅟Ⅳ"
-- local line3 <const> = "Here"
-- local line4 <const> = "Here"

function playdate.update()
    GFX.sprite.update()
    TIMER.updateTimers()

    cursorAnimation()
    updateTimerDisplay()
    previewAnimation()
    waterAnimation()

    playdate.drawFPS(43, 228);

    -- Tharr be memory memory leaks ahead
    -- GFX.setFont( GFX.font.new('gfx/W95FA'))
    -- GFX.drawTextAligned(line1, 42, 196, kTextAlignment.center )
    -- GFX.drawTextAligned(line2, 42, 210, kTextAlignment.center )
    -- GFX.drawTextAligned(line3, 42, 222, kTextAlignment.center )
    -- GFX.drawTextAligned(line4, 42, 236, kTextAlignment.center )
    -- collectgarbage()
end

-- function playdate.debugDraw()
--     -- playdate.graphics.drawRect(42, 0, 34, 176) 
-- end
