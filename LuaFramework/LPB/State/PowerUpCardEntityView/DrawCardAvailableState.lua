
require "State/PowerUpCardEntityView/DrawCardsBaseState"

DrawCardAvailableState = Clazz(DrawCardsBaseState,"DrawCardAvailableState")

function DrawCardAvailableState:OnEnter(fsm,previous,...)
    self:RepeatedEnter(fsm,...)
end

function DrawCardAvailableState:RepeatedEnter(fsm,...)
    fsm:GetOwner():SetCardAvailable(({ ... })[1])
end

function DrawCardAvailableState:DoDrawCardsAction(fsm,delay,pos,quality,index,lenth)
    self:ChangeState(fsm,"DrawCardsInitPositionState",delay,pos,quality,index,lenth)
end

function DrawCardAvailableState:ClickCard(fsm)
    if fsm then
        fsm:GetOwner():OnClickCard()
    end
end

function DrawCardAvailableState:OnLeave(fsm)

end

function DrawCardAvailableState:Dispose()

end