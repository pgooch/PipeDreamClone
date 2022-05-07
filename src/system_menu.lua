function initializeSystemMenu()
    local menu <const> = playdate.getSystemMenu()

    menu:addMenuItem("Reset Field", function()
        playfieldStart()
    end)

    menu:addMenuItem("Start Timer", function()
        startTimer()
    end)

    menu:addOptionsMenuItem("Music", {"Maybe", "in", "the", "future."}, "Maybe", function()
        print("Change Song")
    end)
end
