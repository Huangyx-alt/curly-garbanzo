
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconSaleView = FunctionIconBaseView:New()
local this = FunctionIconSaleView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "icon",
    "text_countdown",
}

function FunctionIconSaleView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.saleData = data
    --log.log("dps 新版图标 促销图标数据 " , data)
    return o
end

function FunctionIconSaleView:Awake()
    self:on_init()
end

function FunctionIconSaleView:on_btn_icon_click()
    UISound.play("kick")
    self:ReportClickSaleIcon()
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, nil, true, self.saleData.name)
end

function FunctionIconSaleView:OnEnable()
    local iconName = self.saleData.icon
    --log.log("dps 新版图标 促销图标数据 " , self.saleData)
    local iconSprite = AtlasManager:GetSpriteByName("GiftPackIconAtlas", iconName)
    if fun.is_not_null(iconSprite) then
        self.icon.sprite = iconSprite
    else
        Cache.load_texture(AssetList[iconName], iconName, function(objs)
            if objs then
                local sprite = Util.Texture2Sprite(objs)
                if fun.is_not_null(self.icon) and fun.is_not_null(sprite) then
                    self.icon.sprite = sprite
                end
            end
        end)
    end

    self.loopTime = self:register_loop_timer(0, 1, -1, function()
        local curr = ModelList.PlayerInfoModel.get_cur_server_time()
        self.text_countdown.text = fun.SecondToStrFormat(self.saleData.expireTime - curr)
        local leftTime = self.saleData.expireTime - curr
        if leftTime < 0  then
            self.iconManager:HideSaleIcon(self.saleData.name)
        end
    end, nil, nil, LuaTimer.TimerType.UI)
end

function FunctionIconSaleView:OnDisable()
end

function FunctionIconSaleView:on_close()
    
end

function FunctionIconSaleView:OnDestroy()
    self.iconManager = nil
    self:Close()
end

--礼包图标总是可用
function FunctionIconSaleView:IsFunctionOpen()
    return true
end

function FunctionIconSaleView:IsExpired()
    return false
end

function FunctionIconSaleView:ReportClickSaleIcon()
    Http.report_event("purchase_click_client",{itemposclient = 0 ,itempos = self.saleData.name , viplevel = ModelList.PlayerInfoModel:GetVIP()})
end


return this