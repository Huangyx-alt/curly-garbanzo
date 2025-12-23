local PowerUpBaseState = require "State.PowerUpView.PowerUpBaseState"
local PowerUpShowHandState = Clazz(PowerUpBaseState,"PowerUpShowHandState")

function PowerUpShowHandState:OnEnter(fsm,previous,...)
    log.g("PowerUpShowHandState:OnEnter")
end

function PowerUpShowHandState:OnLeave(fsm)

end

function PowerUpShowHandState:Dispose()

end

function PowerUpShowHandState:FinishShowHand(fsm)
    log.g("PowerUpShowHandState:FinishShowHand")
    if fsm then
        self:ChangeState(fsm,"PowerUpPrimitiveState")
    end
end

function PowerUpShowHandState:ClickDrawCard(fsm,gear,args)
    if fsm then
        fsm:GetOwner():ShowHandPlayClick()
    end
end

function PowerUpShowHandState:Play(fsm,args)
    if fsm then
        fsm:GetOwner():ShowHandPlayClick()
    end
end

function PowerUpShowHandState:CloseView(fsm,args)
    if fsm then
        fsm:GetOwner():ShowHandPlayClick()
    end
end
return  PowerUpShowHandState