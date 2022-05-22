-- This file contains the definitiions of all the peices, and the logic used to look up
-- information about tiles based on thier index or get new random tiles, it does not manage
-- placing tiles or doing anything to them.

-- This lets me give the TILE_BAG an X/Y on the spritesheet and have it become an integer number
-- This should not be used for anything else, it's hard coded for this purpose.
function spriteAt(x, y)
    return ((y-1) * 29) + x;
end

local TILE_BAG <const> = {
    {
        name = "Horizontal";
        sprites = {
            empty = spriteAt(1,1); -- pretty obvious
            full = spriteAt(1,2);  -- also abvious
            flow = { -- Each direction in paths needs to have an entry here with the first fill state (1 row/col of pixels)
                E = spriteAt(2,2);
                W = spriteAt(2,1);
            }
        };
        fillFrames = 28; -- exclused the empty and full frames
        paths = { N = " ", S = " ", E = "E", W = "W" }; -- this is the direction you enter from and the direction you'll enter the next tile from
    },
    {
        name = "Vertical";
        sprites = {
            empty = spriteAt(1,3);
            full = spriteAt(1,4);
            flow = {
                N = spriteAt(2,3);
                S = spriteAt(2,4);
            }
        };
        fillFrames = 28;
        paths = { N = "N", S = "S", E = " ", W = " " };
    },
    {
        name = "CurveSE";
        sprites = {
            empty = spriteAt(1,9);
            full = spriteAt(1,10);
            flow = {
                S = spriteAt(2,9);
                E = spriteAt(2,10);
            }
        };
        fillFrames = 28;
        paths = { N = " ", S = "W", E = "N", W = " " };
    },
    {
        name = "CurveSW";
        sprites = {
            empty = spriteAt(1,11);
            full = spriteAt(1,12);
            flow = {
                W = spriteAt(2,11);
                S = spriteAt(2,12);
            }
        };
        fillFrames = 28;
        paths = { N = " ", S = "E", E = " ", W = "N" };
    },
    {
        name = "CurveNE";
        sprites = {
            empty = spriteAt(1,7);
            full = spriteAt(1,8);
            flow = {
                E = spriteAt(2,7);
                N = spriteAt(2,8);
            }
        };
        fillFrames = 28;
        paths = { N = "W", S = " ", E = "S", W = " " };
    },
    {
        name = "CurveNW";
        sprites = {
            empty = spriteAt(1,5);
            full = spriteAt(1,6);
            flow = {
                N = spriteAt(2,6);
                W = spriteAt(2,5);
            }
        };
        fillFrames = 28;
        paths = { N = "E", S = " ", E = " ", W = "S" };
    },
    {
        name = "Cross";
        sprites = {
            empty = spriteAt(1,13);
            hFull = spriteAt(1,14);
            vFull = spriteAt(1,16);
            full = spriteAt(1,18);
            flow = {
                E = spriteAt(2,14);
                W = spriteAt(2,13);
                N = spriteAt(2,15);
                S = spriteAt(2,16);
                vFullE = spriteAt(2,18);
                vFullW = spriteAt(2,17);
                hFullN = spriteAt(2,19);
                hFullS = spriteAt(2,20);
            }
        };
        fillFrames = 28;
        paths = { N = "N", S = "S", E = "E", W = "W" };
    },
    -- Tiles below this are not intended for the player to use
    {
        name = "Start E";
        sprites = {
            empty = spriteAt(1,21);
            full = spriteAt(25,21);
            flow =  {
                O = spriteAt(2,21);
            }
        };
        fillFrames = 23;
        paths = { N = " ", S = " ", E = " ", W = " ", O = "W" };
        locked = true;
        empty = false;
    },
    {
        name = "Start S";
        sprites = {
            empty = spriteAt(26,21);
            full = spriteAt(21,22);
            flow =  {
                O = spriteAt(27,21);
            }
        };
        fillFrames = 23;
        paths = { N = " ", S = " ", E = " ", W = " ", O = "N" };
        locked = true;
        empty = false;
    },
    {
        name = "Start W";
        sprites = {
            empty = spriteAt(22,22);
            full = spriteAt(17,23);
            flow =  {
                O = spriteAt(23,22);
            }
        };
        fillFrames = 23;
        paths = { N = " ", S = " ", E = " ", W = " ", O = "E" };
        locked = true;
        empty = false;
    },
    {
        name = "Start N";
        sprites = {
            empty = spriteAt(18,23);
            full = spriteAt(13,24);
            flow =  {
                O = spriteAt(19,23);
            }
        };
        fillFrames = 23;
            paths = { N = " ", S = " ", E = " ", W = " ", O = "S" };
        output = 'N';
        locked = true;
        empty = false;
    },
}
TILE_BAG[0] = {
    name = "Empty";
    sprites = {
        empty = spriteAt(1,15);
    };
    paths = { N = " ", S = " ", E = " ", W = " " };
    locked = false;
    empty = true;
}
for n in pairs(TILE_BAG) do TILE_BAG[n].index = n end

-- helpers for quickly referencing tiles
START_TILES = {8,9,10,11};

-- Get all the details about a tile
function getTileDetails(n)
    if n < 0 or TILE_BAG[n] == nil then
        return {
            name = "Error!";
            sprites = {
                empty = spriteAt(1,17);
            };
            paths = { N = " ", S = " ", E = " ", W = " " };
            index = -1;
            locked = true;
        };
    else
        local tile = TILE_BAG[n];
        tile.index = n;
        if tile.index == nil then tile.index = n end
        if tile.locked == nil then tile.locked = false end -- this tile can not be changed; filled, placed by the game
        if tile.filled == nil then tile.filled = false end -- has the tile been filled, mostly used to track state regarding crosses
        if tile.empty  == nil then tile.empty = false end -- simple check for if there is somehting in there, manually set for nothing tile
        return tile;
    end
end

-- Gets a random tile and returns the details
function getRandomTile()
    local index = math.random(1,7); -- will need to be weighted somehow
    local tile = TILE_BAG[index];
    return tile;
end
