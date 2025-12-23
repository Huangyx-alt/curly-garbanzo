-- 宝石皇后玩法
local Monopolypackage = {}
local this = Monopolypackage

function Monopolypackage:LoadRequire()
    -- require "Procedure/ProcedureMonopoly"
    if not ModelList.MonopolyModel then
        log.r("MonopolyModel init")
        ModelList.MonopolyModel = require "Model/MonopolyModel"
        ModelList:InitModule(ModelList.MonopolyModel)
    end
    
    if not ViewList.MonopolyBingoView then
        ViewList.MonopolyBingoView = require "View.Bingo.UIView.PartView.CardView.MonopolyBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/MonopolyAssetList"
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