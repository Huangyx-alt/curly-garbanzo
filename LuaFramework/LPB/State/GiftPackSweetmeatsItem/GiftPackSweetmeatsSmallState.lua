require "Logic/Fsm/BaseFsmState"

local GiftPackSweetmeatsSmallState = Clazz(BaseFsmState,"GiftPackSweetmeatsSmallState")

function GiftPackSweetmeatsSmallState:OnEnter(fsm,previous,...)
    if fsm then 
        fsm:GetOwner():ChangeUnlockState()
    end 
end

function GiftPackSweetmeatsSmallState:OnLeave(fsm)

end

return GiftPackSweetmeatsSmallState