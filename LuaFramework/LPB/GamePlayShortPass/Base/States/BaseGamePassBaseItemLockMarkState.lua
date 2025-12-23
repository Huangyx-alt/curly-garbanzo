local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemLockMarkState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemLockMarkState")

function BaseGamePassBaseItemLockMarkState:OnEnter(fsm,previous,...)
    fsm:GetOwner():PlayFreeLockAnima(false)
    fsm:GetOwner():PlayRestAnima(false)
end

function BaseGamePassBaseItemLockMarkState:OnLeave(fsm,previous,...)
end

function BaseGamePassBaseItemLockMarkState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemMatureState",...)
    end
end
return BaseGamePassBaseItemLockMarkState