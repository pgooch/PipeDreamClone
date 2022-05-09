-- Load constants needed for this file
local GFX <const> = playdate.graphics;

-- The timer
local ROUND_START_TIMER = {};

-- For now just hard code some values for testing, later pull from a levels object
local thisRoundTime = 30000

-- These constants are for positioning and sizing the bar
local TIMER_BAR_X       <const> = 386
local TIMER_BAR_Y_START <const> = 206
local TIMER_BAR_Y_END   <const> = 7

function flowTimerInit()
    ROUND_START_TIMER = {};
    ROUND_START_TIMER.value = TIMER_BAR_Y_END;

    -- I don't suspect I'll be drawing any other straight lines so seems fine to set this once and forget it
    GFX.setLineWidth(11)
    GFX.setLineCapStyle(GFX.kLineCapStyleButt)
end

function startTimer()
    ROUND_START_TIMER = playdate.timer.new(thisRoundTime, TIMER_BAR_Y_END, TIMER_BAR_Y_START )
end

function updateTimerDisplay()
    if ROUND_START_TIMER.value == TIMER_BAR_Y_START then
        GFX.drawTextAligned('Time: Now', 8, 186, kTextAlignment.left )
    else
        GFX.drawTextAligned('Time: '..tostring( (TIMER_BAR_Y_START - TIMER_BAR_Y_END) - (math.floor(ROUND_START_TIMER.value) - TIMER_BAR_Y_END) ), 8, 186, kTextAlignment.left )
        GFX.drawLine( TIMER_BAR_X, TIMER_BAR_Y_START, TIMER_BAR_X, ROUND_START_TIMER.value)
    end
end
