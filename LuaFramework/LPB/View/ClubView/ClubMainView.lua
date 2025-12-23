--公会主界面

local ClubMainChatState = require "State/Club/ClubMainView/ClubMainChatState"
local ClubMainEnterState = require "State/Club/ClubMainView/ClubMainEnterState"
local ClubMainExitState = require "State/Club/ClubMainView/ClubMainExitState"
local base64 = require "Common/base64"
local ClubMainView = BaseView:New("ClubMainView","ClubAtlas")
local this = ClubMainView
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog
--this.isCleanRes = true

this.auto_bind_ui_items = {
    "btn_goback",            --关闭按钮
    "btn_chat",
    "btn_bingo",
    "btn_shop",
    "ChatPanel",
    "btn_goHome",
    "Anima"
}

function ClubMainView:Awake()
  
    this:on_init()
end

function ClubMainView:OnEnable()
    Facade.RegisterView(this)

    self:BuildFsm()

    this:initData()
    this.animaEnd = false
    AnimatorPlayHelper.Play(self.Anima,{"strat","ClubMainViewstart"},false,function()
        this.animaEnd = true
    end)
end 

function ClubMainView:BuildFsm()
    self:DisposeFsm()
    
    self._fsm = Fsm.CreateFsm("ClubMainView",self,{
        ClubMainChatState:New(),
        ClubMainEnterState:New(),
        ClubMainExitState:New(), 
    })
    self._fsm:StartFsm("ClubMainEnterState")
end

function ClubMainView:initData()

    this:StopCountdown()

    if (not this.clubChatView) then 
        local review = require "View/ClubView/ClubChatView"
        this.clubChatView = review:New()
        this.clubChatView:SkipLoadShow(self.ChatPanel,true,nil)
    end 

    self.TimeLoop = LuaTimer:SetDelayLoopFunction(1, 5,-1, function()
        self:UpdateTime()
    end,nil,nil,LuaTimer.TimerType.UI)
    UISound.play_bgm("club_bgm")
end

function ClubMainView:UpdateTime()
    ---更新所有加入的定时器
    if this.clubChatView ~= nil then 
        this.clubChatView:UpdateTime()
    end 
end 

function ClubMainView:StopCountdown()
    if self.TimeLoop then
        LuaTimer:Remove(self.TimeLoop)
        self.TimeLoop = nil
    end
end 

function ClubMainView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function ClubMainView:OnDisable()
    
    Facade.RemoveView(this)

    if this.clubChatView then 
        this.clubChatView:OnDestroy()
        this.clubChatView = nil
    end 
    this:StopCountdown()
    
    UISound.stop_bgm()
    UISound.play_bgm("city")
end 

function ClubMainView:OnDestroy()
    this:Close()

    if this.clubChatView then 
        this.clubChatView:OnDestroy()
        this.clubChatView = nil
    end 

    this:StopCountdown()
    --- 退出时候清理公会预设AB，实际应该在每个界面的OnDestroy中清理，但是这里是主界面，同时为了热更，所以在这里清理
local culbAssetList = require("Module/ClubAssetList")
    if culbAssetList then
        Cache.unload_ab_no_depen(culbAssetList["ClubDetailView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubListSearchView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubLeaveView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubMemberListView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubOpenPackGiftGetListView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubOpenPackGiftGetView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqCardHelpView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqCardView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqGiftPacketHelpView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqResAskView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqResCollectView"],false)
        Cache.unload_ab_no_depen(culbAssetList["ClubReqResourceView"],false)
    end

end

--初始化得到公会信息
function ClubMainView:OnGetSelfClubInfo()
    local clubinfo = ModelList.ClubModel.GetSelfClubInfo()

    --初始化ChatView
    if this.clubChatView ~= nil then 
        this.clubChatView:Updata()
    end 
    
    --默认转到chatview
    this._fsm:ChangeState("ClubMainChatState")
end

--更新聊天
function ClubMainView:OnUpdateChatMessage()
    if this.clubChatView ~= nil then 
        this.clubChatView:Updata()
    end 
end

function ClubMainView:OnUpdatePackageCount()
    if this.clubChatView ~= nil then 
        this.clubChatView:UpdatePackageCount()
    end 
end 

function ClubMainView.OnUpdateChatHelp(reward)
    if not reward or reward == nil or #reward ==0 then
        log.r("no reward no reward 帮助奖励为空")
        return 
    end     

    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.ThankCollectRewardAd,reward,function()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide, ClaimRewardViewType.ThankCollectRewardAd)
    end)
end 

--关闭本界面
function ClubMainView:OnBackHall()
    if this.animaEnd == true then 
        this._fsm:ChangeState( "ClubMainExitState")
        Facade.SendNotification(NotifyName.CloseUI,this)
    end 
end 

function ClubMainView:CloseTopBarParent()
    if this.animaEnd == true then 
        this._fsm:ChangeState("ClubMainExitState")
        Facade.SendNotification(NotifyName.CloseUI,this)
    end 
end

--展现
function ClubMainView.OnGiftPackageOpenClub(msgid)
    if msgid ~= nil then 
        Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubOpenPackGiftGetView,nil,nil,msgid)
    end 
end 

--
function ClubMainView.onCardHelpSucesss(msgid)
    if msgid ~= nil then 
        local chatList =  ModelList.ClubModel.GetMessageList()
        local decoded = base64.decode(chatList[msgid].msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_SEASON_CARD_ASK,decoded)
        local tipStr = Csv.GetDescription(30098)
        ModelList.SeasonCardModel:DropOneCard(ChatInfo.cardId,ChatInfo.seasonId)

        Facade.SendNotification(NotifyName.Common.CommonTip,tipStr)
    end 
   
end

function ClubMainView.OnFetchClub()
    if this.clubChatView and this.clubChatView.ClubInfoView then
        this.clubChatView.ClubInfoView:Updata()
    end
end 

--被踢出工会
function ClubMainView.BeKickedClub()
    Facade.SendNotification(NotifyName.CloseUI, this)
end 

--点击聊天
function ClubMainView:on_btn_chat_click()
   
end

--点击Bingo
function ClubMainView:on_btn_bingo_click()
    
end

--点击商店
function ClubMainView:on_btn_shop_click()
    
end

function ClubMainView:on_btn_goHome_click()
    this:CloseTopBarParent()
end

function ClubMainView:_close()
    self.__index.closeWithAnimation(self)
end

this.NotifyList = {
    {notifyName = NotifyName.Club.GetSelfClubInfo,func = this.OnGetSelfClubInfo},
    {notifyName = NotifyName.Club.UpdateMessageClub,func = this.OnUpdateChatMessage},
    {notifyName = NotifyName.SceneCity.Goback_Hall_city,func = this.OnBackHall},
    {notifyName = NotifyName.Club.FetchMessageClub,func = this.OnUpdateChatMessage},
    {notifyName = NotifyName.Club.AskResHelpClub,func = this.OnUpdateChatHelp},
    {notifyName = NotifyName.Club.GiftPackageOpenClub,func = this.OnGiftPackageOpenClub},
    {notifyName = NotifyName.Club.BeKickedClub,func = this.BeKickedClub},
    {notifyName = NotifyName.Club.SeasonCardAskHelpClub,func = this.onCardHelpSucesss},
    {notifyName = NotifyName.Club.UpdatePackageCount,func = this.OnUpdatePackageCount},
    {notifyName = NotifyName.Club.FetchClub, func = this.OnFetchClub},
    {notifyName = NotifyName.SeasonCard.SeasonOver, func = this.OnUpdateChatMessage},
   
    --赠送卡牌后一点弱提示
}

return this 