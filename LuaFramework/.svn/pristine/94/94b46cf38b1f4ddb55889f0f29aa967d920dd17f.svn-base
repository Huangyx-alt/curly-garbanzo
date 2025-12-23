
BetRateOperatedStiffState = Clazz(BetRateOperatedBaseState,"BetRateOperatedStiffState")

function BetRateOperatedStiffState:OnEnter(fsm,prvious,...)
    local params = ({ ... })[1]
    if 1 == params then
        fsm:GetOwner():OnIncreaseClick()
    elseif 2 == params then
        fsm:GetOwner():OnDecreaseClick()
    elseif 3 == params then
        fsm:GetOwner():OnMaximumClick()
    end
    self:FinishOperate(fsm)
    --if CityHomeScene then
    --    CityHomeScene:SetEnterHallFromUI(false)
    --    CityHomeScene:SetEnterHallFromBattle(false)
    --end
end

function BetRateOperatedStiffState:OnLeave(fsm)
    
end

function BetRateOperatedStiffState:FinishOperate(fsm)
    if fsm then
        self:ChangeState(fsm,"BetRateOperatedOriginalState")
    end
end