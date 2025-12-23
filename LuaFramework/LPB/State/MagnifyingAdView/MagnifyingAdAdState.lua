---可观看广告的状态
local MagnifyingAdBaseState = require "State/MagnifyingAdView/MagnifyingAdBaseState"
local MagnifyingAdAdState = Clazz(MagnifyingAdBaseState,"MagnifyingAdAdState")

function MagnifyingAdAdState:OnEnter(fsm)
    fsm:GetOwner():OnAdState()
end

function MagnifyingAdAdState:OnBtnClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnAdClick()--阅读事件
    end 
end

return MagnifyingAdAdState
