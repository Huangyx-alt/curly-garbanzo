local DailyRewardInfoBaseState = require "State/DailyReward/DailyRewardInfoBaseState"
local DailyRewardInfoOriginalState = Clazz(DailyRewardInfoBaseState,"DailyRewardInfoOriginalState")

function DailyRewardInfoOriginalState:OnEnter(fsm)
    log.r("DailyRewardInfoOriginalState")
end

function DailyRewardInfoOriginalState:OnLeave(fsm)
end

function DailyRewardInfoOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"DailyRewardInfoEnterState")
    end
end

function DailyRewardInfoOriginalState:GobackClick(fsm)
    if fsm then
        self:ChangeState(fsm,"DailyRewardInfoExitState",1)
    end
end

function DailyRewardInfoOriginalState:ClaimRewar(fsm,params)
    if fsm then
        self:ChangeState(fsm,"DailyRewardRewardState",params)
    end
end

function DailyRewardInfoOriginalState:WatchVideo(fsm,params)
    if fsm then
        self:ChangeState(fsm,"DailyRewardWatchVideoState",params)
    end
end
return DailyRewardInfoOriginalState