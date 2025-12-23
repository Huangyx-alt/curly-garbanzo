---可观看广告的状态
local MagnifyingAdBaseState = require "State/MagnifyingAdView/MagnifyingAdBaseState"
local MagnifyingAdVipState = Clazz(MagnifyingAdBaseState,"MagnifyingAdVipState")

function MagnifyingAdVipState:OnEnter(fsm)
    fsm:GetOwner():OnVipState()
end

function MagnifyingAdVipState:OnBtnClick(fsm)
    if fsm then 
        fsm:GetOwner():OnBtnVipClick()--阅读事件
    end 
end

function MagnifyingAdVipState:OnBtnVipBuyClick(fsm)
    if fsm then 
        fsm:GetOwner():OnVipBuyClick()
    end 
end

function MagnifyingAdVipState:GroceryInfoUpdate(fsm)
    if fsm then 
        fsm:GetOwner():OnGroceryInfoUpdate()
    end 
end
return  MagnifyingAdVipState