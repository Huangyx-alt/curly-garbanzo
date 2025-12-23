
SevenDayHistoryGushState = Clazz(BaseSevenDayHistoryState,"SevenDayHistoryGushState")

function SevenDayHistoryGushState:OnEnter(fsm)
    fsm:GetOwner():PlayGush()
    UISound.play("gift_box_open")
end

function SevenDayHistoryGushState:OnLeave(fsm)

end

function SevenDayHistoryGushState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardObtainState")
    end
end