local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassStiffState = Clazz(BingoPassBaseState,"BingoPassStiffState")

function BingoPassStiffState:OnEnter(fsm,previous,...)
    fsm:GetOwner():DisableDragAbility()
    local param,passItem = select(1,...)
    if 1 == param then
        passItem:DoGemUnlockLevel()
    elseif 2 == param then
        passItem:WatchAdUnlockLevel()
    elseif 3 == param then
        passItem:DoClaimReward()    
    elseif 4 == param then
        fsm:GetOwner():OnReqPassAllReward()
    end
    self._timer = Invoke(function()
        self:Complete(fsm)
    end,3)
end

function BingoPassStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    fsm:GetOwner():EnableDragAbility()
end

function BingoPassStiffState:Complete(fsm)
    if fsm then
        self:ChangeState(fsm,"BingoPassOriginalState")
    end
end

return  BingoPassStiffState