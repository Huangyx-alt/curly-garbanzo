-- 宝石皇后玩法
local PirateShippackage = {}
local this = PirateShippackage

function PirateShippackage:LoadRequire()
    require "Procedure/ProcedurePirateShip"
    if not ModelList.PirateShipModel then
        log.r("PirateShipModel init")
        ModelList.PirateShipModel = require "Model/PirateShipModel"
        ModelList:InitModule(ModelList.PirateShipModel)
    end
    
    if not ViewList.PirateShipBingoView then
        ViewList.PirateShipBingoView = require "View.Bingo.UIView.PartView.CardView.PirateShipBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/PirateShipAssetList"
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