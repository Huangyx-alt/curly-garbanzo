local BaseGamePassBaseItemBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseItemBaseState"
local BaseGamePassBaseItemLockNopayState = Clazz(BaseGamePassBaseItemBaseState,"BaseGamePassBaseItemLockNopayState")

function BaseGamePassBaseItemLockNopayState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 3 == isFree then
        fsm:GetOwner():PlayBottomLockNopayAnima(param)
    end
end

function BaseGamePassBaseItemLockNopayState:OnLeave(fsm,previous,...)
end

function BaseGamePassBaseItemLockNopayState:Change2Mature(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BaseGamePassBaseItemMatureState",...)
    end
end
return BaseGamePassBaseItemLockNopayState