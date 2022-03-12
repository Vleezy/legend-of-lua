function createNewSave()
    -- This represents the save data
    data = {}
    data.saveCount = 0 -- how many times has the game saved
    data.progress = 0 -- milestone tracker
    data.playerX = 0 -- player's X position
    data.playerY = 0 -- player's Y position
    data.maxHealth = 4 -- maximum number of hearts

    -- equipped (secondary) item
    -- 0 = nothing
    -- 1 = boomerang
    -- 2 = bomb
    -- 3 = bow
    data.item = 1
end
