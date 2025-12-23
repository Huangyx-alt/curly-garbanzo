--正常，没有下载状态
--已读不用领
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemidleState = Clazz(SGPitemBaseState,"SGPitemidleState")
local this = SGPitemidleState
function SGPitemidleState:OnEnter(fsm)
    fsm:GetOwner():OnIdleState()
end

function SGPitemidleState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemIdleClick()--阅读事件
    end 
end
return this