local Volcanopackage = {}
local this = Volcanopackage

function Volcanopackage:LoadRequire()
    require "Procedure/ProcedureVolcano"
    if not ModelList.VolcanoModel then
        log.r("VolcanoModel init")
        ModelList.VolcanoModel = require "Model/VolcanoModel"
        ModelList:InitModule(ModelList.VolcanoModel)
    end
    
    if not ViewList.VolcanoBingoView then
        ViewList.VolcanoBingoView = require "View.Bingo.UIView.PartView.CardView.VolcanoBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/VolcanoAssetList"
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