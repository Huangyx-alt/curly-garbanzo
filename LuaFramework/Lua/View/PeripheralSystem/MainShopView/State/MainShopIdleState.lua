local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopIdleState = Clazz(MainShopBaseState,"MainShopIdleState")

function MainShopIdleState:OnEnter(fsm)
    --fsm:GetOwner():PlayEnter()
end

function MainShopIdleState:OnLeave(fsm)
    
end

function MainShopIdleState:OnClickShopType(fsm,iSHasData)
    if iSHasData then
        self:ChangeState(fsm,"MainShopShowTypeState")
    else
        self:ChangeState(fsm,"MainShopRequestState")
    end
end

function MainShopIdleState:DoPurchasing(fsm,itemId)
    self:ChangeState(fsm,"MainShopPurchaseState",itemId)
    --fsm:GetOwner():ClickUpdateToggle()
    --self:ChangeState(fsm,"MainShopRequestState")
end

function MainShopIdleState:BtnGobackClick(fsm)
    fsm:GetOwner():OnClickClose()
end

function MainShopIdleState:OnClickCurVip(fsm)
    Facade.SendNotification(NotifyName.ShowUI,ViewList.CurrentVipAttributeView)
end

function MainShopIdleState:OnClickShopVip(fsm)
    Facade.SendNotification(NotifyName.ShowUI,ViewList.ShopVipAttributeView)
end

function MainShopIdleState:OnClickDailyFreeReward(fsm,dailyReward)
    log.log("请求领取商店每日奖励 " , dailyReward)
    self:ChangeState(fsm,"MainShopDailyRewardState",dailyReward)
end


return MainShopIdleState