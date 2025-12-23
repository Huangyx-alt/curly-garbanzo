local DailyRewardInfoBaseState = require "State/DailyReward/DailyRewardInfoBaseState"
local DailyRewardInfoExitState = Clazz(DailyRewardInfoBaseState,"DailyRewardInfoExitState")

function DailyRewardInfoExitState:OnEnter(fsm,previous,...)
    log.r("DailyRewardInfoExitState")
    local params1, params2 = select(1,...)
    if params1 == 1 then
        fsm:GetOwner():GobackClick()
    elseif params1 == 2 then
        fsm:GetOwner():OnClaimReward(params2)
    end
end

function DailyRewardInfoExitState:OnLeave(fsm)

end

return DailyRewardInfoExitState