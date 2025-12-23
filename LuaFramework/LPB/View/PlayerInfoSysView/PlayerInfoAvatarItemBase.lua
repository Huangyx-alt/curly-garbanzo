
local PlayerInfoAvatarItemBase = BaseView:New("PlayerInfoAvatarItemBase")
local this = PlayerInfoAvatarItemBase
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items ={
    "icon",
    "choose",
    "lock",
    "btn_icon",
}

function PlayerInfoAvatarItemBase:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function PlayerInfoAvatarItemBase:Awake()
    self:on_init()
end

function PlayerInfoAvatarItemBase:OnEnable()
    self.init = true
    self:SetInfo(self.data, self.index)
end

function PlayerInfoAvatarItemBase:OnDestroy()
    self:OnDispose()
    self.init = false
    self.data = nil
    self.index = nil
    self.chooseFunc = nil
    self.owner = nil
end

function PlayerInfoAvatarItemBase:OnDisable()
end

function PlayerInfoAvatarItemBase:SetChooseFunc(owner,func)
    self.owner = owner
    self.chooseFunc = func
end

function PlayerInfoAvatarItemBase:SetInfo(data,index)
    self.data = data or self.data
    self.index = index or self.index
    if self.init and self.data then
        local model = ModelList.PlayerInfoSysModel
        local status = self.data.status
        self:SetUsingSprite()
        if status == avatarStatus.using then
            fun.set_active(self.choose , true)
            fun.set_active(self.lock , false)
        elseif status == avatarStatus.unlock then
            fun.set_active(self.choose , false)
            fun.set_active(self.lock , false)
        else
            fun.set_active(self.choose , false)
            fun.set_active(self.lock , true)
        end
    end
end

function PlayerInfoAvatarItemBase:on_btn_icon_click()
    if self.data and self.data.icon then
        --用的本地图标
        --self.data.icon 对应本地配置表中的id
        if self.data.status == avatarStatus.lock then
            local desId = self:GetDesId()
            UIUtil.show_common_popup(desId,true)
        elseif self.data.status == avatarStatus.using then
            if self.chooseFunc then
                self.chooseFunc(self.owner,self.index)
            end
        elseif self.data.status == avatarStatus.unlock then
            if self.chooseFunc then
                self.chooseFunc(self.owner ,self.index)
            end
        end
    else
        --fb头像
    end   
end

function PlayerInfoAvatarItemBase:CheckUsing()
    if self.data and self.data.status == avatarStatus.using then
        return true
    end
    return false
end

function PlayerInfoAvatarItemBase:GetIconUI()
    return self.icon
end

--设置选中
function PlayerInfoAvatarItemBase:SetChoose(isChoose)
    fun.set_active(self.choose , true)
    if self.data.status == avatarStatus.unlock then
        self.data.status =avatarStatus.using
    end
end

--设置未选中
function PlayerInfoAvatarItemBase:SetCancelChoose(isChoose)
    fun.set_active(self.choose , false)
    if self.data.status == avatarStatus.using then
        self.data.status =avatarStatus.unlock
    end
end

function PlayerInfoAvatarItemBase:GetItemData()
    return self.data
end

function PlayerInfoAvatarItemBase:GetUsingAtlasName()
end

function PlayerInfoAvatarItemBase:SetUsingSprite()
end

function PlayerInfoAvatarItemBase:GetDesId()
end

function PlayerInfoAvatarItemBase:OnDispose()
end

return this