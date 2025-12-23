
local VipRoomItem = BaseView:New("VipRoomItem")
local this = VipRoomItem

this.auto_bind_ui_items = {
    "btn_item",
    "lockBg",
    "textLockTip",
}


function VipRoomItem:New(data,owner)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.data = data
    o.owner = owner
    return o
end

function VipRoomItem:Awake()
    self:on_init()
end

function VipRoomItem:OnEnable()
    self:InitItem()
end

function VipRoomItem:RefreshItem()
    self:InitItem()
end

function VipRoomItem:OnDestroy()
    self:Close()
end

function VipRoomItem:InitItem()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    if currVipLv < 1 then
        fun.set_active(self.lockBg, true)
        self.textLockTip.text = "VIP ONLY"
        return
    end
    
    local level = ModelList.PlayerInfoModel:GetLv()
    local unlockLevel = self.data.featured_group[2]
    if level < unlockLevel then
        fun.set_active(self.lockBg, true)
        self.textLockTip.text = string.format("Unlock at Lv.%s",unlockLevel)
        return
    end
    fun.set_active(self.lockBg, false)
    
end

function VipRoomItem:on_btn_item_click()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    if currVipLv < 1 then
        UIUtil.show_common_popup(191298,true)
        return
    end
    local level = ModelList.PlayerInfoModel:GetLv()
    local unlockLevel = self.data.featured_group[2]
    if level < unlockLevel then
        UIUtil.show_common_popup(191299,true)
        return
    end
    
    self.owner:OnBtnItemplayClick(self.data)
end



return VipRoomItem