
PlayCardNumberAvailableState = Clazz(BasePlayCardNumberState,"PlayCardNumberAvailableState")

function PlayCardNumberAvailableState:OnEnter(fsm,previous,...)
    if previous then
        fsm:GetOwner():SetImageColorGray(false)
        local callback = ({...})[1]
        if callback then
            callback()
        end
    end
end

function PlayCardNumberAvailableState:OnLeave(fsm)
    
end

function PlayCardNumberAvailableState:PlayCardsClick(fsm)
    if fsm then
        fsm:GetOwner():OnPlayCardsClick()
    end
end

function PlayCardNumberAvailableState:SetDisable(fsm,callback)
    if fsm then
        self:ChangeState(fsm,"PlayCardNumberDisableState",callback)
    end
end