
PlayCardNumberOriginalState = Clazz(BasePlayCardNumberState,"PlayCardNumberOriginalState")

function PlayCardNumberOriginalState:SetDisable(fsm,callback)
    if fsm then
        self:ChangeState(fsm,"PlayCardNumberDisableState",callback)
    end
end

function PlayCardNumberOriginalState:SetAvailable(fsm,callback)
    if fsm then
        self:ChangeState(fsm,"PlayCardNumberAvailableState",callback)
    end
end

