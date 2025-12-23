--可以玩得状态
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemplayState = Clazz(SGPitemBaseState,"SGPitemplayState")
local this  = SGPitemplayState

function SGPitemplayState:OnEnter(fsm)
    fsm:GetOwner():OnPlayState()
end

function SGPitemplayState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemplayClick()--阅读事件
    end 
end

-- function SGPitemplayState:OnLeave(fsm)

-- end

-- function SGPitemplayState:EnterFinish(fsm)
   
-- end
return this