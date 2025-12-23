SevenDayHistoryOriginalState = Clazz(BaseSevenDayHistoryState,"SevenDayHistoryOriginalState")

function SevenDayHistoryOriginalState:OnEnter(fsm)

end

function SevenDayHistoryOriginalState:OnLeave(fsm)

end

function SevenDayHistoryOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardEnterState")
    end
end

function SevenDayHistoryOriginalState:DoClick(fsm)
    --if fsm then
    --    self:ChangeState(fsm,"ClaimRewardGushState")
    --end
    ViewList.SevenDayLoginView.ReqReward()
end