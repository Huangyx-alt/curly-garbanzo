-- 宝石皇后玩法
local ChristmasSynthesispackage = {}
local this = ChristmasSynthesispackage

function ChristmasSynthesispackage:LoadRequire()
    require "Procedure/ProcedureChristmasSynthesis"
    if not ModelList.ChristmasSynthesisModel then
        log.r("ChristmasSynthesisModel init")
        ModelList.ChristmasSynthesisModel = require "Model/ChristmasSynthesisModel"
        ModelList:InitModule(ModelList.ChristmasSynthesisModel)
    end
    
    if not ViewList.ChristmasSynthesisBingoView then
        ViewList.ChristmasSynthesisBingoView = require "View.Bingo.UIView.PartView.CardView.ChristmasSynthesisBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/ChristmasSynthesisAssetList"
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
