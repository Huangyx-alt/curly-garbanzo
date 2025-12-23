require "Logic/Fsm/BaseFsmState"

local GiftPackSweetmeatsItemBigState = Clazz(BaseFsmState,"GiftPackSweetmeatsItemBigState")

function GiftPackSweetmeatsItemBigState:OnEnter(fsm,previous,...)
    if fsm then 
        fsm:GetOwner():ChangeBuyState()
    end 
end

function GiftPackSweetmeatsItemBigState:OnLeave(fsm)

end

return GiftPackSweetmeatsItemBigState