local ShopBaseState = require("State/ShopView/ShopBaseState")
local  ShopStiffState = Clazz(ShopBaseState,"ShopStiffState")

ShopStiffType = {fetchInfoStiff = 1,doPurchasingStiff = 2}

function ShopStiffState:OnEnter(fsm,previous,params)
    if params == ShopStiffType.fetchInfoStiff then
        fsm:GetOwner():OnFetchShopInfo()
        self._timer = Invoke(function()
            fsm:GetOwner():SetToggleStiff(true)
            self:FetchInfoFinish(fsm)
        end,3)
    elseif params == ShopStiffType.doPurchasingStiff then
        fsm:GetOwner():OnDoPurchasing()
        self._timer = Invoke(function()
            fsm:GetOwner():SetToggleStiff(true)
            self:DoPurchasingFinish(fsm)
        end,3)
    end
end

function ShopStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function ShopStiffState:FetchInfoFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopOriginalState")
    end
end

function ShopStiffState:DoPurchasingFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"ShopOriginalState")
    end
end
return ShopStiffState