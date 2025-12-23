
local BaseRedDot = require "RedDot/BaseRedDot"
local BingoPassRedDot = Clazz(BaseRedDot,"BingoPassRedDot")
local this = BingoPassRedDot

function BingoPassRedDot:Check(node,param)
    this:SetSingleNodeActive(node,ModelList.BingopassModel:CheckRedDot())
end

function BingoPassRedDot:Refresh(nodeList,param)
    for key, value in pairs(nodeList) do
        this:Check(value,param)
    end
end

return this