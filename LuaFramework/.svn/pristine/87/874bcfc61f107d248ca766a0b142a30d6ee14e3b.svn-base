
require "View/CommonView/RemainTimeCountDown"
-- local itemView = require("View/CommonView/CollectRewardsItem")
local itemView = require "View/RewardShowTip/RewardShowTipItem2"



local TournamentBlackGoldSettleRewardView = BaseDialogView:New("TournamentBlackGoldSettleRewardView","TournamentAtlas")
local this = TournamentBlackGoldSettleRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "box",
    "imgBox",
    "textTips1",
    "textTips2",
    "textTips3",
    "rewards1",
    "rewards2",
    "rewards3",
    "rewards4",
    "ZBjb",
}

local boxImageName = 
{
    -- [1] = "LH06",
    -- [2] = "ZBjbLb05",
    -- [3] = "ZBjbLb04",
    [1] = "LH07",
    [2] = "LH07",
    [3] = "LH07",
}

--根据奖励数量 显示位置 （不包含黑卡）
local rewardItemOrder = 
{
    [1] = {[3] = true},
    [2] = {[2] = true,[4] = true},
    [3] = {[2] = true,[3] = true,[4] = true},
    [4] = {[1]= true,[2] = true,[3] = true,[4] = true},
    [5] = {[1]= true,[2] = true,[3] = true,[4] = true,[5] = true},
}

--根据奖励数量 显示位置 （包含黑卡）
local rewardItemOrderBlackCard = 
{
    [1] = {[1] = true},
    [2] = {[1] = true,[3] = true},
    [3] = {[1] = true,[2] = true,[4] = true},
    [4] = {[1]= true,[2] = true,[3] = true,[4] = true},
    [5] = {[1]= true,[2] = true,[3] = true,[4] = true,[5] = true},
}


local boxStartScale = 
{
    [1] = 0.65,
    [2] = 0.5,
    [3] = 0.45,
}

local movePosOffset = 
{
    [1] = {x= 0 ,y = 45 ,z = 0},
    [2] = {x= 0 ,y = 30 ,z = 0},
    [3] = {x= 0 ,y = 30 ,z = 0},

}

local moveJumpOffset = 
{
    [1] = -6,
    [2] = -4,
    [3] = -4,

}


local cacheData = nil
local hasUpdateItemInfo = false
local flyItemList = {}
local hasFlyReward = false

function TournamentBlackGoldSettleRewardView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldSettleRewardView:OnEnable(params)
    Facade.RegisterView(self)
    self:SetBoxImage()
    self.startMovePos = params.startMovePos
    self.rewardBox = params.rewardBox 
    self:SetTitle()
    -- self:RequestTournamentReward()
    self:SetMyTrophy()
    CommonState.BuildFsm(self,"TournamentBlackGoldSettleRewardView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"enter","TournamentSettleRewardViewenter"},false,function()  --需要这个
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonState2State" , function()
                -- self:OpenSetRewardData()  --测试用
                self:RequestTournamentReward()
            end)
        end)
    end)

    self:ShowResultFlyBox()
  
end

function TournamentBlackGoldSettleRewardView:SetMyTrophy()
    local tiers = ModelList.TournamentModel:GetMyTournamentTrophy()
    local trophyName = fun.GetCurrTournamentActivityImg(tiers)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            self.ZBjb.sprite = sprite
        end
    end)
end


function TournamentBlackGoldSettleRewardView:SetBoxImage()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    if not myRank or not boxImageName[myRank] then
        return
    end
    Cache.load_sprite(AssetList["giftbox"],boxImageName[myRank],function(sprite)
        if sprite then
            self.imgBox.sprite = sprite
        end
    end)
end

function TournamentBlackGoldSettleRewardView:SetTitle()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    local rankTip = Csv.GetDescription(999)
    local colorRank = string.format("<color=#FEEDA7>#%s</color>", myRank)
    self.textTips1.text = string.format(rankTip, colorRank)
    self.textTips2.text = Csv.GetDescription(1301)
    self.textTips3.text = Csv.GetDescription(1302)

end

function TournamentBlackGoldSettleRewardView:ShowResultFlyBox()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    local boxStartScale = boxStartScale[myRank]
    fun.set_active(self.box, true)
    self.box.transform.localScale = Vector3.New(boxStartScale,boxStartScale,boxStartScale)
    self.endMovePos = self.box.transform.position
    self.box.transform.position = self.startMovePos


    fun.set_active(self.rewardBox, false)
    local oldpPos = self.box.transform.localPosition
    local PosOffset = movePosOffset[myRank]
    self.box.transform.localPosition = Vector3.New(oldpPos.x + PosOffset.x, oldpPos.y + PosOffset.y , oldpPos.z)

    LuaTimer:SetDelayFunction(0.5, function()
        fun.set_active(self.box, true)
        local path = {}
        path[1] = fun.calc_new_position_between(self.startMovePos, self.endMovePos, 0, moveJumpOffset[myRank], 0)
        path[2] = self.endMovePos
        Anim.bezier_move(self.box ,path, 0.4,0,1,2,function()
        end)
        Anim.scale_to_xy(self.box , 1,1, 0.4 , function()
        end)
    end)

end

function TournamentBlackGoldSettleRewardView:OnDisable()
    Event.Brocast(NotifyName.Tournament.TopPlayerCollectRewardCloseView)
    cacheData = nil
    hasUpdateItemInfo = false
    flyItemList = {}
    hasFlyReward = false
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function TournamentBlackGoldSettleRewardView:OpenSetRewardData()
    -- ModelList.TournamentModel.S2C_OnTournamentRewardInfo(1 , {})  --测试用
    local rewards = ModelList.TournamentModel:GetTournamentRewardList()
    if rewards then
        self:SetRewardData(rewards)
    end
end

function TournamentBlackGoldSettleRewardView:FlyRewardToTopArea()
    LuaTimer:SetDelayFunction(1, function()
        for k , v in pairs(flyItemList) do
            local flyStartPos = v.obj.transform.position
            local flyitem = v.itemInfo
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,flyStartPos,flyitem, function()
                Event.Brocast(EventName.Event_currency_change)
                self:CheckFlyReward()
            end, nil, true)
        end
    end)
end

function TournamentBlackGoldSettleRewardView:CheckFlyReward()
    if not hasFlyReward then
        hasFlyReward = true
        self._fsm:GetCurState():DoCommonState4Action(self._fsm,"CommonState5State" , function()
            self:PlayExit()
        end)
    end
end

function TournamentBlackGoldSettleRewardView:PlayExit()
    AnimatorPlayHelper.Play(self.anima,{"exit","TournamentSettleRewardViewexit"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function TournamentBlackGoldSettleRewardView:PlayBoxOpenAnim()
    AnimatorPlayHelper.Play(self.anima,{"open","TournamentSettleRewardViewopen"},false,function()

        Event.AddListener(NotifyName.Tournament.BlackCardSendTipFinish,self.BlackCardSendTipFinish,self)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentBlackGoldGiftComingView, function()
        end)

    end)
end

--如果有黑卡奖励 黑卡放在最前
function TournamentBlackGoldSettleRewardView:ReplaceRewardData(rewards)
    -- if true then
    --     rewards = 
    --     {
    --         [1] = {id = 1 , value = 100000},
    --         [2] = {id = 2 , value = 21000},
    --         [3] = {id = 1050 , value = 1},
    --         [4] = {id = 3 , value = 10},
    --     }
    -- end
    
    table.sort(rewards , function(a,b )
        if fun.CheckIsAmazonCard(a.id) then
            return true
        end
        if fun.CheckIsAmazonCard(b.id) then
            return false
        end
        return false
    end)

    return rewards
end


function TournamentBlackGoldSettleRewardView:SetRewardData(rewards)
    if hasUpdateItemInfo then
        return
    end
    rewards  = self:ReplaceRewardData(rewards)
    hasUpdateItemInfo = true
    local rewardNum = GetTableLength(rewards)
    if rewardNum == 0 then
        self:PlayExit()
    else
        local hasBlackCard = fun.CheckIsAmazonCard(rewards[1].id)
        local itemOrder = self:GetItemOrderData(hasBlackCard , rewardNum)
        local reward_index = 1
        for i = 1 , 4 do
            local itemObj = self["rewards" .. i]
            if not itemOrder[i] then
                fun.set_active(itemObj , false)
            else
                fun.set_active(itemObj , true)
                self:SetItemInfo(i , rewards[reward_index]  ,itemObj )
                reward_index = reward_index + 1
            end
        end
    end

    --加入发放 黑卡流程弹窗
    self._fsm:GetCurState():DoCommonState2Action(self._fsm,"CommonState3State" , function()
        self:PlayBoxOpenAnim()
    end)
end

function TournamentBlackGoldSettleRewardView:BlackCardSendTipFinish()
    Event.RemoveListener(NotifyName.Tournament.BlackCardSendTipFinish,self.BlackCardSendTipFinish,self)
    self._fsm:GetCurState():DoCommonState3Action(self._fsm,"CommonState4State" , function()
        self:FlyRewardToTopArea()
    end)
end

function TournamentBlackGoldSettleRewardView:GetItemOrderData(hasBlackCard , rewardNum)
    if hasBlackCard then
        return rewardItemOrderBlackCard[rewardNum]
    else
        return rewardItemOrder[rewardNum]
    end
end

function TournamentBlackGoldSettleRewardView:CheckHasBlackCardReward(reward)
    if not reward then
        return false
    end
    for k ,v in pairs(reward) do
        if fun.CheckIsAmazonCard(v.id) then
            return true , v.id
        end
    end
    return false
end

function TournamentBlackGoldSettleRewardView:SetItemInfo(index, itemInfo , obj)
    local item = itemView:New()
    item:SetReward(itemInfo)
    item:SkipLoadShow(obj)
    flyItemList[index] = 
    {
        itemInfo = itemInfo.id,
        obj = obj
    }
end

function TournamentBlackGoldSettleRewardView.OnResphoneRewardRequest()
    local rewards = ModelList.TournamentModel:GetTournamentRewardList()
    this:SetRewardData(rewards)
end

function TournamentBlackGoldSettleRewardView:RequestTournamentReward()
    -- AddLockCountOneStep()
    Event.AddListener(NotifyName.Tournament.ResphoneRewardRequest,self.OnResphoneRewardRequest,self)
    ModelList.TournamentModel:C2S_RequestTournamentRewardInfo()
end

function TournamentBlackGoldSettleRewardView.ReqWeekSettleError()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

this.NotifyList = 
{
    -- {notifyName = NotifyName.Tournament.ResphoneRewardRequest,func = this.OnResphoneRewardRequest}
    {notifyName = NotifyName.Tournament.ReqWeekSettleError,func = this.ReqWeekSettleError},

}

return this