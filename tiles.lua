-- This file contains the definitiions of all the peices, and the logic used to look up
-- information about tiles based on thier index or get new random tiles, it does not manage
-- placing tiles or doing anything to them.

local TILE_BAG <const> = {
    {
        name = "Horizontal";
        sprites = {
            empty = 2;
        };
        paths = { N = " ", S = " ", E = "W", W = "E" };
    },
    {
        name = "Vertical";
        sprites = {
            empty = 3;
        };
        paths = { N = "S", S = "N", E = " ", W = " " };
    },
    {
        name = "CurveSE";
        sprites = {
            empty = 4;
        };
        paths = { N = " ", S = "E", E = "S", W = " " };
    },
    {
        name = "CurveSW";
        sprites = {
            empty = 5;
        };
        paths = { N = " ", S = "W", E = " ", W = "S" };
    },
    {
        name = "CurveNE";
        sprites = {
            empty = 6;
        };
        paths = { N = "E", S = " ", E = "N", W = " " };
    },
    {
        name = "CurveNW";
        sprites = {
            empty = 7;
        };
        paths = { N = "W", S = " ", E = " ", W = "N" };
    },
    {
        name = "Cross";
        sprites = {
            empty = 12;
        };
        paths = { N = "S", S = "N", E = "W", W = "E" };
    },
    -- Tiles below this are not intended for the player to use
    {
        name = "Start E";
        sprites = {
            empty = 16;
        };
        paths = { N = " ", S = " ", E = " ", W = " " };
        output = 'E';
        locked = true;
        empty = false;
    },
    {
        name = "Start S";
        sprites = {
            empty = 17;
        };
        paths = { N = " ", S = " ", E = " ", W = " " };
        output = 'S';
        locked = true;
        empty = false;
    },
    {
        name = "Start W";
        sprites = {
            empty = 18;
        };
        paths = { N = " ", S = " ", E = " ", W = " " };
        output = 'W';
        locked = true;
        empty = false;
    },
    {
        name = "Start N";
        sprites = {
            empty = 19;
        };
        paths = { N = " ", S = " ", E = " ", W = " " };
        output = 'N';
        locked = true;
        empty = false;
    },
}
TILE_BAG[0] = {
    name = "Empty";
    sprites = {
        empty = 1;
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
                empty = 24;
            };
            paths = { N = " ", S = " ", E = " ", W = " " };
            index = -1;
            locked = true;
        };
    else
        local tile = TILE_BAG[n];
        tile.index = n;
        if tile.index == nil then tile.index = n end
        if tile.locked == nil then tile.locked = false end
        if tile.empty == nil then tile.empty = false end
        return tile;
    end
end

-- Gets a random tile and returns the details
function getRandomTile()
    local index = math.random(1,7); -- will need to be weighted somehow
    local tile = TILE_BAG[index];
    return tile;
end
