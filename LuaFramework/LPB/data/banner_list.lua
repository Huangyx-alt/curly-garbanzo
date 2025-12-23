--auto generate by unity editor
local banner_list = {
[1] = {1,2,1,0,"HallCityTournamentLockBannerItem","TournamentTrueGoldLock","TournamentTrueGoldBannerAtlas",},
[2] = {2,3,2,0,"TournamentTrueGoldUnlock","TournamentTrueGoldUnlock","TournamentTrueGoldBannerAtlas",},
[4] = {4,1,4,36,"HallCityRecommendGameBannerItem","RecommendGameBannerItemView","RecommendGameBannerAtlas",},
[5] = {5,5,5,0,"DiamondPromotioBannerItemView","DiamondPromotioBannerItemView","0",},
[6] = {6,6,6,0,"BravoGuideHelpBannerItemView","BravoGuideHelpBannerItemView","0",},
[8] = {8,8,8,0,"HallofFameBannerItemView","HallofFameBannerItemView","0",},
[9] = {9,9,9,0,"HallofFameGoldBannerItemView","HallofFameGoldBannerItemView","0",},
[10] = {10,10,10,0,"FullGameplayBannerView","FullGameplayBannerView","FullGameplayAtlas",}
}

local keys = {id = 1,priority = 2,banner_type = 3,city_play = 4,viewname = 5,prefabname = 6,atlas_name = 7,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(banner_list) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return banner_list
