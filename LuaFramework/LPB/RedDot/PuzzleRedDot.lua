
local BaseRedDot = require "RedDot/BaseRedDot"
local PuzzleRedDot = Clazz(BaseRedDot,"PuzzleRedDot")
local this = PuzzleRedDot

function PuzzleRedDot:Check(node,param)
    if node.param == RedDotParam.auto_city_cuisines then
        local isActive = ((ModelList.PuzzleModel:GetPuzzlePiecesNum(101,PLAY_TYPE.PLAY_TYPE_AUTO_TICKET) > 0) or
        self:GetInfoByReddotCount(node,"puzzle")) and ModelList.PlayerInfoModel:IsAutoLobbyOpen()

        this:SetSingleNodeActive(node,isActive)
    else
        this:SetSingleNodeActive(node,ModelList.PuzzleModel:GetPuzzlePiecesNum() > 0)
    end
end

function PuzzleRedDot:Refresh(nodeList,param)
    for key, value in pairs(nodeList) do
        this:Check(value,param)
    end
end

return this