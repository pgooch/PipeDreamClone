-- Load constants needed for this file
local GFX   <const> = playdate.graphics;
local TIMER <const> = playdate.timer;

-- graphics
local BAR_LABEL_TEXT <const> = GFX.imagetable.new('gfx/timer-flow-icon')

-- For now just hard code some values for testing, later pull from a levels object
local thisRoundTime = 6000

-- These constants are for positioning and sizing the bar
local TIMER_BAR_X       <const> = 386
local TIMER_BAR_Y_START <const> = 194
local TIMER_BAR_Y_END   <const> = 7
local TIMER_BAR_LENGTH  <const> = TIMER_BAR_Y_START - TIMER_BAR_Y_END

local BAR_X <const> = 381;
local BAR_Y <const> = 216;
local BAR_W <const> = 11;
local BAR_H <const> = -209;

-- The actual timer
local ROUND_TIMER = nil;

local BAR = {
    sprite = GFX.sprite.new(BAR_LABEL_TEXT);
    fillProgress = 1.0;
    thisRoundTime = 30000;
};

function initializeTimerFlowBar()
    BAR.timer = TIMER.new(BAR.thisRoundTime, roundTimerUp)
    BAR.timer:pause()

    BAR.sprite:setImage(BAR_LABEL_TEXT[2]);
    BAR.sprite:setCenter(0, 1);
    BAR.sprite:add();
    BAR.sprite:moveTo(381, 232);
    BAR.sprite:setZIndex(3000);

    -- I don't suspect I'll be drawing any other straight lines so seems fine to set this once and forget it
    GFX.setLineWidth(0)
end

function startTimer()
    BAR.timer:start();
end

function endTimer()
    -- This is a very temp solution I want it to swap out the timer with a "flowing" message and such but I don't feel like futzing with that at this moment
    BAR.timer.currentTimer = 1;
    BAR.timer.duration = 1;
    startFlow();
end

function roundTimerUp()
    startFlow()
end

function updateTimerDisplay()
    BAR.fillProgress = 1-(BAR.timer._currentTime/BAR.timer.duration);
    GFX.fillRoundRect(BAR_X, BAR_Y, BAR_W, BAR_H * BAR.fillProgress, 2) 
end
