-- 宝石皇后玩法
local Easterpackage = {}
local this = Easterpackage

function Easterpackage:LoadRequire()
    require "Procedure/ProcedureEaster"
    if not ModelList.EasterModel then
        log.r("EasterModel init")
        ModelList.EasterModel = require "Model/EasterModel"
        ModelList:InitModule(ModelList.EasterModel)
    end
    
    if not ViewList.EasterBingoView then
        ViewList.EasterBingoView = require "View.Bingo.UIView.PartView.CardView.EasterBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/EasterAssetList"
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