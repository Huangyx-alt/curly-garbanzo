
ShopNormalItemBaseState = Clazz(BaseFsmState,"ShopNormalItemBaseState")

function ShopNormalItemBaseState:ResetState(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemOriginalState")
    end
end

function ShopNormalItemBaseState:Change2CountDown(fsm,isInit)
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemCDCountDownState",isInit)
    end
end

function ShopNormalItemBaseState:Change2NoAd(fsm,isInit)
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemNoAdState",isInit)
    end
end

function ShopNormalItemBaseState:Change2Available(fsm,isInit)
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemAvailableState",isInit)
    end
end

function ShopNormalItemBaseState:Change2Disable(fsm,isInit)
    if fsm then
        self:ChangeState(fsm,"ShopNormalItemDisableState",isInit)
    end
end

function ShopNormalItemBaseState:ShopItemClick(fsm)
end

function ShopNormalItemBaseState:ClearStiff(fsm)
end

function ShopNormalItemBaseState:CheckAD(fsm)
end