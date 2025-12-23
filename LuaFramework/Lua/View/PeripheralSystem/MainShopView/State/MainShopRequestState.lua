local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopRequestState = Clazz(MainShopBaseState,"MainShopRequestState")

function MainShopRequestState:OnEnter(fsm)
    fsm:GetOwner():ReqCurrentShopData()
end

function MainShopRequestState:OnLeave(fsm)
    
end

function MainShopRequestState:FetchInfoFinish(fsm)
    log.log("商店进入效果 完成请求" )
    self:ChangeState(fsm,"MainShopShowTypeState")
end
return MainShopRequestState