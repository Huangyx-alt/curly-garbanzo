local DailyRewardInfoBaseState = require "State/DailyReward/DailyRewardInfoBaseState"
local DailyRewardInfoEnterState = Clazz(DailyRewardInfoBaseState,"DailyRewardInfoEnterState")


function DailyRewardInfoEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
    log.r("DailyRewardInfoEnterState")
end

function DailyRewardInfoEnterState:OnLeave(fsm)

end

function DailyRewardInfoEnterState:FinishEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"DailyRewardInfoOriginalState")
    end
end
return DailyRewardInfoEnterState