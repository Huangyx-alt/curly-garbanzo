local VolcanoMissionGiftPackItem = require("View.VolcanoMission.VolcanoMissionGiftPackItem")

--- 火山活动礼包
local GiftPackBaseView = require("View.GiftPack.GiftPackBaseView")
local VolcanoMissionGiftPackView = GiftPackBaseView:New('VolcanoMissionGiftPackView', "VolcanoMissionGiftPackAtlasInMain")
local this = VolcanoMissionGiftPackView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local data = nil
local product_list = {}

this.auto_bind_ui_items = {
    "GiftPackTwoView",
    "btn_close",
    "Gift1",
    "Gift2",
    "Gift3",
    "Gift4",
}

function VolcanoMissionGiftPackView:Awake(obj)
    this:on_init()
    self._isInit = true
    --- 修复部分机型首次进入界面不显示问题
    if self._reshowAfterInit then
        self._reshowAfterInit = nil
        self:ShowDetailGift()
    end
end

function VolcanoMissionGiftPackView.OnEnable()
    this:BuildFsm(this)
    this:Bi_Tracker()
end

function VolcanoMissionGiftPackView.OnDisable()
    this:stop_x_update()
    Facade.SendNotification(NotifyName.VolcanoMission.CloseGift)
end

function VolcanoMissionGiftPackView:OnDestroy()
    this:Destroy()
    self.item_list = {}
end

function VolcanoMissionGiftPackView:on_close()
    this:stop_x_update()
    table.each(self.item_list, function(v)
        v.packItem:Close()
    end)
end

function VolcanoMissionGiftPackView:ShowDetailGift()
    if self._isInit then
        data = ModelList.GiftPackModel:GetVolcanoMissionPack()
        if data then
            this:ShowProducts(data.pId, data.giftInfo)
        end
    else
        self._reshowAfterInit = true
    end
end

function VolcanoMissionGiftPackView:ShowProducts(pId, giftInfo)
    product_list = {}
    for k, v in pairs(Csv.pop_up) do
        if pId == v.gift_id then
            for i = 1, #giftInfo do
                if giftInfo[i].canBuyCount > 0 and giftInfo[i].id == k then
                    local type = self:CheckGiftType(v)
                    product_list[type] = product_list[type] or {}
                    table.insert(product_list[type], v.id)
                    break
                end
            end
        end
    end
    
    table.each(product_list, function(v, k)
        table.sort(v)
        
        ---只取同类型的前两个
        local t = {}
        table.each(v, function(id, k2)
            if k2 <= 2 then
                table.insert(t, id)
            end
        end)
        product_list[k] = t
    end)

    coroutine.start(function()    
        local temp = 0
        self.item_list = self.item_list or {}
        
        if GetTableLength(self.item_list) > 0 then
            coroutine.wait(1)
        end
        
        table.each(product_list, function(list)
            table.each(list, function(packID)
                temp = temp + 1
                local ctrlName = "Gift" .. temp
                if self[ctrlName] then
                    if not self.item_list[temp] then
                        local packItem = VolcanoMissionGiftPackItem:New(self, pId, packID)
                        packItem:SkipLoadShow(self[ctrlName])
                        self.item_list[temp] = {
                            packID = packID,
                            packItem = packItem,
                        }
                    else
                        self.item_list[temp].packItem:UpdateData(packID)
                        self.item_list[temp].packID = packID
                    end
                end
            end)
        end)
    end)
end

--道具Buff还是奖励Buff
function VolcanoMissionGiftPackView:CheckGiftType(cfg)
    local tempReward = cfg.item_description[3]
    if tempReward[1] == "37" or tempReward[1] == "37" then
        return 1
    elseif tempReward[1] == "36" then
        return 2
    end
    return 1
end

function VolcanoMissionGiftPackView:CloseFunc()
    Facade.SendNotification(NotifyName.HideDialog, this)
end

function VolcanoMissionGiftPackView:CutDonwTarget()
    this:CloseFunc()
    this.main_effect:Play("end")
end

function VolcanoMissionGiftPackView:OnBuySuccess(needClose, itemData)
    this:ChangeState(this, "GiftPackShowState", itemData)
    ViewList.VolcanoMissionMainView:OnBuyGiftSuccess()
end

function VolcanoMissionGiftPackView:GetGiftPos(id)
    local target = table.find(self.item_list, function(k, v)
        return v.packID == id
    end)
    if target and target.packItem then
        local a, b, c, d = target.packItem:GetGiftPos()
        return a, b, c, d
    end
end

function VolcanoMissionGiftPackView:on_btn_close_click(force)
    if this._fsm:GetCurName() == "GiftPackShowState" then
        return
    end
    Facade.SendNotification(NotifyName.HideUI, ViewList.VolcanoMissionGiftPackView)
    ModelList.GiftPackModel:CloseView()
end

return this
