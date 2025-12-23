-- 宝石皇后玩法
local Solitairepackage = {}
local this = Solitairepackage

function Solitairepackage:LoadRequire()
    -- require "Procedure/ProcedureSolitaire"
    if not ModelList.SolitaireModel then
        log.r("SolitaireModel init")
        ModelList.SolitaireModel = require "Model/SolitaireModel"
        ModelList:InitModule(ModelList.SolitaireModel)
    end
    
    if not ViewList.SolitaireBingoView then
        ViewList.SolitaireBingoView = require "View.Bingo.UIView.PartView.CardView.SolitaireBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/SolitaireAssetList"
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