function initializeSystemMenu()
    local menu <const> = playdate.getSystemMenu()

    menu:addMenuItem("restart", function()
        playfieldStart()
    end)

    menu:addMenuItem("finish round", function()
        finishRound()
    end)

    -- menu:addMenuItem("Start Flow", function()
    --     print('Lets get some flow before we start worrying about force starting it.')
    -- end)

    -- menu:addOptionsMenuItem("Music", {"Maybe", "in", "the", "future."}, "Maybe", function()
    --     print("Change Song")
    -- end)
end
