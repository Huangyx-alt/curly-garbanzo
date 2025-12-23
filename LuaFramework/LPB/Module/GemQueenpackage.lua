-- 宝石皇后玩法
local GemQueenpackage = {}
local this = GemQueenpackage

function GemQueenpackage:LoadRequire()
    require "Procedure/ProcedureGemQueen"
    if not ModelList.GemQueenModel then
        log.r("GemQueenModel init")
        ModelList.GemQueenModel = require "Model/GemQueenModel"
        ModelList:InitModule(ModelList.GemQueenModel)
    end
    
    if not ViewList.GemQueenBingoView then
        ViewList.GemQueenBingoView = require "View.Bingo.UIView.PartView.CardView.GemQueenBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/GemQueenAssetList"
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