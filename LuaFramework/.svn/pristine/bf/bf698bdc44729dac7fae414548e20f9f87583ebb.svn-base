---广告CD的状态
local MagnifyingAdBaseState = require "State/MagnifyingAdView/MagnifyingAdBaseState"
local MagnifyingAdWaitCdState = Clazz(MagnifyingAdBaseState,"MagnifyingAdWaitCdState")

function MagnifyingAdWaitCdState:OnEnter(fsm)
   fsm:GetOwner():OnWaitCdState()
end

function MagnifyingAdWaitCdState:OnBtnClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnWaitCdClick()
    end 
end

return MagnifyingAdWaitCdState
