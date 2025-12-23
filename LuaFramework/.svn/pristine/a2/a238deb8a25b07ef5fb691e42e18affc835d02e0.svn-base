local LetemRollpackage = {}
local this = LetemRollpackage

function LetemRollpackage:LoadRequire()
    --require "Procedure/ProcedureLetemRoll"
    if not ModelList.LetemRollModel then
        log.r("LetemRollModel init")
        ModelList.LetemRollModel = require "Model/LetemRollModel"
        ModelList:InitModule(ModelList.LetemRollModel)
    end
    
    if not ViewList.LetemRollBingoView then
        ViewList.LetemRollBingoView = require "View.Bingo.UIView.PartView.CardView.LetemRollBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/LetemRollAssetList"
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