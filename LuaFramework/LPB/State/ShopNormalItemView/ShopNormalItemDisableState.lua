
ShopNormalItemDisableState = Clazz(ShopNormalItemBaseState,"ShopNormalItemDisableState")

function ShopNormalItemDisableState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetDisable(...)
end

function ShopNormalItemDisableState:OnLeave(fsm)

end