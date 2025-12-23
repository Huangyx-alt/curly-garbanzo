require "Logic/Fsm/BaseFsmState"

local GiftPackSweetmeatsItemFreeState = Clazz(BaseFsmState,"GiftPackSweetmeatsItemFreeState")

function GiftPackSweetmeatsItemFreeState:OnEnter(fsm,previous,...)
    
    if fsm then 
        fsm:GetOwner():ChangeFreeState()
    end 
end

function GiftPackSweetmeatsItemFreeState:OnLeave(fsm)

end

return GiftPackSweetmeatsItemFreeState