local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopPurchaseState = Clazz(MainShopBaseState,"MainShopPurchaseState")

function MainShopPurchaseState:OnEnter(fsm,previous,itemId)
    fsm:GetOwner():ShowLoadinCircle(true)
    ModelList.MainShopModel.C2S_RequestBuyItem(itemId)
end

function MainShopPurchaseState:OnLeave(fsm)
end


function MainShopPurchaseState:DoPurchasingFinish(fsm,isSuccess)
    log.log("购买结果",isSuccess)
    if isSuccess then
        self:ChangeState(fsm,"MainShopIdleState")
    else
        --提示购买失败todo
        self:ChangeState(fsm,"MainShopIdleState")
    end
end

return MainShopPurchaseState