local GFX   <const> = playdate.graphics;

-- This is the font that is used on the loading screen, this is the only thing that should need to be loaded outside the loader
local LOADING_SCREEN_FONT <const> = GFX.font.new('gfx/titles');

-- Load all the assets we are going to need
local INTERMISSION_GRAPHICS = {
    IN_MASKS = {},
    OUT_MASKS = {},
}
function loadIntermissionGraphics()
    for frame = 01,38 do
        INTERMISSION_GRAPHICS.OUT_MASKS[frame] = GFX.image.new('gfx/intermission-masks/down-'..frame..'.png');
    end
    for frame = 01,39 do
        INTERMISSION_GRAPHICS.IN_MASKS[frame] = GFX.image.new('gfx/intermission-masks/up-'..frame..'.png');
    end
end

-- The intermission card
local INTERMISSION_CARD = GFX.image.new(400, 240, GFX.kColorBlack);


-- State managment, it starts in a pseudo up state, just the card displaying
local INTERMISSION_STATE = {
    holdingCard = true,
    showCard = true,
    isAnimating = false,
    animationFrame = 0,
    goingUp = false,
    goingDown = false,
}


-- upload the intermission card
function setLoadingMessage( message )
    INTERMISSION_CARD:clear(GFX.kColorBlack)
    GFX.pushContext(INTERMISSION_CARD)
    GFX.setImageDrawMode(GFX.kDrawModeNXOR)
    GFX.setFont(LOADING_SCREEN_FONT)
    GFX.drawTextAligned(message, 200, 100, kTextAlignment.center)
    GFX.popContext()
    playdate.display.flush()

    intermissionAnimations();
end


-- Mange the main masked animation
function goToIntermission()
    playdate.setCollectsGarbage(true);
    INTERMISSION_STATE.goingUp = true;
    INTERMISSION_STATE.animationFrame = 0;
    INTERMISSION_STATE.isAnimating = true;
    INTERMISSION_STATE.holdingCard = false;
end
function leaveIntermission()
    INTERMISSION_STATE.goingDown = true;
    INTERMISSION_STATE.animationFrame = 0;
    INTERMISSION_STATE.isAnimating = true;
    INTERMISSION_STATE.holdingCard = false;
    playdate.setCollectsGarbage(false);
end
function stopAnimation()
    INTERMISSION_STATE.goingUp = false;
    INTERMISSION_STATE.goinDown = false;
    INTERMISSION_STATE.animationFrame = 0;
    INTERMISSION_STATE.isAnimating = false;
end


-- Process the animations
function intermissionAnimations()
    if INTERMISSION_STATE.holdingCard then
        INTERMISSION_CARD:draw(0,0);
    elseif INTERMISSION_STATE.isAnimating then
        INTERMISSION_STATE.animationFrame += 1
        if INTERMISSION_STATE.goingUp then
            INTERMISSION_CARD:setMaskImage(INTERMISSION_GRAPHICS.IN_MASKS[INTERMISSION_STATE.animationFrame])
            INTERMISSION_CARD:draw(0,0);
            if INTERMISSION_STATE.animationFrame == #INTERMISSION_GRAPHICS.IN_MASKS then
                stopAnimation()
            end
        else
            INTERMISSION_CARD:setMaskImage(INTERMISSION_GRAPHICS.OUT_MASKS[INTERMISSION_STATE.animationFrame])
            INTERMISSION_CARD:draw(0,0);
            if INTERMISSION_STATE.animationFrame == #INTERMISSION_GRAPHICS.OUT_MASKS then
                INTERMISSION_STATE.showCard = false;
                stopAnimation()
            end
        end
    end
end


--[[

-- prep intermission sprite
local CURRENT_ANIMATION = 1; -- 1 for in 2 for out
local INTERMISSION_ANIMATION_TIME <const> = 750;
local INTERMISSION_SPRITE = GFX.sprite.new(GFX.image.new('gfx/intermission-flow.png'));
INTERMISSION_SPRITE:setZIndex( 9001 );
INTERMISSION_SPRITE:setCenter(0, 0);
INTERMISSION_SPRITE:moveTo( -600, -20 );
INTERMISSION_SPRITE:add();

-- for screen whiping
local animationXTimer;
local animationYTimer;

-- animating the flow in
function goToIntermission()
    animationXTimer = TIMER.new(INTERMISSION_ANIMATION_TIME, 240, -20, playdate.easingFunctions.outQuad);
    animationYTimer = TIMER.new(INTERMISSION_ANIMATION_TIME, -600, 0);
    IS_ANIMATING = true;
end
function comeFromIntermission()
    animationXTimer = TIMER.new(INTERMISSION_ANIMATION_TIME, -20, 240, playdate.easingFunctions.inQuad);
    animationYTimer = TIMER.new(INTERMISSION_ANIMATION_TIME, -600, 0);
    IS_ANIMATING = true;
end

function intermissionAnimation()
    if IS_ANIMATING then
        printTable(animationTimer)
        INTERMISSION_SPRITE:moveTo( animationYTimer.value, animationXTimer.value );

        if animationXTimer.active == false and animationYTimer.active == false  then
            IS_ANIMATING = false;
        end
    end
end

]]--
