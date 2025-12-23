-- 宝石皇后玩法
local NewLeetoleManpackage = {}
local this = NewLeetoleManpackage

function NewLeetoleManpackage:LoadRequire()
    require "Procedure/ProcedureNewLeetoleMan"
    if not ModelList.NewLeetoleManModel then
        log.r("NewLeetoleManModel init")
        ModelList.NewLeetoleManModel = require "Model/NewLeetoleManModel"
        ModelList:InitModule(ModelList.NewLeetoleManModel)
    end
    
    if not ViewList.NewLeetoleManBingoView then
        ViewList.NewLeetoleManBingoView = require "View.Bingo.UIView.PartView.CardView.NewLeetoleManBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/NewLeetoleManAssetList"
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