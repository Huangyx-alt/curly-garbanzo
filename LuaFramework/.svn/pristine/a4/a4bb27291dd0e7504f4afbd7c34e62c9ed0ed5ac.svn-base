-- 宝石皇后玩法
local Candypackage = {}
local this = Candypackage

function Candypackage:LoadRequire()
    require "Procedure/ProcedureCandy"
    if not ModelList.CandyModel then
        log.r("CandyModel init")
        ModelList.CandyModel = require "Model/CandyModel"
        ModelList:InitModule(ModelList.CandyModel)
    end
    
    if not ViewList.CandyBingoView then
        ViewList.CandyBingoView = require "View.Bingo.UIView.PartView.CardView.CandyBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/CandyAssetList"
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