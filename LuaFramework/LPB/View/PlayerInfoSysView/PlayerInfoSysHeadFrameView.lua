PlayerInfoSysHeadFrameView = BaseView:New("PlayerInfoSysHeadFrameView","PlayerInfoSysAtlas")
local this = PlayerInfoSysHeadFrameView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local avatarAndFrameViewCode = require "View/PlayerInfoSysView/PlayerInfoUpdateAvatarAndFrame"

local avatarAndFrameView = nil

local avatarItemView = require "View/PlayerInfoSysView/PlayerInfoAvatarItem"
local frameItemView = require "View/PlayerInfoSysView/PlayerInfoFrameItem"

local lastToggleIndex = nil
local currentToggleIndex = nil

local groupFrameView = nil
local groupAvatarView = nil

this.auto_bind_ui_items = {
    "textLevel",
    --"textExpProgress",
    "imageExpProgress",
    "avatarList",
    "ContentAvatar",
    "avatarPrefab",
    "btn_close",
    "btn_confirm",
    "textName",
    "Toggle_Avatar",
    "Toggle_Frames",
    "frameList",
    "ContentFrame",
    "framePrefab",
    "textTitle",
    "imgHead",
    "imageFrame",
    "head_Obj",
    "anima",
    "label_avatar",
    "label_frames",
}

function PlayerInfoSysHeadFrameView:Awake(obj)
    self:on_init()
end

function PlayerInfoSysHeadFrameView:SetToggleCallBack()
    local toggles = {self.Toggle_Avatar,self.Toggle_Frames}
    for index, value in ipairs(toggles) do
        self.luabehaviour:AddToggleChange(value.gameObject,function(go,check)
            self:ToggleChange(go,check)
        end)
    end
end

function PlayerInfoSysHeadFrameView:ChangeToggleInfo()
    if currentToggleIndex == avatarToggle.frame then
        fun.set_active(self.avatarList, false)
        --self.textTitle.text = Csv.GetDescription(1309)
        self:InitFrameItem()
    elseif currentToggleIndex == avatarToggle.avatar then
        fun.set_active(self.frameList, false)
        --self.textTitle.text = Csv.GetDescription(1308)
        self:InitAvatarItem()
    end
end

function PlayerInfoSysHeadFrameView:ToggleChange(go,check)
    if check then
        lastToggleIndex = currentToggleIndex
        if go == self.Toggle_Avatar.gameObject then
            currentToggleIndex = avatarToggle.avatar
            self.label_avatar.color = Color(1, 1, 1, 1)
            self.label_frames.color = Color(1, 1, 1, 125/255)
        elseif go == self.Toggle_Frames.gameObject then
            currentToggleIndex = avatarToggle.frame
            self.label_avatar.color = Color(1, 1, 1, 125/255)
            self.label_frames.color = Color(1, 1, 1, 1)
        end
        if lastToggleIndex ~= currentToggleIndex then
            self:ChangeToggleInfo()
        end
    end
end

function PlayerInfoSysHeadFrameView:SetCurrentToggle()
    currentToggleIndex = avatarToggle.avatar
    if currentToggleIndex == avatarToggle.avatar then
        self.Toggle_Avatar.isOn = true
    elseif currentToggleIndex == avatarToggle.frame then
        self.Toggle_Frames.isOn = true
    end
end

function PlayerInfoSysHeadFrameView:ChangeSuccessTip()
    fun.enable_button(self.btn_confirm, false)
    Facade.SendNotification(NotifyName.ShowUI,ViewList.PlayerInfoSysHeadFrameSuccessView)
    self:PlayExite()
end

function PlayerInfoSysHeadFrameView:ChangeAvatarEvent()
    self:ClearDelayReturnState()
    if self._fsm and self._fsm:GetCurState() then
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState" , function()
            self:ChangeSuccessTip()
        end)
    end
end

function PlayerInfoSysHeadFrameView:ChangeFrameEvent()
    self:ClearDelayReturnState()
    if self._fsm and self._fsm:GetCurState() then
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState", function()
            self:ChangeSuccessTip()
        end)
    end
end

function PlayerInfoSysHeadFrameView:AddEvent()
    Event.AddListener(NotifyName.PlayerInfo.ChangeAvatarEvent,self.ChangeAvatarEvent,self)
    Event.AddListener(NotifyName.PlayerInfo.ChangeFrameEvent,self.ChangeFrameEvent,self)

    Event.AddListener(NotifyName.PlayerInfo.SysClickChooseAvatar,self.ClickAvatarChoose,self)
    Event.AddListener(NotifyName.PlayerInfo.SysClickChooseFrame,self.ClickFrameChoose,self)

end

function PlayerInfoSysHeadFrameView:RemoveEvent()
    Event.RemoveListener(NotifyName.PlayerInfo.ChangeAvatarEvent,self.ChangeAvatarEvent,self)
    Event.RemoveListener(NotifyName.PlayerInfo.ChangeFrameEvent,self.ChangeFrameEvent,self)

    Event.RemoveListener(NotifyName.PlayerInfo.SysClickChooseAvatar,self.ClickAvatarChoose,self)
    Event.RemoveListener(NotifyName.PlayerInfo.SysClickChooseFrame,self.ClickFrameChoose,self)
end

function PlayerInfoSysHeadFrameView:OnEnable(isSelf)
    Facade.RegisterView(self)
    self:AddEvent()
    self:BuildFsm()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"enter","commonViewenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
    avatarAndFrameView = avatarAndFrameViewCode:New()
    avatarAndFrameView:SkipLoadShow(self.head_Obj)
    avatarAndFrameView:SetIsOneSelf(true)
    self:InitView()
    self:SetToggleCallBack()
    self:SetCurrentToggle()
    self:ChangeToggleInfo()
end

function PlayerInfoSysHeadFrameView:BuildFsm()
    self:DisposeFsm()
    CommonState.BuildFsm(self,"PlayerInfoSysHeadFrameView")
end

function PlayerInfoSysHeadFrameView:SetHeadIcon(headIconId)
    avatarAndFrameView:SetAvatarId(headIconId)
end

function PlayerInfoSysHeadFrameView:SetFrameIcon(frameIconId)
    avatarAndFrameView:SetFrameId(frameIconId)
end

function PlayerInfoSysHeadFrameView:InitView()
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    self:SetInfo(userInfo)

    local useingHeadIconId = ModelList.PlayerInfoSysModel.GetUsingHeadIconID()
    self:SetHeadIcon(useingHeadIconId)

    local useingFrameIconId = ModelList.PlayerInfoSysModel.GetUsingFrameIconID()
    self:SetFrameIcon(useingFrameIconId)
end

function PlayerInfoSysHeadFrameView:SetInfo(userInfo)
    if userInfo then
        --local exp = Csv.GetData("level", userInfo.level,"exp")
        --self.imageExpProgress.fillAmount = userInfo.exp / exp
        --self.textExpProgress.text = string.format("%s%s",math.floor((userInfo.exp / exp) * 100),"%")
        self.textLevel.text = userInfo.level
        self.textName.text = userInfo.nickname
    end
end

function PlayerInfoSysHeadFrameView:OnDisable()
    avatarAndFrameView = nil
    lastToggleIndex = nil
    currentToggleIndex = nil

    groupFrameView = nil
    groupAvatarView = nil
    self:RemoveEvent()
    Facade.RemoveView(self)
    self:DisposeFsm()
end

function PlayerInfoSysHeadFrameView:InitAvatarItem()
    if groupAvatarView then
        fun.set_active(self.avatarList, true)
        return
    end
    local groupViewCode = require "View/PlayerInfoSysView/PlayerInfoSysChangeAvatarGroupView"
    local data = ModelList.PlayerInfoSysModel:GetAvatarList()
    groupAvatarView = groupViewCode:New(DeepCopy(data.list))
    groupAvatarView:SkipLoadShow(self.avatarList)
    fun.set_active(self.avatarList , true)
end

--点击头像 替换显示
function PlayerInfoSysHeadFrameView:ClickAvatarChoose(index)
    local itemData = groupAvatarView:GetChooseItemData()
    if itemData then
        this:SetHeadIcon(itemData.icon)
    end
end

--点击头像框 替换显示
function PlayerInfoSysHeadFrameView:ClickFrameChoose(index)
    local itemData = groupFrameView:GetChooseItemData()
    if itemData then
        this:SetFrameIcon(itemData.icon)
    end
end

function PlayerInfoSysHeadFrameView:InitFrameItem()
    if groupFrameView then
        fun.set_active(self.frameList, true)
        return
    end
    local groupViewCode = require "View/PlayerInfoSysView/PlayerInfoSysChangeFrameGroupView"
    local data = ModelList.PlayerInfoSysModel:GetFrameList()
    groupFrameView = groupViewCode:New(DeepCopy(data.list))
    groupFrameView:SkipLoadShow(self.frameList)
    fun.set_active(self.frameList , true)
end

function PlayerInfoSysHeadFrameView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function PlayerInfoSysHeadFrameView:PlayExite()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function PlayerInfoSysHeadFrameView:ChooseSameClose()
    fun.enable_button(self.btn_close , false)
    fun.enable_button(self.btn_confirm , false)
    AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function PlayerInfoSysHeadFrameView:on_btn_setting_click()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.SettingView)
end

function PlayerInfoSysHeadFrameView:on_btn_close_click()
    self:PlayExite()
end

function PlayerInfoSysHeadFrameView:on_btn_confirm_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        self:DelayReturnState()
        self:CheckChangeAvatar()
        self:CheckChangeFrame()
    end)
end

function PlayerInfoSysHeadFrameView:CheckChangeAvatar()
    if not groupAvatarView then
        log.log("请求修改取消 没有生成组件")
        return
    end

    if groupAvatarView:CheckUseIndexToChange() then
        log.log("请求修改取消 相同的选中 不处理")
        self:ChooseSameClose()
        return
    end

    local itemData = groupAvatarView:GetChooseItemData()
    if itemData then
        ModelList.PlayerInfoSysModel:C2S_RequestChangeHeadIcon(itemData.icon)
        groupAvatarView:ChangeInitByReqChoose()
    end
end

function PlayerInfoSysHeadFrameView:CheckChangeFrame()
    if not groupFrameView then
        log.log("请求修改取消 没有生成组件")
        return
    end

    if groupFrameView:CheckUseIndexToChange() then
        log.log("请求修改取消 相同的选中 不处理")
        self:ChooseSameClose()
        return
    end

    local itemData = groupFrameView:GetChooseItemData()
    if itemData then
        ModelList.PlayerInfoSysModel:C2S_RequestChangeHeadIconFrame(itemData.icon)
        groupFrameView:ChangeInitByReqChoose()
    end
end

function PlayerInfoSysHeadFrameView:DelayReturnState()
    self:ClearDelayReturnState()
    self.Timer = Invoke(function()
        if self._fsm and self._fsm:GetCurState() then
            self._fsm:GetCurState():ChangeState(self._fsm,"CommonOriginalState")
        end
    end, 3)
end

function PlayerInfoSysHeadFrameView:ClearDelayReturnState()
    if self.Timer then
        self.Timer:Stop()
        self.Timer = nil
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Tournament.ResphonePlayerInfo,func = this.OnResphonePlayerInfo}
}


return this
