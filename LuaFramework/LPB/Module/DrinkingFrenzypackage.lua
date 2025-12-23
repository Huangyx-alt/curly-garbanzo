-- 啤酒玩法
local DrinkingFrenzypackage = {}
local this = DrinkingFrenzypackage

function DrinkingFrenzypackage:LoadRequire()
    log.log("DPS机台内容学习 啤酒机台 加载需要的文件" )
    require "Procedure/ProcedureDrinkingFrenzy"
    if not ModelList.DrinkingFrenzyModel then
        ModelList.DrinkingFrenzyModel = require "Model/DrinkingFrenzyModel"
        ModelList:InitModule(ModelList.DrinkingFrenzyModel)
    end
    if not ViewList.DrinkingFrenzyBingoView then
        ViewList.DrinkingFrenzyBingoView = require "View.Bingo.UIView.PartView.CardView.DrinkingFrenzyBingoView"
    end
    
    
    --- 资源列表添加到主AssetList
    local list = require "Module/DrinkingFrenzyAssetList"
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