local PlayerInfoSysNewIconView = BaseView:New("PlayerInfoSysNewIconView","PlayerInfoSysAtlas")
local this = PlayerInfoSysNewIconView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anim",
    "imgHead",
    "imageFrame",
    "HeadObjPrefab",
    "textDes",
    "FlyRewardhit",
}

local unlockCreatCodeList = {}
local showItemIndex = 1

function PlayerInfoSysNewIconView:Awake(obj)
    self:on_init()
end

function PlayerInfoSysNewIconView:OnEnable(isSelf)
    Facade.RegisterView(self)
    self:InitView()
end

function PlayerInfoSysNewIconView:InitView()
    fun.set_active(self.FlyRewardhit, false)
    fun.set_active(self.HeadObjPrefab, true)
    fun.set_active(self.imgHead, false)
    fun.set_active(self.imageFrame, false)
    
    AnimatorPlayHelper.Play(self.anim,"PlayerInfoSysNewIconView",false, nil)
    
    local iconData = ModelList.PlayerInfoSysModel:GetUnlockIconData(showItemIndex)
    if iconData.iconType == avatarIconType.avatar then
        self:SetUnlockHead(iconData.icon)
        self:SetUnlockDes(1086)
    elseif iconData.iconType == avatarIconType.frame then
        self:SetUnlockFrame(iconData.icon)
        self:SetUnlockDes(1087)
    end

    LuaTimer:SetDelayFunction(1, function()
        self:FlyTopHeadIcon()
    end)
end

function PlayerInfoSysNewIconView:SetUnlockDes(id)
    self.textDes.text = Csv.GetDescription(id)
end

function PlayerInfoSysNewIconView:SetUnlockFrame(frameIconId)
    fun.set_active(self.imageFrame, true)
    ModelList.PlayerInfoSysModel:LoadTargetFrameSprite(frameIconId, self.imageFrame)
end

function PlayerInfoSysNewIconView:SetUnlockHead(headIconId)
    fun.set_active(self.imgHead, true)
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(headIconId, self.imgHead)
end

function PlayerInfoSysNewIconView:OnDisable()
    showItemIndex = 1
    unlockCreatCodeList = {}
    Event.Brocast(EventName.Event_show_unlock_avatar_or_frame_view)
    Facade.RemoveView(self)
end

function PlayerInfoSysNewIconView:CheckShowNext()
    showItemIndex = showItemIndex + 1 
    if ModelList.PlayerInfoSysModel:GetUnlockIconData(showItemIndex) then
        self:InitView()
    else
        ModelList.PlayerInfoSysModel:ClearHasUnlockNew()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end
end

function PlayerInfoSysNewIconView:FlyTopHeadIcon()
    local targetPos = GetShowHeadIconPos()
    Anim.scale_to_xy(self.HeadObjPrefab,0.4,0.4, 0.4)
    Anim.move_ease(self.HeadObjPrefab,targetPos.x,targetPos.y,0,0.5,false,DG.Tweening.Ease.InOutFlash,function()
        fun.set_active(self.HeadObjPrefab, false)
        self.HeadObjPrefab.transform.localPosition = Vector3.New(0,0,0)
        self.HeadObjPrefab.transform.localScale = Vector3.New(1,1,1)
        self:ShowLight(targetPos)
    end)

    LuaTimer:SetDelayFunction(1, function()
        self:CheckShowNext()
    end)
end

function PlayerInfoSysNewIconView:ShowLight(targetPos)
    self.FlyRewardhit.transform.position = targetPos
    fun.set_active(self.FlyRewardhit , true)
end

return this
