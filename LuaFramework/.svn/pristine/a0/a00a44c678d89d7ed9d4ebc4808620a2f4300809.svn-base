-- 宝石皇后玩法
local HorseRacingpackage = {}
local this = HorseRacingpackage

function HorseRacingpackage:LoadRequire()
    require "Procedure/ProcedureHorseRacing"
    if not ModelList.HorseRacingModel then
        log.r("HorseRacingModel init")
        ModelList.HorseRacingModel = require "Model/HorseRacingModel"
        ModelList:InitModule(ModelList.HorseRacingModel)
    end
    
    if not ViewList.HorseRacingBingoView then
        ViewList.HorseRacingBingoView = require "View.Bingo.UIView.PartView.CardView.HorseRacingBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/HorseRacingAssetList"
    if list then
        for k,v in pairs(list) do
            if not AssetList[k] then
                AssetList[k] = v
            end
            
            ----图集要立即加载
            --if fun.ends(k, "Atlas") then
            --    Cache.Load_Atlas_ByBundleName(v, k, function()
            --
            --    end)
            --end
        end
    end
end

return this