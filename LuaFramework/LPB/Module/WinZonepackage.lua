-- WinZone玩法
local WinZonepackage = {}
local this = WinZonepackage

function WinZonepackage:LoadRequire()
    require "Procedure/ProcedureWinZone"
    if not ModelList.WinZoneGameModel then
        log.r("WinZoneGameModel init")
        ModelList.WinZoneGameModel = require "Model/WinZoneGameModel"
        ModelList:InitModule(ModelList.WinZoneGameModel)
    end

    if not ViewList.WinZoneGameBingoView then
        ViewList.WinZoneGameBingoView = require "View.Bingo.UIView.PartView.CardView.WinZoneGameBingoView"
    end
    
    --- 资源列表添加到主AssetList
    local list = require "Module/WinZoneAssetList"
    if list then
        for k,v in pairs(list) do
            if not AssetList[k] then
                AssetList[k] = v
            end
        end
    end
end

return this
