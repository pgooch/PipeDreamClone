-- The SDK don't have an option for this, and there is a mmemeory leak anyway.
local GFX   <const> = playdate.graphics;

local BOARD_SECTION_WIDTH <const>        = 12;
local BOARD_SHORT_SECTION_HEIGHT <const> = 75;
local BOARD_LONG_SECTION_HEIGHT <const>  = 125;

-- functions to fire functions
function initializeMessagebox()
    initializeScoreDisplay();
    initializeLivesDisplay();
    initializeObjectiveDisplay();
    initializeStageDisplay();
end

-- For all things point related
local SCORE_IMAGE <const> = GFX.image.new(BOARD_SECTION_WIDTH, BOARD_LONG_SECTION_HEIGHT, GFX.kColorWhite);
local SCORE_SPRITE <const> = GFX.sprite.new(SCORE_IMAGE);
local SCORE = 0;
function initializeScoreDisplay()
    SCORE_SPRITE:setZIndex(1000);
    SCORE_SPRITE:setCenter(0, 1);
    SCORE_SPRITE:moveTo( 21, 232);
    SCORE_SPRITE:add();
    updateScoreDisplay();
end
function addToScore(value)
    SCORE += value;
    updateScoreDisplay();
end
function subtractFromScore(value)
    SCORE -= value;
    updateScoreDisplay();
end
function clearScore()
    SCORE = 0;
    updateScoreDisplay();
end
function updateScoreDisplay()
    SCORE_IMAGE:clear(GFX.kColorWhite)
    GFX.pushContext(SCORE_IMAGE)
    drawVerticalString(0, BOARD_LONG_SECTION_HEIGHT, "Score: "..formatNumber(SCORE), kTextAlignment.left) -- 
    GFX.popContext()
end

-- Lives, I wish I had but one
local LIVES_IMAGE <const> = GFX.image.new(BOARD_SECTION_WIDTH, BOARD_SHORT_SECTION_HEIGHT, GFX.kColorWhite);
local LIVES_SPRITE <const> = GFX.sprite.new(LIVES_IMAGE);
local LIVES = 3;
function initializeLivesDisplay()
    LIVES_SPRITE:setZIndex(1000);
    LIVES_SPRITE:setCenter(0, 0);
    LIVES_SPRITE:moveTo( 21, 6);
    LIVES_SPRITE:add();
    updateLivesDisplay();
end
function subtractLife()
    LIVES -= 1;
    updateLivesDisplay();
end
function updateLivesDisplay()
    LIVES_IMAGE:clear(GFX.kColorWhite)
    GFX.pushContext(LIVES_IMAGE)
    drawVerticalString(0, 0, "Lives: "..formatNumber(LIVES), kTextAlignment.right) -- 
    GFX.popContext()
end

-- Objecties, mabye more than just dist
local OBJECTIVE_IMAGE <const> = GFX.image.new(BOARD_SECTION_WIDTH, BOARD_LONG_SECTION_HEIGHT, GFX.kColorWhite);
local OBJECTIVE_SPRITE <const> = GFX.sprite.new(OBJECTIVE_IMAGE);
local DISTANCE_REMAINING = 9;
function initializeObjectiveDisplay()
    OBJECTIVE_SPRITE:setZIndex(1000);
    OBJECTIVE_SPRITE:setCenter(0, 0);
    OBJECTIVE_SPRITE:moveTo( 8, 6);
    OBJECTIVE_SPRITE:add();
    updateObjectiveDisplay();
end
function subtractFromDistance()
    DISTANCE_REMAINING -= 1;
    updateObjectiveDisplay();
end
function updateObjectiveDisplay()
    OBJECTIVE_IMAGE:clear(GFX.kColorWhite)
    GFX.pushContext(OBJECTIVE_IMAGE)
    drawVerticalString(0, 0, "Distance: "..formatNumber(DISTANCE_REMAINING), kTextAlignment.right) -- 
    GFX.popContext()
end

-- For all things point related
local STAGE_IMAGE <const> = GFX.image.new(BOARD_SECTION_WIDTH, BOARD_LONG_SECTION_HEIGHT, GFX.kColorWhite);
local STAGE_SPRITE <const> = GFX.sprite.new(STAGE_IMAGE);
local STAGE_MAJOR = 1;
local STAGE_MINOR = 1;
function initializeStageDisplay()
    STAGE_SPRITE:setZIndex(1000);
    STAGE_SPRITE:setCenter(0, 1);
    STAGE_SPRITE:moveTo( 8, 232);
    STAGE_SPRITE:add();
    updateStageDisplay();
end
function setStage(value)
    SCORE -= value;
    updateStageDisplay();
end
function updateStageDisplay()
    STAGE_IMAGE:clear(GFX.kColorWhite)
    GFX.pushContext(STAGE_IMAGE)
    drawVerticalString(0, BOARD_LONG_SECTION_HEIGHT, "Stage: "..STAGE_MAJOR.."-"..STAGE_MINOR, kTextAlignment.left) -- 
    GFX.popContext()
end



-- This writes the text out vertically, but it ain't performant enough to do it without the sprite-fu above.
local VERTICAL_TEXT_IMAGE <const> = GFX.image.new('gfx/vertical-text')
local VERTICAL_CHARACTER_WIDTH <const> = 12;
local VERTICAL_CHARACTERS <const> = {
    A = { Y = 457, H = 8 }, B = { Y = 450, H = 7 }, C = { Y = 442, H = 7 }, D = { Y = 434, H = 7 },
    E = { Y = 427, H = 6 }, F = { Y = 420, H = 6 }, G = { Y = 412, H = 7 }, H = { Y = 404, H = 7 },
    I = { Y = 401, H = 2 }, J = { Y = 395, H = 5 }, K = { Y = 387, H = 7 }, L = { Y = 380, H = 6 },
    M = { Y = 371, H = 8 }, N = { Y = 363, H = 7 }, O = { Y = 355, H = 7 }, P = { Y = 347, H = 7 },
    Q = { Y = 339, H = 7 }, R = { Y = 331, H = 7 }, S = { Y = 324, H = 6 }, T = { Y = 317, H = 6 },
    U = { Y = 309, H = 7 }, V = { Y = 300, H = 8 }, W = { Y = 289, H = 10}, X = { Y = 280, H = 8 },
    Y = { Y = 271, H = 8 }, Z = { Y = 262, H = 8 },
    a = { Y = 255, H = 6 }, b = { Y = 248, H = 6 }, c = { Y = 241, H = 6 }, d = { Y = 234, H = 6 },
    e = { Y = 227, H = 6 }, f = { Y = 223, H = 3 }, g = { Y = 216, H = 6 }, h = { Y = 209, H = 6 },
    i = { Y = 206, H = 2 }, j = { Y = 203, H = 2 }, k = { Y = 196, H = 6 }, l = { Y = 193, H = 2 },
    m = { Y = 184, H = 8 }, n = { Y = 177, H = 6 }, o = { Y = 170, H = 6 }, p = { Y = 163, H = 6 },
    q = { Y = 156, H = 6 }, r = { Y = 151, H = 4 }, s = { Y = 144, H = 6 }, t = { Y = 140, H = 3 },
    u = { Y = 133, H = 6 }, v = { Y = 124, H = 8 }, w = { Y = 115, H = 8 }, x = { Y = 109, H = 5 },
    y = { Y = 103, H = 5 }, z = { Y = 97,  H = 5 },
    [' '] = { Y = -10, H = 2 }, ['0'] = { Y = 90,  H = 6 }, ['1'] = { Y = 85,  H = 4 }, ['2'] = { Y = 78,  H = 6 },
    ['3'] = { Y = 71,  H = 6 }, ['4'] = { Y = 63,  H = 7 }, ['5'] = { Y = 56,  H = 6 }, ['6'] = { Y = 49,  H = 6 },
    ['7'] = { Y = 42,  H = 6 }, ['8'] = { Y = 35,  H = 6 }, ['9'] = { Y = 28,  H = 6 }, ['!'] = { Y = 25,  H = 2 },
    ['/'] = { Y = 19,  H = 5 }, [':'] = { Y = 16,  H = 2 }, ['+'] = { Y = 10,  H = 6 }, [','] = { Y = 5,   H = 3 },
    ['-'] = { Y = 0,   H = 4 },
};

local WORKING_LENGTH = 0;
function drawVerticalString(x, y, string, alignment)

    -- Start by calculating the total length of the string unless we are aligning left
    WORKING_LENGTH = 0;
    if alignment == nil or alignment ~= kTextAlignment.left then
        for i = 1,#string do
            WORKING_LENGTH += VERTICAL_CHARACTERS[string:sub(i, i)].H + 1
        end
    end

    -- Determine starting point
    local currentY;
    if alignment == kTextAlignment.right then
        currentY = y + WORKING_LENGTH;
    elseif alignment == kTextAlignment.center then
        currentY = y + math.floor(WORKING_LENGTH/2);
    else
        currentY = y;
    end

    -- start writing characters
    for i = 1,#string do
        local char <const> = string:sub(i, i);
        VERTICAL_TEXT_IMAGE:draw(
            x,
            currentY - VERTICAL_CHARACTERS[char].H,
            GFX.kImageUnflipped,
            0,
            VERTICAL_CHARACTERS[char].Y,
            VERTICAL_CHARACTER_WIDTH,
            VERTICAL_CHARACTERS[char].H
        );
        currentY -= VERTICAL_CHARACTERS[char].H + 1
    end
end

-- This helper function will take a number and give it commas
function formatNumber(number)
    number = ""..number
    local prettyNumber = ""
    local tillNextComma = 3 - (#number % 3)
    if tillNextComma == 3 then tillNextComma = 0 end -- add for first comma, but not if it's % 3
    for digit in string.gmatch(number, '(.)') do
        if tillNextComma == 3 then
            prettyNumber = prettyNumber..",";
            tillNextComma = 0
        end
            prettyNumber = prettyNumber..digit;
        tillNextComma += 1;
    end
    return prettyNumber;
end
