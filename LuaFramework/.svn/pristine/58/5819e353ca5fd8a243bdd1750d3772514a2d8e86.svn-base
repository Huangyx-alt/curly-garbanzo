
ShopNormalItemStiffState = Clazz(ShopNormalItemBaseState,"ShopNormalItemStiffState")

local stiff_item_count = 0

local testIndex = 0

function ShopNormalItemStiffState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)

    testIndex = testIndex + 1
    o.testId = testIndex
    return o
end

function ShopNormalItemStiffState:OnInit(fsm)
    stiff_item_count = 0
end

function ShopNormalItemStiffState:OnEnter(fsm,previous)
    fsm:GetOwner():ClickReaction()
    self:StopTimer()
    self._timer = Invoke(function()
        --Facade.SendNotification(NotifyName.Common.PopupDialog, 8012, 1);
        --UIUtil.show_common_popup(8012,true)
        local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
        if buyshopitem then
            buyshopitem.ClearCurrentShopItem()
        end
        self:ResetState(fsm)
        fsm:GetOwner():CheckState()
    end,5)
    
    stiff_item_count = stiff_item_count + 1
end

function ShopNormalItemStiffState:OnLeave(fsm)
    self:StopTimer()
    stiff_item_count = stiff_item_count - 1
end

function ShopNormalItemStiffState:GetStiffCount()
    return stiff_item_count
end

function ShopNormalItemStiffState:Dispose()
    self:OnLeave(nil)
end

function ShopNormalItemStiffState:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function ShopNormalItemStiffState:ClearStiff(fsm) --这个没有调用，返回消息都有重置了
    if fsm then
        self:ResetState(fsm)
        fsm:GetOwner():CheckState()
    end
end