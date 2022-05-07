-- Load needed core libraries
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Load constants needed for this file
local GFX   <const> = playdate.graphics;
local TIMER <const> = playdate.timer;

-- Image the other files that keep things clean(er, sorta)
import "tiles"
import "playfield"
import "start_timer"
import "cursor"
import "system_menu"

-- Set some Playdate settings
playdate.display.setRefreshRate(50)

-- Initialize Things
playfieldInitialize()
initializeCursor()
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
local line1 <const> = "Some"
local line2 <const> = "Stuff"
local line3 <const> = "Here"

function playdate.update()
    GFX.sprite.update()
    TIMER.updateTimers()

    updateTimerDisplay()

    playdate.drawFPS(2, 167);

    GFX.drawTextAligned(line1, 42, 198, kTextAlignment.center )
    GFX.drawTextAligned(line2, 42, 210, kTextAlignment.center )
    GFX.drawTextAligned(line3, 42, 222, kTextAlignment.center )
end
