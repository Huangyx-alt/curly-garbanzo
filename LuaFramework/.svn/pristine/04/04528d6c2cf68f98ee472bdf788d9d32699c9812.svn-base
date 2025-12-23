local ShopBaseState = require("State/ShopView/ShopBaseState")
local  ShopEnterState = Clazz(ShopBaseState,"ShopEnterState")

function ShopEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function ShopEnterState:OnLeave(fsm)
    
end

function ShopEnterState:EnterFinish(fsm)
    self:ChangeState(fsm,"ShopOriginalState")
end
return ShopEnterState