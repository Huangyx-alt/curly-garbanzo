--可以玩得状态
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local  SGPitemStopState = Clazz(SGPitemBaseState,"SGPitemStopState")
local this = SGPitemStopState

function SGPitemStopState:OnEnter(fsm)
    fsm:GetOwner():OnPlayState()
end

function SGPitemStopState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemStopClick()--阅读事件
    end 
end
return this