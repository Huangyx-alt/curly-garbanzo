-- XXXX玩法
local GotYoupackage = {}
local this = GotYoupackage

function GotYoupackage:LoadRequire()
    --require "Procedure/ProcedureGotYou"
    if not ModelList.GotYouModel then
        log.r("GotYouModel init")
        ModelList.GotYouModel = require "Model/GotYouModel"
        ModelList:InitModule(ModelList.GotYouModel)
    end
    
    if not ViewList.GotYouBingoView then
        ViewList.GotYouBingoView = require "View.Bingo.UIView.PartView.CardView.GotYouBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/GotYouAssetList"
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