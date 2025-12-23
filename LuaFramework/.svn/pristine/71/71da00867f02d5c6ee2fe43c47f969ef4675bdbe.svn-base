local BaseGamePassBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseState"
local BaseGamePassBaseExitState = Clazz(BaseGamePassBaseState,"BaseGamePassBaseExitState")

function BaseGamePassBaseExitState:OnEnter(fsm)
    fsm:GetOwner():PlayBingoPassExit()
end

function BaseGamePassBaseExitState:OnLeave(fsm)
end
return  BaseGamePassBaseExitState