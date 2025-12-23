-- 野牛踩踏玩法
local Bisonpackage = {}
local this = Bisonpackage

function Bisonpackage:LoadRequire()
    require "Procedure/ProcedureBison"
    if not ModelList.BisonModel then
        log.r("BisonModel init")
        ModelList.BisonModel = require "Model/BisonModel"
        ModelList:InitModule(ModelList.BisonModel)
    end
    
    if not ViewList.BisonBingoView then
        ViewList.BisonBingoView = require "View.Bingo.UIView.PartView.CardView.BisonBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/BisonAssetList"
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