--- FB粉丝页关注
local FansPageView = BaseView:New("FansPageView")
local this = FansPageView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true

this.auto_bind_ui_items = {
    "btn_close",
    "btn_goto_fans_page",
    "anima"
}

function FansPageView:Awake()
    Facade.RegisterView(this)
    self:on_init()
end

function FansPageView:OnEnable()
    ModelList.FBFansModel:ReqShowFollow()

    LuaTimer:SetDelayFunction(0.5, function()
        local check = ModelList.FBFansModel:CheckFollowReward()
        if check then
            --领取奖励
            ModelList.FBFansModel:ReqFbFollowReward()
        end
    end)
end

function FansPageView:OnDisable()
    Facade.RemoveView(this)
    Event.Brocast(EventName.Event_popup_fans_page_finish)
end

function FansPageView:OnApplicationFocus(focus)
    if focus and this.isInFansPage then
        this.isInFansPage = false
        --领取奖励
        ModelList.FBFansModel:ReqFbFollowReward()
    end
end

function FansPageView:on_btn_goto_fans_page_click()
    this.isInFansPage = true
    --记录已经打开
    ModelList.FBFansModel:ReqFollowFb()
    ModelList.FBFansModel:SaveInPrefs("need_follow_reward", 1)
    
    local url = "https://www.facebook.com/people/Live-Party-Bingo/100081989509019/"
    fun.OpenURL(url)
end

function FansPageView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function FansPageView.OnReceiveFbFollowReward(data)
    ModelList.FBFansModel:SaveInPrefs("need_follow_reward", 0)
    
    --local rewards = Csv.GetData("control",151,"content")
    local rewards = data and data.reward or Csv.GetData("control",151,"content")
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show, ClaimRewardViewType.CollectReward, rewards, function()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide, ClaimRewardViewType.CollectReward, nil, function()
            Facade.SendNotification(NotifyName.CloseUI, this)
        end)
    end)
end

this.NotifyList =
{
    {notifyName = NotifyName.FBFansPage.ReceiveFbFollowReward, func = this.OnReceiveFbFollowReward}
}

return this








