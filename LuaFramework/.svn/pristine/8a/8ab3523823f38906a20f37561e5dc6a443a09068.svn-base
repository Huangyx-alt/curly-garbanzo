--锁住得状态
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemLockState = Clazz(SGPitemBaseState,"SGPitemLockState")
local this  = SGPitemLockState

function SGPitemLockState:OnEnter(fsm)
    fsm:GetOwner():OnLockState()
end


function SGPitemLockState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemloadClick()--阅读事件
    end 
end

-- function SGPitemLockState:OnLeave(fsm)

-- end

-- function SGPitemLockState:EnterFinish(fsm)
    
-- end
return this