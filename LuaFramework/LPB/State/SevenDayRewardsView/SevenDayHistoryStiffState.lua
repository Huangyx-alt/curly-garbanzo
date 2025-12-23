

SevenDayHistoryStiffState = Clazz(BaseSevenDayHistoryState,"SevenDayHistoryStiffState")

function SevenDayHistoryStiffState:OnEnter(fsm,previous,...)
    self._change2state = ({...})[1]
    self._timer = Invoke(function()
        self:ChangeState(fsm,self._change2state or "ClaimRewardObtainState")
    end,2)
end

function SevenDayHistoryStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    self._change2state  = nil
end