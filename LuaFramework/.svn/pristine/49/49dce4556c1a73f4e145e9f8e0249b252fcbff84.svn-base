local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopEnterState = Clazz(MainShopBaseState,"MainShopEnterState")

function MainShopEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function MainShopEnterState:OnLeave(fsm)
    
end

function MainShopEnterState:EnterFinish(fsm,shopType)
    log.log("商店进入效果 进入下一个状态" , shopType)
    fsm:GetOwner():OnChangeShopType(shopType)
    if ModelList.MainShopModel:CheckMainShopDataExist(shopType) then

    else
        self:ChangeState(fsm,"MainShopRequestState")
    end
    --self:ChangeState(fsm,"MainShopIdleState")
end
return MainShopEnterState