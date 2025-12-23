-- 宝石皇后玩法
local MoleMinerpackage = {}
local this = MoleMinerpackage

function MoleMinerpackage:LoadRequire()
    require "Procedure/ProcedureMoleMiner"
    if not ModelList.MoleMinerModel then
        log.r("MoleMinerModel init")
        ModelList.MoleMinerModel = require "Model/MoleMinerModel"
        ModelList:InitModule(ModelList.MoleMinerModel)
    end
    
    if not ViewList.MoleMinerBingoView then
        ViewList.MoleMinerBingoView = require "View.Bingo.UIView.PartView.CardView.MoleMinerBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/MoleMinerAssetList"
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