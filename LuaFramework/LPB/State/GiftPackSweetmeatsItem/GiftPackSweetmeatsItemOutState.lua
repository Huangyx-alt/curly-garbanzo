require "Logic/Fsm/BaseFsmState"

local GiftPackSweetmeatsItemOutState = Clazz(BaseFsmState,"GiftPackSweetmeatsItemOutState")

function GiftPackSweetmeatsItemOutState:OnEnter(fsm,previous,...)
    if fsm then 
        fsm:GetOwner():ChangeOutState()
    end 
end

function GiftPackSweetmeatsItemOutState:OnLeave(fsm)

end

return GiftPackSweetmeatsItemOutState