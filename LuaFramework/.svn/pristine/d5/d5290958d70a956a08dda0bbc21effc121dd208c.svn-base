local CompetitionQuestOpenBoxView = BaseDialogView:New('CompetitionQuestOpenBoxView')
local this = CompetitionQuestOpenBoxView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local clickFlag = true;

local delayTimerId = nil
this.auto_bind_ui_items = {
    "anima",
    "btn_collect",
    "btn_close",
    "otherRewardRoot",
    "rewardItem",
}

function CompetitionQuestOpenBoxView:Awake()
end
--[[
    type = 1 -- 阶段奖励 2 --赛季排名奖励
]]
function CompetitionQuestOpenBoxView:OnEnable(poptype)
    Facade.RegisterView(self)
    self.type = poptype 
    this:CleanTimer() 
    clickFlag = true
    UISound.play("racinglist")
end 


--赛车结束时才有
function CompetitionQuestOpenBoxView:SetRankRewardData()
    --收到结束时的奖励信息
    local racingdata = ModelList.CarQuestModel:GetRacingData()
    if racingdata == nil or racingdata.rankReward == nil then 
        return
    end 

    for _,v in pairs(racingdata.rankReward) do 
        local itemGrid = fun.get_instance(self.rewardItem , self.otherRewardRoot)
        itemGrid.name = tostring(v.id)
        self:SetItemGrid(v.id, v.value , itemGrid)
    end 

    local order = ModelList.CarQuestModel:GetRacingRankToporder()
    -- 判断是第几名，得奖励，然后在是弹对应得动画，不用在回调函数里去触发。
    
    if order == 1 then 
        if self.anima then 
            self.anima:Play("start3")
        end 
    elseif order == 2 then 
        if self.anima then 
            self.anima:Play("start2")
        end 
    elseif order == 3 then  
        if self.anima then 
            self.anima:Play("start1")
        end 
    else 
        if self.anima then 
            self.anima:Play("start0")
        end 
    end 
end 

--赛车阶段性奖励
function CompetitionQuestOpenBoxView:SetRankRewardDataNoEnd()
    local racingdata = ModelList.CarQuestModel:GetRacingData()
    if racingdata == nil or racingdata.roundReward == nil then 
        return
    end 

    for _,v in pairs(racingdata.roundReward) do 
        local itemGrid = fun.get_instance(self.rewardItem , self.otherRewardRoot)
        itemGrid.name = tostring(v.id)
        self:SetItemGrid(v.id, v.value , itemGrid)
    end 

    if self.anima then 
        self.anima:Play("start0")
    end 
end 

function CompetitionQuestOpenBoxView:SetItemGrid(itemId, itemNum , itemGrid)
    if not itemGrid then 
        return ;
    end 

    local refItem = fun.get_component(itemGrid , fun.REFER)
    local icon = refItem:Get("icon")
    local textNum = refItem:Get("textNum")
    local iconName = nil 
    if itemId == Resource.coin or itemId == Resource.diamon then 
        iconName = Csv.GetItemOrResource(itemId, "more_icon")
    else 
        iconName = Csv.GetItemOrResource(itemId, "icon")
    end 
  
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    if itemId == Resource.coin  then
        textNum.text = fun.format_reward({id = itemId, value = itemNum})
    else
        textNum.text = fun.format_money_reward({id = itemId, value = itemNum})
    end

    fun.set_active(itemGrid,true)
end


function CompetitionQuestOpenBoxView:on_after_bind_ref()
    if self.type  and self.type == 2 then 
        self:SetRankRewardData()
    else 
        self:SetRankRewardDataNoEnd()
    end 

end

function CompetitionQuestOpenBoxView:OnDisable()
    this:CleanTimer() 
    Facade.RemoveView(self)
end
--type = 2 结束时
function CompetitionQuestOpenBoxView:CloseSelf(type) 
    local racingdata = ModelList.CarQuestModel:GetRacingData()
    log.y("CompetitionQuestOpenBoxView:CloseSelf "..tostring(type))
    if type ==2 and  racingdata and racingdata.isOver == 1 and self.type == 2  then
        log.y("CompetitionQuestOpenBoxView:CloseSelf "..tostring(type))
        self:showGetRewardEffect(racingdata.rankReward)
        this:CleanTimer() 
        --绑定退场动画，然后退出 ，获取接口，是否弹a排行，还是b排行
        AnimatorPlayHelper.Play(self.anima,{"end","CompetitionQuestOpenBoxViewend"},false,function()
            log.y("CompetitionQuestOpenBoxView:CloseSelf "..tostring(ModelList.CarQuestModel:GetIsRacingRankTop()))
            if ModelList.CarQuestModel:GetIsRacingRankTop() then 
                Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestRankView)
            else 
                Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestRank2View)
            end 
            Facade.SendNotification(NotifyName.CloseUI, this)
        end)  
    elseif self.type == 1 then
        log.y("CompetitionQuestOpenBoxView:CloseSelf "..tostring(type))
        this:CleanTimer() 
     
        AnimatorPlayHelper.Play(self.anima,{"end","CompetitionQuestOpenBoxViewend"},false,function()
           
            Facade.SendNotification(NotifyName.CloseUI, this)
          
            LuaTimer:SetDelayFunction(1, function()
                Facade.SendNotification(NotifyName.CarQuest.ReceiveStageRewardFinish)
            end,nil,LuaTimer.TimerType.UI)
        end)
    else 
        log.r("errrrrrorrrrrrrrrrrrrrrorCompetitionQuestOpenBoxView:CloseSelfrrrrrrrrrorrrrrrrrrrrrr"..tostring(self.type))
    end 
end

function CompetitionQuestOpenBoxView:showGetRewardEffect(itemData)
    local i = 0
    for _,v in pairs(itemData) do 
        i = i + 1
        local item = fun.find_child(self.otherRewardRoot,tostring(v.id))
        if item then 
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,item.transform.position,v.id ,function()
                Event.Brocast(EventName.Event_currency_change)
                if ModelList.SeasonCardModel:IsCardPackage(v.id) then
                    ModelList.SeasonCardModel:OpenCardPackage({bagIds = {v.id}})
                end
            end,nil,i-1)
        end 
    end 
 
   
end 

function CompetitionQuestOpenBoxView:CloseFunc()
    if not clickFlag then 
        return 
    end 

    clickFlag = false
    this:CleanTimer() 

    if self.type == 1 then 
        local racingdata = ModelList.CarQuestModel:GetRacingData()
        self:showGetRewardEffect(racingdata.roundReward)

        ModelList.CarQuestModel.ReqRacingRoundReward()
       
        ---4秒后未返回自动关闭
        delayTimerId = LuaTimer:SetDelayFunction(5, function()
            --3秒没消息返回就结束了，要不可能会卡死主界面
          this:OnGetRoundReward()
        end,nil,LuaTimer.TimerType.UI)
    else
        this:CloseSelf(2)
    end 
end 

function CompetitionQuestOpenBoxView:on_btn_close_click()
    this:CloseFunc()
end

function CompetitionQuestOpenBoxView:on_btn_collect_click()
    this:CloseFunc()
end

function CompetitionQuestOpenBoxView:CleanTimer() 
    if delayTimerId then
        LuaTimer:Remove(delayTimerId)
        delayTimerId = nil
    end
end 

function  CompetitionQuestOpenBoxView:OnGetRoundReward()
    --是否结束，过如果结束，就重新开
    this:CloseSelf(1)
    log.r("CompetitionQuestOpenBoxView ==>OnGetRoundReward OnGetRoundReward")
end

--设置消息通知
this.NotifyList =
{
    {notifyName = NotifyName.CarQuest.GetRoundReward, func = this.OnGetRoundReward}
}

return this