-- 宝石皇后玩法
local ScratchWinnerpackage = {}
local this = ScratchWinnerpackage

function ScratchWinnerpackage:LoadRequire()
    require "Procedure/ProcedureScratchWinner"
    if not ModelList.ScratchWinnerModel then
        log.r("ScratchWinnerModel init")
        ModelList.ScratchWinnerModel = require "Model/ScratchWinnerModel"
        ModelList:InitModule(ModelList.ScratchWinnerModel)
    end
    
    if not ViewList.ScratchWinnerBingoView then
        ViewList.ScratchWinnerBingoView = require "View.Bingo.UIView.PartView.CardView.ScratchWinnerBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/ScratchWinnerAssetList"
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