-- 宝石皇后玩法
local NewChristmaspackage = {}
local this = NewChristmaspackage

function NewChristmaspackage:LoadRequire()
    require "Procedure/ProcedureNewChristmas"
    if not ModelList.NewChristmasModel then
        log.r("NewChristmasModel init")
        ModelList.NewChristmasModel = require "Model/NewChristmasModel"
        ModelList:InitModule(ModelList.NewChristmasModel)
    end
    
    if not ViewList.NewChristmasBingoView then
        ViewList.NewChristmasBingoView = require "View.Bingo.UIView.PartView.CardView.NewChristmasBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/NewChristmasAssetList"
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