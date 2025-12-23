-- 宝石皇后玩法
local DragonFortunepackage = {}
local this = DragonFortunepackage

function DragonFortunepackage:LoadRequire()
    require "Procedure/ProcedureDragonFortune"
    if not ModelList.DragonFortuneModel then
        log.r("DragonFortuneModel init")
        ModelList.DragonFortuneModel = require "Model/DragonFortuneModel"
        ModelList:InitModule(ModelList.DragonFortuneModel)
    end
    
    if not ViewList.DragonFortuneBingoView then
        ViewList.DragonFortuneBingoView = require "View.Bingo.UIView.PartView.CardView.DragonFortuneBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/DragonFortuneAssetList"
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