-- 宝石皇后玩法
local GoldenPigpackage = {}
local this = GoldenPigpackage

function GoldenPigpackage:LoadRequire()
    require "Procedure/ProcedureGoldenPig"
    if not ModelList.GoldenPigModel then
        log.r("GoldenPigModel init")
        ModelList.GoldenPigModel = require "Model/GoldenPigModel"
        ModelList:InitModule(ModelList.GoldenPigModel)
    end
    
    if not ViewList.GoldenPigBingoView then
        ViewList.GoldenPigBingoView = require "View.Bingo.UIView.PartView.CardView.GoldenPigBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/GoldenPigAssetList"
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