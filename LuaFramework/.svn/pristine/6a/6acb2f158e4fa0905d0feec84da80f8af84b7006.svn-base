SevenDayHistoryEnterState = Clazz(BaseSevenDayHistoryState,"SevenDayHistoryEnterState")

function SevenDayHistoryEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
    UISound.play("gift_box")
end

function SevenDayHistoryEnterState:OnLeave(fsm)
    
end

function SevenDayHistoryEnterState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardOriginalState")
    end
end