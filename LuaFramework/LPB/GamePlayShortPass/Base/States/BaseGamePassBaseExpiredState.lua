local BaseGamePassBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseState"
local BaseGamePassBaseExpiredState = Clazz(BaseGamePassBaseState,"BaseGamePassBaseExpiredState")

function BaseGamePassBaseExpiredState:OnEnter(fsm,previous,...)

end

function BaseGamePassBaseExpiredState:OnLeave(fsm)
end

function BaseGamePassBaseExpiredState:Complete(fsm)
    self:ClaimReward(fsm)
end

function BaseGamePassBaseExpiredState:GemUnlockLevel(fsm,passItem)
    self:ClaimReward(fsm)
end

function BaseGamePassBaseExpiredState:BaseGamePassBaseWatchAd(fsm,passItem)
    self:ClaimReward(fsm)
end

function BaseGamePassBaseExpiredState:Purchase(fsm)
    self:ClaimReward(fsm)
end

function BaseGamePassBaseExpiredState:PlayExit(fsm)
    self:ClaimReward(fsm)
end

function BaseGamePassBaseExpiredState:ClaimReward(fsm)
    UIUtil.show_common_popup(984,true,function()
        if fsm then
            self:ChangeState(fsm,"BaseGamePassBaseExitState")
        end
    end,function()

    end,nil,nil)
end

return BaseGamePassBaseExpiredState