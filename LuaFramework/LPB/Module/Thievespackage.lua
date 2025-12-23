-- 绿头人的加载


local Thievespackage = {}
local this = Thievespackage

function Thievespackage:LoadRequire()
    require "Procedure/ProcedureThieves"
    if not ModelList.ThievesGameModel then
        --log.r("load ThievesGameModel")
        ModelList.ThievesGameModel = require "Model/ThievesGameModel"
        ModelList:InitModule(ModelList.ThievesGameModel)
    end
    if not ViewList.ThievesBingoView then
        ViewList.ThievesBingoView = require "View.Bingo.UIView.PartView.CardView.ThievesBingoView"
    end

    --- 资源列表添加到主AssetList
    local list = require "Module/ThievesAssetList"
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