
local Const = require "View/WinZone/WinZoneConst"
local WinZoneAvatarItem1 = BaseView:New("WinZoneAvatarItem1")
local this = WinZoneAvatarItem1
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "imgHead",
    "imgFrame2",
    "mask",
    "imgFlag1",
    "imgFlag2",
    "imgFlag3",
    "txtNameRoot",
    "txtName1",
    "txtName2",
    "normal",
    "empty",
    "scaleRoot",
    "imgFrame1",
    "start1",
    "start2",
    "start3",
}

function WinZoneAvatarItem1:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function WinZoneAvatarItem1:Awake()
    self:on_init()
end

function WinZoneAvatarItem1:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.hasInit = true
    if self.data then
        self:InitInfo(self.data)
    end

    fun.set_active(self.start1, false)
    fun.set_active(self.start2, false)
    fun.set_active(self.start3, false)
end

function WinZoneAvatarItem1:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.hasInit = nil
    self.data = nil
    self.index = nil
    self.isLast = nil
    self.joinDelay = nil
    self.reliveDelay = nil
end

function WinZoneAvatarItem1:SetData(data)
    self.data = data
    if self.data and self.hasInit then
        self:InitInfo(self.data)
    end
end

function WinZoneAvatarItem1:SetIndex(index, isLast)
    self.index = index  --ListUi中的顺序
    self.isLast = isLast    --时间概念上的最后一个，可是最后join的，也可以是最后复活的
end

function WinZoneAvatarItem1:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function WinZoneAvatarItem1:ShowEmpty()
    fun.set_active(self.empty, true)
    fun.set_active(self.normal, false)
end

function WinZoneAvatarItem1:ShowFull()
    fun.set_active(self.empty, false)
    fun.set_active(self.normal, true)
end

function WinZoneAvatarItem1:InitInfo(data)
    local imgHead = self.imgHead
    local txtName1 = self.txtName1
    local txtName2 = self.txtName2
    local flagTop = self.imgFlag1
    local flagBuff = self.imgFlag2
    local flagRelive = self.imgFlag3
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)

    --头像图片
    --玩家名称
    if fun.is_not_null(imgHead) then
        if data.robot == 0 and isSelf then
            fun.set_active(txtName1, false)
            fun.set_active(txtName2, true)
            txtName2.text = "You" --data.nickname
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
        else
            fun.set_active(txtName2, false)
            fun.set_active(txtName1, true)
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head01")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
            local nickname = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "name"))
            txtName1.text = nickname
        end
    end

    self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi01")

    --明星标志
    if data.isTop then
        fun.set_active(flagTop, true)
        self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi02")
    else
        fun.set_active(flagTop, false)
    end

    --buff标志
    if data.gameProps and fun.is_include(Const.BuffId1, data.gameProps) then
        self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi03")
        fun.set_active(flagBuff, true)
    else
        fun.set_active(flagBuff, false)
    end

    --复活标志
    if data.status == Const.PlayerStates.relive then
        fun.set_active(flagRelive, true)
    else
        fun.set_active(flagRelive, false)
    end
end

function WinZoneAvatarItem1:SetJoinDelay(delay)
    self.joinDelay = delay
end

function WinZoneAvatarItem1:WaittingJoin(delay)
    self:register_invoke(function()
        self:JoinRoom()
    end, delay)
end

function WinZoneAvatarItem1:JoinRoom()
    self:ShowFull()
    fun.set_active(self.start1, false)
    fun.set_active(self.start1, true)
    local bundle = {}
    bundle.index = self.index
    bundle.isLast = self.isLast
    bundle.isTop = self.data.isTop
    bundle.detail = self.data
    if self.data.isTop then
        fun.set_active(self.start3, false)
        fun.set_active(self.start3, true)
    end
    Facade.SendNotification(NotifyName.WinZone.PlayerJoinRoom, bundle)
end

function WinZoneAvatarItem1:SetReliveDelay(delay)
    self.reliveDelay = delay
end

function WinZoneAvatarItem1:WaittingRelive(delay)
    self:register_invoke(function()
        self:Relive()
    end, delay)
end

function WinZoneAvatarItem1:Relive()
    self:ShowFull()
    fun.set_active(self.start2, false)
    fun.set_active(self.start2, true)
    local bundle = {}
    bundle.index = self.index
    bundle.isLast = self.isLast
    bundle.detail = self.data

    Facade.SendNotification(NotifyName.WinZone.PlayerRelive, bundle)
end

function WinZoneAvatarItem1:OnAllAvatarCreateFinish(params)
    if self.reliveDelay then
        self:WaittingRelive(self.reliveDelay)
    elseif self.joinDelay then
        self:WaittingJoin(self.joinDelay)
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.AllAvatarCreateFinish, func = this.OnAllAvatarCreateFinish},
}

return this