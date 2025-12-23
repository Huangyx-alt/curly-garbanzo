require "View/CommonView/WatchADUtility"
require "State/Common/CommonState"

local VipLevelUpView = BaseView:New("VipLevelUpView", "MainTaskLevelUpAtlas")
local this = VipLevelUpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
local getRewardTaskInfo = nil

local CmdVipAttribute = require("Logic/PeripheralSystem/CmdVipAttribute")


local view = require("View/CommonView/CollectRewardsItem")


local isRegister = false;
this.auto_bind_ui_items = {
    "vipIcon",
    "anima",
    "btn_tapContinue",
    "currentVip",
    "nextVip",
    "imgVipBefore",
    "imgVipNow",
}

local enableClose = false
function VipLevelUpView:Awake()
    self:on_init()
end

function VipLevelUpView:OnEnable(params)
    enableClose = false
    AnimatorPlayHelper.Play(self.anima, { "enter", "VipLevelUpViewenter" }, false, function()
        enableClose = true
    end)
    self:InitLevelAttr()
    UISound.play("level_up")
end

function VipLevelUpView:OnDisable()
    CommonState.DisposeFsm(self)
end

function VipLevelUpView:OnDestroy()
    if self.cmdCurrentVipAttribute then
        self.cmdCurrentVipAttribute:CloseCmd()
        self.cmdCurrentVipAttribute = nil
    end
    if self.cmdNextVipAttribute then
        self.cmdNextVipAttribute:CloseCmd()
        self.cmdNextVipAttribute = nil
    end
end

function VipLevelUpView:on_btn_tapContinue_click()
    if enableClose then
        Facade.SendNotification(NotifyName.CloseUI, this)
    end
end


function VipLevelUpView:InitLevelAttr()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    local oldVipPts,oldVipLv = ModelList.PlayerInfoModel:GetOldVipPts()
    self.vipIcon.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. oldVipLv)

    LuaTimer:SetDelayFunction(0.9, function()
        self.vipIcon.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv)
    end, false, LuaTimer.TimerType.UI)
    
    self.cmdCurrentVipAttribute = CmdVipAttribute.New()
    self.cmdNextVipAttribute = CmdVipAttribute.New()
    self.cmdCurrentVipAttribute :OnCmdExecute(self.currentVip , currVipLv - 1)
    self.cmdNextVipAttribute:OnCmdExecute(self.nextVip , currVipLv)
    ModelList.PlayerInfoModel:SaveOldVipPts()
end



return this
