-- 宝石皇后玩法
local GoldenTrainpackage = {}
local this = GoldenTrainpackage

function GoldenTrainpackage:LoadRequire()
    require "Procedure/ProcedureGoldenTrain"
    if not ModelList.GoldenTrainModel then
        log.r("GoldenTrainModel init")
        ModelList.GoldenTrainModel = require "Model/GoldenTrainModel"
        ModelList:InitModule(ModelList.GoldenTrainModel)
    end
    
    if not ViewList.GoldenTrainBingoView then
        ViewList.GoldenTrainBingoView = require "View.Bingo.UIView.PartView.CardView.GoldenTrainBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/GoldenTrainAssetList"
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