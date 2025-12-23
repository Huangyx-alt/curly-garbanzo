local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopShowTypeState = Clazz(MainShopBaseState,"MainShopShowTypeState")

function MainShopShowTypeState:OnEnter(fsm)
    fsm:GetOwner():ClickUpdateToggle()
end

function MainShopShowTypeState:OnLeave(fsm)
end

function MainShopShowTypeState:OnShopTypeFinish(fsm,isSuccess)
    log.log("商店进入效果 完成刷新内容" )
    if isSuccess then
        self:ChangeState(fsm,"MainShopIdleState")
    else
        fsm:GetOwner():OnErrorClose()
    end
end
return MainShopShowTypeState