
ShopNormalItemCDCountDownState = Clazz(ShopNormalItemBaseState,"ShopNormalItemCDCountDownState")

function ShopNormalItemCDCountDownState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetCountdDown(...)
end

function ShopNormalItemCDCountDownState:OnLeave(fsm)
    
end