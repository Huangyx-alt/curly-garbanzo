
local Command = {}

ClaimRewardViewType = {claimReward = 1,CollectReward = 2,claimRewardBox = 3,Reward = 4,sevenDayReward = 5,CollectRewardAd = 7,ThankCollectRewardAd = 8}

ClaimRewardAnimation = {task = 1,puzzle = 2,food = 3,puzzleStage = 4,sevenDayLogin =5,sevenDayHistory =6}

function Command.Execute(notifyName,...)
    local popupType, viewType, rewards, callback,promote,anima,isPromoteTopView,adData = select(1,...)
    local view = nil
    if viewType == ClaimRewardViewType.claimReward then
        view = ViewList.CollectRewardsView
    elseif viewType == ClaimRewardViewType.claimRewardBox then
        view = ViewList.ClaimRewardsBoxView
    elseif viewType == ClaimRewardViewType.CollectReward then
        view = ViewList.CollectRewardsView
    elseif viewType == ClaimRewardViewType.CollectRewardAd then
        view = ViewList.CollectRewardsAdView
    elseif viewType == ClaimRewardViewType.Reward then
        view = ViewList.RewardView
    elseif viewType == ClaimRewardViewType.sevenDayReward then
        view = ViewList.SevenDayRewardsView
    elseif viewType == ClaimRewardViewType.ThankCollectRewardAd then
        view = ViewList.ThankCollectRewardsView
    end
    if popupType == PopupViewType.show then
        view:SetRewards(rewards)
        view:SetCallBack(callback)
        view:SetAnimation(anima)
        view.isPromoteTopView = isPromoteTopView
        if view.SetAdData then
            view:SetAdData(adData)
        end
        Facade.SendNotification(NotifyName.ShowUI,view,nil,false,promote)
    else
        --Facade.SendNotification(NotifyName.CloseUI,view)
        if view.isShow then
            view:CloseView(callback)
        end
    end
end

return Command