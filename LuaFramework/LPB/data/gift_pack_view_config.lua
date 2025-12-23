--auto generate by unity editor
local gift_pack_view_config = {
[1] = {1,"cEntWelcomePack","viewName","GiftPackWelcomePackView","0","0",0,"0"},
[2] = {2,"cEntMagicBoth","viewName","GiftPackMagicBoothView","0","0",0,"0"},
[3] = {3,"cEntHarborLimite","viewName","GiftPackHarborLimitedView","0","0",0,"0"},
[4] = {4,"cEntPartyEndless","viewName","GiftPackLetPartyUnlimitView","0","0",0,"0"},
[5] = {5,"cEntHalloweenBoth","viewName","GiftPackHalloweenBoothView","0","0",0,"0"},
[6] = {6,"BsCookieShopTb01","viewName","GiftPackCompetitionCookieView","0","0",0,"0"},
}

local keys = {id = 1,icon = 2,viewtype = 3,viewname = 4,viewpath = 5,downloadmodulename = 6,city_play = 7,atlas_name = 8}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(gift_pack_view_config) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return gift_pack_view_config
