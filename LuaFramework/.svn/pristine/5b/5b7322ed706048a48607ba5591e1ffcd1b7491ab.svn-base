local RegularlyAwardInfoBaseState = require("State/RegularlyAwardInfoView/RegularlyAwardInfoBaseState")
local RegularlyClaimRewardState = Clazz(RegularlyAwardInfoBaseState,"RegularlyClaimRewardState")

function RegularlyClaimRewardState:OnEnter(fsm,previous, ...)
    local params1, params2 = select(1,...)
    self:StopTimer()
    self._timer = Invoke(function()
        --UIUtil.show_common_popup(8012,true)
        self:CliamRewardRespone(fsm,true)
    end,5)
    if params1 == 1 then
        fsm:GetOwner():ClaimAwards()
    else

    end
end

function RegularlyClaimRewardState:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function RegularlyClaimRewardState:OnLeave(fsm)
    self:StopTimer()
end

function RegularlyClaimRewardState:CliamRewardRespone(fsm,isExit)
    if fsm then
        if isExit then
            self:ChangeState(fsm,"RegularlyAwardInfoExitState",2,1)
        end
    end
end

return RegularlyClaimRewardState