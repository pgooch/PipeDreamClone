function initializeSystemMenu()
    local menu <const> = playdate.getSystemMenu()

    menu:addMenuItem("Reset Field", function()
        playfieldStart()
    end)

    menu:addMenuItem("Start Flow", function()
        print('Lets get some flow before we start worrying about force starting it.')
    end)

    menu:addOptionsMenuItem("Music", {"Maybe", "in", "the", "future."}, "Maybe", function()
        print("Change Song")
    end)
end
