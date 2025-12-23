BetRateOperatedOriginalState = Clazz(BetRateOperatedBaseState,"BetRateOperatedOriginalState")

function BetRateOperatedOriginalState:OnEnter(fsm)

end

function BetRateOperatedOriginalState:OnLeave(fsm)

end

function BetRateOperatedOriginalState:Operate(fsm,param)
    if fsm then
        self:ChangeState(fsm,"BetRateOperatedStiffState",param)
    end
end