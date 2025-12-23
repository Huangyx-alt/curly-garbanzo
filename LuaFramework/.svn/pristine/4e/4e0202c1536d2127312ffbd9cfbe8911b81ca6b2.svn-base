local BaseGamePassBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseState"
local BaseGamePassBaseStiffState = Clazz(BaseGamePassBaseState,"BaseGamePassBaseStiffState")

function BaseGamePassBaseStiffState:OnEnter(fsm,previous,...)
    fsm:GetOwner():DisableDragAbility()
    local param,passItem = select(1,...)
    if 1 == param then
        passItem:DoGemUnlockLevel()
    elseif 2 == param then
        passItem:WatchAdUnlockLevel()
    elseif 3 == param then
        passItem:DoClaimReward()    
    end
    self._timer = Invoke(function()
        self:Complete(fsm)
    end,3)
end

function BaseGamePassBaseStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    fsm:GetOwner():EnableDragAbility()
end

function BaseGamePassBaseStiffState:Complete(fsm)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseOriginalState")
    end
end

return  BaseGamePassBaseStiffState