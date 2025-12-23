local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemOriginalState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemOriginalState")

function BaseGamePassBaseItemOriginalState:OnEnter(fsm)
end

function BaseGamePassBaseItemOriginalState:OnLeave(fsm)
end

function BaseGamePassBaseItemOriginalState:ResetState(fsm)
    --do nothing
end

function BaseGamePassBaseItemOriginalState:Change2Lock(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemLockState",...)
    end
end

function BaseGamePassBaseItemOriginalState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemMatureState",...)
    end
end

function BaseGamePassBaseItemOriginalState:Change2Achieve(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemAchieveState",...)
    end
end

function BaseGamePassBaseItemOriginalState:Change2LockNopay(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemLockNopayState",...)
    end
end

return BaseGamePassBaseItemOriginalState