local DailyRewardInfoBaseState = require "State/DailyReward/DailyRewardInfoBaseState"
local DailyRewardRewardState = Clazz(DailyRewardInfoBaseState,"DailyRewardRewardState")

function DailyRewardRewardState:OnEnter(fsm,previous, ...)
    log.r("DailyRewardRewardState")
    local params1, params2 = select(1,...)
    self:StopTimer()
    self._timer = Invoke(function()
        --UIUtil.show_common_popup(8012,true)
        --self:CliamRewardRespone(fsm,true)
        self:ChangeToOriginal(fsm)
    end,5)
    if params1 == 1 then
        fsm:GetOwner():ClaimAwards()
    else

    end
end

function DailyRewardRewardState:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function DailyRewardRewardState:OnLeave(fsm)
    self:StopTimer()
end

function DailyRewardRewardState:CliamRewardRespone(fsm,isExit)
    if fsm then
        if isExit then
            self:ChangeState(fsm,"DailyRewardInfoExitState",2,1)
        end
    end
end

function DailyRewardRewardState:ChangeToOriginal(fsm)
    if fsm then
        self:ChangeState(fsm,"DailyRewardInfoOriginalState")
    end
end

return DailyRewardRewardState