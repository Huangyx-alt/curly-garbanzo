local Const = require "View/CarQuest/CarQuestConst"
local CarQuestPropItem = BaseView:New("CarQuestPropItem")
local this = CarQuestPropItem
this.viewType = CanvasSortingOrderManager.LayerType.none

this.auto_bind_ui_items = {
    "imgShadow",
    "imgItem",
    "txtNum",
    "root1",
    "root2",
    "canvasGroup",
}

local IconNames = {
    [1] = {"CarGEM", "CarGEMsmall"},
    [2] = {"CarCoin", "CarCoinSmall"},
    [3] = {"CarZoom", "CarZoomSmall"},
    [9] = {"CarRocket", "CarRocketSmall"},
    [6021] = {"CarCard", "CarCardSmall"},
}

local EffectNames = {
    [1] = "baozuanshi",
    [2] = "baojinbi",
    [3] = "baozoom",
    [9] = "baoxiaohuojian",
    [6021] = "baocard",
}

function CarQuestPropItem:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CarQuestPropItem:Awake()
end

function CarQuestPropItem:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.isSelected = false
end

function CarQuestPropItem:on_after_bind_ref()
    fun.set_active(self.txtNum, false)
    if self.data and self.col then
        self:InitItem()
    end
end

function CarQuestPropItem:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function CarQuestPropItem:SetParent(parent)
    self.parent = parent
end

function CarQuestPropItem:SetView(view)
    self.view = view
end

function CarQuestPropItem:SetData(data, col)
    self.data = data
    self.col = col or 1
end

function CarQuestPropItem:UpdateData(data, col)
    self.data = data
    self.col = col or 1
    self:InitItem()
end

function CarQuestPropItem:InitItem()
    local itemGo = self.go
    local col = self.col
    local data = self.data
    fun.set_rect_anchored_position(itemGo, (col - (Const.TrackCount + 1) / 2) * Const.TrackWidth, data.pos)
    local ref = fun.get_component(itemGo, fun.REFER)
    local imgShadow = ref:Get("imgShadow")
    local imgItem = ref:Get("imgItem")
    local txtNum = ref:Get("txtNum")
    local name = Csv.GetItemOrResource(data.rewards.id, "name")
    local itemId = data.rewards.id
    if col == Const.MyTrackNum then
        imgItem.sprite = AtlasManager:GetSpriteByName("CarQuestMainAtlas",  IconNames[itemId][1])
        imgShadow.sprite = AtlasManager:GetSpriteByName("CarQuestMainAtlas",  "CarCoinTY")
    else
        imgItem.sprite = AtlasManager:GetSpriteByName("CarQuestMainAtlas",  IconNames[itemId][2])
        imgShadow.sprite = AtlasManager:GetSpriteByName("CarQuestMainAtlas",  "CarCoinTYsmall")
    end
    imgShadow:SetNativeSize()
    imgItem:SetNativeSize()

    --打印item相关信息方便定位问题
    --self:PrintItemInfo(col, data)
end

function CarQuestPropItem:PrintItemInfo(col, data)
    local content = ""
    if col == Const.MyTrackNum then
        content = content .. data.totalIdx .. "  " .. data.stageIdx .. "  " .. data.subStageIdx .. "\n"
        content = content .. "Score:" ..data.score .. "\n"
        content = content .. "pos:" .. data.pos .. "\n"
        content = content .. "value:" .. data.rewards.value
    end
    self.txtNum.text = content
end

function CarQuestPropItem:GetTotalIdx()
    return self.data.totalIdx
end

function CarQuestPropItem:Deactive()
    self.canvasGroup.alpha = 0
end

function CarQuestPropItem:Active()
    self.canvasGroup.alpha = 1
end

function CarQuestPropItem:GetPos()
    return self.data.pos
end

function CarQuestPropItem:PlayCollisionEffect()
    self:Deactive()
    if self.col == Const.MyTrackNum then
        local data = self.data
        local name = Csv.GetItemOrResource(data.rewards.id, "name")
        local itemId = data.rewards.id
        local effectName = EffectNames[itemId]
        local effectGo = fun.get_instance(self.view[effectName], self.view.propEffectRoot)
        if fun.is_not_null(effectGo) then
            fun.set_same_position_with(effectGo, self.go)
            self.view:register_invoke(function()
                if fun.is_not_null(effectGo) then
                    UnityEngine.Object.Destroy(effectGo)
                end
            end, 1)
        end
        UISound.play("coinfly")
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.ZipResDownload.StartDownload, func = this.OnStartDownload},
}

return this