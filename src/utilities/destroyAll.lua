function destroyAll()
    colliderTableDestroy(walls)
    colliderTableDestroy(transitions)

    removeTable(loots)
    removeTable(effects)
    removeTable(npcs)
    removeTable(chests)
    removeTable(triggers)

    -- Remove enemies
    for i=#enemies,1,-1 do
        if enemies[i].physics ~= nil then
            enemies[i].physics:destroy()
        end
        table.remove(enemies, i)
    end
end

-- Used for tables of colliders
function colliderTableDestroy(tableList)
    local i = #tableList
    while i > 0 do
        if tableList[i] ~= nil then
            tableList[i]:destroy()
        end
        table.remove(tableList, i)
        i = i - 1
    end
end

-- Used for tables of standard non-collider tables
function removeTable(tableList)
    local i = #tableList
    while i > 0 do
        table.remove(tableList, i)
        i = i - 1
    end
end
