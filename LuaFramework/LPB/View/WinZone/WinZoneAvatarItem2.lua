
local Const = require "View/WinZone/WinZoneConst"
local WinZoneAvatarItem2 = BaseView:New("WinZoneAvatarItem2")
local this = WinZoneAvatarItem2
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
    "Fail",
    "endeffect",
}

function WinZoneAvatarItem2:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function WinZoneAvatarItem2:Awake()
    self:on_init()
end

function WinZoneAvatarItem2:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.hasInit = true
    if self.data then
        self:InitInfo(self.data)
    end
end

function WinZoneAvatarItem2:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.hasInit = nil
    self.data = nil
    self.index = nil
end

function WinZoneAvatarItem2:SetData(data)
    self.data = data
    if self.data and self.hasInit then
        self:InitInfo(self.data)
    end
end

function WinZoneAvatarItem2:SetIndex(index)
    self.index = index  --ListUi中的顺序
end

function WinZoneAvatarItem2:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function WinZoneAvatarItem2:ShowEmpty()
    fun.set_active(self.empty, true)
    fun.set_active(self.normal, false)
end

function WinZoneAvatarItem2:ShowFull()
    fun.set_active(self.empty, false)
    fun.set_active(self.normal, true)
end

function WinZoneAvatarItem2:InitInfo(data)
    fun.set_active(self.Fail, false)
    fun.set_active(self.endeffect, false)
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

    self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi01")

    --明星标志
    if data.isTop then
        fun.set_active(flagTop, true)
        self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi02")
    else
        fun.set_active(flagTop, false)
    end

    --buff标志
    if data.gameProps and fun.is_include(Const.BuffId1, data.gameProps) then
        self.imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi03")
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
    fun.set_active(flagRelive, false)
end

function WinZoneAvatarItem2:Disuse()
    --self:ShowEmpty()
    local color = Color(0.2, 0.2, 0.2)
    fun.set_img_color(self.imgFlag3, color)
    fun.set_img_color(self.imgHead, color)   
    fun.set_active(self.Fail, true)
end

function WinZoneAvatarItem2:OnCelebratePromote()
    if not self.data then
        return
    end
    if self.data.status == Const.PlayerStates.promote then
        fun.set_active(self.endeffect, true)
    else
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.CelebratePromote1, func = this.OnCelebratePromote},
    {notifyName = NotifyName.WinZone.CelebratePromote2, func = this.OnCelebratePromote},
}

return this