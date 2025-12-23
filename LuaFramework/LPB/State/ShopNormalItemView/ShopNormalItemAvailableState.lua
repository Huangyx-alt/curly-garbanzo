
ShopNormalItemAvailableState = Clazz(ShopNormalItemBaseState,"ShopNormalItemAvailableState")

function ShopNormalItemAvailableState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetAvailable(...)
end

function ShopNormalItemAvailableState:OnLeave(fsm)

end

function ShopNormalItemAvailableState:ShopItemClick(fsm)
    if fsm:GetState("ShopNormalItemStiffState"):GetStiffCount() > 0 then --有其他商品在购买中，不能再进行购买动作
        log.r("Error:有其他商品在购买中，不能再进行购买动作")
        return
    end
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemStiffState")
    end
end