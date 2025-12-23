--正在下载状态
local SGPitemBaseState = require "State/SpecialGameplay/SGPitemBaseState"
local SGPitemloadState = Clazz(SGPitemBaseState,"SGPitemloadState")
local this = SGPitemloadState
function SGPitemloadState:OnEnter(fsm)
    fsm:GetOwner():OnLoadState()
end


function SGPitemloadState:OnBtnItemClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnItemloadClick()--阅读事件
    end 
end
return this