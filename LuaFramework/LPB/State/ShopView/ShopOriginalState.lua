local ShopBaseState = require("State/ShopView/ShopBaseState")
local  ShopOriginalState = Clazz(ShopBaseState,"ShopOriginalState")

function ShopOriginalState:OnEnter(fsm)
    Facade.SendNotification(NotifyName.ShopView.EnterIdleState)
end

function ShopOriginalState:OnLeave(fsm)
    Facade.SendNotification(NotifyName.ShopView.LeaveIdleState)
end

function ShopOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopEnterState")
    end
end

function ShopOriginalState:BtnGobackClick(fsm)
    if fsm then
        fsm:GetOwner():DoGoback()
    end
end

function ShopOriginalState:FetchShopInfo(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopStiffState",ShopStiffType.fetchInfoStiff)
    end
end

function ShopOriginalState:DoPurchasing(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopStiffState",ShopStiffType.doPurchasingStiff)
    end
end
return ShopOriginalState