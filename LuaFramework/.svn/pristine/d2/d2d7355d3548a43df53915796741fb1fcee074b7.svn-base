local DailyRewardInfoBaseState = require "State/DailyReward/DailyRewardInfoBaseState"
local DailyRewardWatchVideoState = Clazz(DailyRewardInfoBaseState,"DailyRewardWatchVideoState")

function DailyRewardWatchVideoState:OnEnter(fsm,previous,...)
    local params = select(1,...)
    if params == 1 then
        fsm:GetOwner():WatchVideo()
    else
        fsm:GetOwner():ClaimMoreRwards()
    end
    self.fsm = fsm
    Event.AddListener(Notes.RECEIVE_MAX_REWARD_ADMISS,self.AdMiss,self)
end

function DailyRewardWatchVideoState:AdMiss()
    if self.fsm then
        self:ChangeState(self.fsm,"DailyRewardInfoOriginalState")
    end
    Event.RemoveListener(Notes.RECEIVE_MAX_REWARD_ADMISS,self.AdMiss)
end

function DailyRewardWatchVideoState:OnLeave(fsm)

end

function DailyRewardWatchVideoState:CliamRewardRespone(fsm,isExit)
    if fsm then
        if isExit then
            self:ChangeState(fsm,"DailyRewardInfoExitState",2,2)
        end
    end
end
return DailyRewardWatchVideoState