
PlayCardNumberDisableState = Clazz(BasePlayCardNumberState,"PlayCardNumberDisableState")

function PlayCardNumberDisableState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetImageColorGray(true)
    local callback = ({...})[1]
    if callback then
        callback()
    end
end

function PlayCardNumberDisableState:OnLeave(fsm)
    
end

function PlayCardNumberDisableState:SetAvailable(fsm,callback)
    if fsm then
        self:ChangeState(fsm,"PlayCardNumberAvailableState",callback)
    end
end