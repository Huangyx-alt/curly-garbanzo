local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemComeSonState = Clazz(SGPitemBaseState,"SGPitemComeSonState")
local this = SGPitemComeSonState
function SGPitemComeSonState:OnEnter(fsm)
    fsm:GetOwner():OnComeSonState()
end


function SGPitemComeSonState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemIdleClick()--阅读事件
    end 
end
return this