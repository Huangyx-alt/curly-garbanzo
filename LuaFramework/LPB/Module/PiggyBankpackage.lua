-- 宝石皇后玩法
local PiggyBankpackage = {}
local this = PiggyBankpackage

function PiggyBankpackage:LoadRequire()
    -- require "Procedure/ProcedurePiggyBank"
    if not ModelList.PiggyBankModel then
        log.r("PiggyBankModel init")
        ModelList.PiggyBankModel = require "Model/PiggyBankModel"
        ModelList:InitModule(ModelList.PiggyBankModel)
    end
    
    if not ViewList.PiggyBankBingoView then
        ViewList.PiggyBankBingoView = require "View.Bingo.UIView.PartView.CardView.PiggyBankBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/PiggyBankAssetList"
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