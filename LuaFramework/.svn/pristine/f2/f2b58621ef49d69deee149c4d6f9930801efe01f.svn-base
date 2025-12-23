

SevenDayHistoryObtainState = Clazz(BaseSevenDayHistoryState,"SevenDayHistoryObtainState")

function SevenDayHistoryObtainState:OnEnter(fsm)
    self._timer = Invoke(function()
        if self then
            self:DoClick(fsm)
        end
    end,0.35)
end

function SevenDayHistoryObtainState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function SevenDayHistoryObtainState:DoClick(fsm)
    if fsm then
        fsm:GetOwner():ObtainReward()
        self:ChangeState(fsm,"ClaimRewardStiffState","SevenDayHistoryObtainState")
    end
end