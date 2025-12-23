local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleOriginalState"
local TournamentSettleEnterState = require "State/TournamentSettle/TournamentSettleEnterState"
local TournamentSettleExiteState = require "State/TournamentSettle/TournamentSettleExiteState"
local TournamentSettleClimbRankState = require "State/TournamentSettle/TournamentSettleClimbRankState"
local TournamentSettleCheckTierState = require "State/TournamentSettle/TournamentSettleCheckTierState"

require "View/CommonView/RemainTimeCountDown"
local TournamentShowNextRewardView = require "View/Tournament/TournamentShowNextRewardView"
local TournamentShowTopOneView = require "View/Tournament/TournamentShowTopOneView"

local topOneDownItem = nil  --第一名降低到第二名用的UI

local TournamentBlackGoldSettleView = TopBarControllerView:New("TournamentBlackGoldSettleView","TournamentAtlas")
local this = TournamentBlackGoldSettleView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local TournamentRankItem = require "View/Tournament/TournamentBlackGoldRankItem"
local TournamentMyRankItem = require "View/Tournament/TournamentBlackGoldMyRankItem"
local remainTimeCountDown = RemainTimeCountDown:New()

local rankItemList = nil

local myRankItem = nil

local topRewardCachItem = nil

local itemHeight = 145

local rank_index = 1

local maxSection = nil

local nextTrophyView = nil
local nextRewardView = nil

local lastMyRank = nil

this.auto_bind_ui_items = {
    "btn_help",
    "btn_continue",
    "reward_content",
    "reward_item",
    "rank_content",
    "rank_item1",
    "rank_item2",
    "slider_tournament",
    "text_countdown",
    "text_awards",
    "text_TopPercent",
    "text_thValue",
    "text_thSign",
    "img_trophy",
    "anima",
    "scrollRect",
    "section1",
    "section2",
    "btn_speedUp",
    "nextTrophy",
    "nextRewards",
    "ZBTiaomuDi",
    "btn_OepnNextReward",
    "topOneRewardItem",
    "topOneItemList",
    "myNewRewardItem",
    "myNewRewardList",
    "btn_continue_rank",
    "tournamentBlackGold",
    "btn_topOne",
    "TournamentGoldSettleViewShow",
    "btn_OepnNextRewardBlackGol",
    "TournamentSprintBuffFlag",
    "slotTicket",
    "ticketNum",
}

function TournamentBlackGoldSettleView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldSettleView:OnEnable(params)
    Facade.RegisterView(self)
    self.scrollRect.enabled = false
    self:AddTopAreaEvent()
    self:BuildFsm()
    self:CheckShowTopArea()
    if params then
        self._exit_callback = params
    end
    log.log("初始进入修改")
    rank_index = 1
    --ModelList.TournamentModel:SetTestData()
    self:InitRankItem()
    self:CheckShowTopPlayer()
    self._fsm:GetCurState():PlayEnter(self._fsm)
    this:initSpeedUp()
    remainTimeCountDown:StartCountDown(CountDownType.cdt1,
        ModelList.TournamentModel:GetRemainTime(),
        self.text_countdown,
    function()

    end)
    self:ShowBuffEffect()
    self:CheckSoltSpin()
end

function TournamentBlackGoldSettleView:ShowBuffEffect()
    local img1 = fun.find_child(self.go, "background/gift")
    local img2 = fun.find_child(self.go, "Tournamentgift")
    local enable = self:IsSelfHasSprintBuff()
    if not fun.is_null(img1) then
        fun.set_active(img1, enable)
    end

    if not fun.is_null(img2) then
        fun.set_active(img2, enable)
    end

    if enable then
        UISound.play("weekly_fireworks")
    end
end

function TournamentBlackGoldSettleView:IsSelfHasSprintBuff()
    --if true then return true end --test
    if not self.myData or not self.myData.buffs then
        return false
    end

    local sprintBuffIds = ModelList.TournamentModel:GetSprintBuffIds()
    for key, buffId in ipairs(sprintBuffIds) do
        for idx , buff in ipairs(self.myData.buffs) do
            if buff.id == buffId then
                return true
            end
        end
    end

    return false
end

function TournamentBlackGoldSettleView:CheckShowTopPlayer()
    if self:CheckIsBlackTier() then
        self:ShowTopOnePlayer()
    else
        fun.set_active(self.tournamentBlackGold, false)
    end
end

function TournamentBlackGoldSettleView:CheckIsBlackTier()
    local lastTier = ModelList.TournamentModel:GetClimbTiers(rank_index)
    if ModelList.TournamentModel:CheckIsBlackTire(lastTier) then
        return true
    else
        return false
    end
end

function TournamentBlackGoldSettleView:OnDisable()
    Facade.RemoveView(self)
    self:RemoveTopAreaEvent()
    self:DisposeFsm()
    rankItemList = nil
    myRankItem = nil
    topRewardCachItem = nil
    maxSection = nil
    self._exit_callback = nil
    nextRewardView = nil
    nextTrophyView = nil
    lastMyRank = nil
    remainTimeCountDown:StopCountDown()
    TournamentShowTopOneView:OnDestroy()
    ModelList.TournamentModel:CleartSettleInfo()
    topOneDownItem = nil
    self.myData = nil
end

function TournamentBlackGoldSettleView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentBlackGoldSettleView",self,{
        TournamentSettleOriginalState:New(),
        TournamentSettleEnterState:New(),
        TournamentSettleExiteState:New(),
        TournamentSettleClimbRankState:New(),
        TournamentSettleCheckTierState:New()
    })
    self._fsm:StartFsm("TournamentSettleOriginalState")
end

function TournamentBlackGoldSettleView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentBlackGoldSettleView:on_btn_continue_click()
    self._fsm:GetCurState():PlayExite(self._fsm)
end

function TournamentBlackGoldSettleView:CloseTopBarParent()
    self:on_btn_continue_click()
end

function TournamentBlackGoldSettleView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"in","TournamentBlackGoldSettleViewenter"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        self._fsm:GetCurState():StartClimb(self._fsm)
    end)
end

function TournamentBlackGoldSettleView:initSpeedUp()

    if ModelList.GuideModel.IsFirstBattle() then 
        fun.set_active(self.btn_speedUp,false)
        return 
    end 

    local flag = ViewList.GameSettleView:GetSpeedUp()
    local on = fun.find_child(self.btn_speedUp,"on")
    local off =  fun.find_child(self.btn_speedUp,"off")
    if flag == false then --加速状态
        fun.set_active(on,true)
        fun.set_active(off,false)
        ViewList.GameSettleView:SetSpeedUp(2)
    end 
end


function TournamentBlackGoldSettleView:on_btn_speedUp_click()
    local flag =  ViewList.GameSettleView:SpeedUp(2)
    local on = fun.find_child(self.btn_speedUp,"on")
    local off =  fun.find_child(self.btn_speedUp,"off")

    if flag then 
        fun.set_active(on,false)
        fun.set_active(off,true)
    else 
        fun.set_active(on,true)
        fun.set_active(off,false)
    end 
end

function TournamentBlackGoldSettleView:PlayExite()
    AnimatorPlayHelper.Play(self.anima,{"out","TournamentSettleViewexit"},false,function()
        if self._exit_callback then
            self._exit_callback()
        end
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function TournamentBlackGoldSettleView:playChangeTier()
    UISound.play("list_ascending")
    self:ShowNextTrophyFull()
    LuaTimer:SetDelayFunction(0.3, function()
        self:playChangeRoll()
    end)
end

function TournamentBlackGoldSettleView:playChangeRoll()
    LuaTimer:SetDelayFunction(1.5, function()
        rank_index = rank_index + 1
        if ModelList.TournamentModel:IsTrouamentClimbRank(rank_index) then  --需要这个
            for k ,v in pairs(rankItemList) do
                fun.set_active(rankItemList[k].go,false)
            end
            self:InitRankItem()  --需要这个
            self:HideTopTwoItem()
        end
    end)

    Event.AddListener(NotifyName.Tournament.ShowNewTierContinue,self.ShowNewTierContinue,self)
    self:ShowNextReward()
    fun.enable_button(self.btn_continue_rank,false)
    AnimatorPlayHelper.Play(self.anima,{"change","TournamentBlackGoldSettleViewchange"},false,2,function()
    end,function()
        fun.enable_button(self.btn_continue_rank,true)
        self:AnimCloeNextTrophy()
        self:AnimRefreshNextReward()
        self._fsm:GetCurState():ClimbNext(self._fsm)
        -- self._fsm:GetCurState():StartClimb(self._fsm) --替换到点击继续再走
    end)
end

function TournamentBlackGoldSettleView:ShowNextReward()
    TournamentShowNextRewardView:OnEnable({topOneRewardItem = self.topOneRewardItem,topOneItemList = self.topOneItemList,myNewRewardItem = self.myNewRewardItem,myNewRewardList = self.myNewRewardList,climbIndex = rank_index})
end

function TournamentBlackGoldSettleView:ShowNewTierContinue()
    AnimatorPlayHelper.Play(self.anima,{"changeexit","TournamentBlackGoldSettleViewexit"},false,2,function()
    end,function()
        self._fsm:GetCurState():StartClimb(self._fsm)
        TournamentShowNextRewardView:OnDestroy()
    end)
end

--获取自身初始节点位置
function TournamentBlackGoldSettleView:GetTargetInitIndex(climbData , climbListData)
    local lastIndex = climbListData.lastSectionIndex
    local currentIndex = climbListData.mySectionIndex
    return lastIndex
end

function TournamentBlackGoldSettleView:InitRankItem()
    local pos = 0
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local climbData = ModelList.TournamentModel:GetSettleClimbList(rank_index)
    local climbListData = ModelList.TournamentModel:GetSettleClimbData(rank_index)
    local startIndex = self:GetTargetInitIndex(climbData , climbListData)
    table.sort(climbData,function(a,b)
        return a.order < b.order
    end)
    rankItemList = rankItemList or {}
    myRankItem = myRankItem or nil
    local isBlackTier = self:CheckIsBlackTier()
    local itemIndex = 1
    local hasCreatOtherNum = 0
    for i = #climbData, 1,-1 do
        if myUid == climbData[i].uid and startIndex == climbData[i].order then
            if myRankItem == nil then
                lastMyRank = climbData[i].order
                local go = fun.get_instance(this.rank_item2,this.rank_content)
                myRankItem = TournamentMyRankItem:New(true)
                myRankItem:SetParent(this)
                myRankItem:SkipLoadShow(go)
                fun.set_active(go,true)
            end
            myRankItem:SetRankData(climbData[i] , isBlackTier)
            myRankItem:SetLayerIndex(0)
            --log.log("黑金 检查位置 自己" , pos , myRankItem.go.name)
            fun.set_gameobject_pos(myRankItem.go,0,pos,0,true)
            pos = pos + itemHeight

            myRankItem.go.name = "blackItemGrid " .. i
            self.myData = climbData[i]
        else
            if climbData[i].uid ~=  myUid then
                local item = nil
                if rankItemList[itemIndex] == nil then
                    local go = fun.get_instance(this.rank_item1,this.rank_content)
                    item = TournamentRankItem:New(true)
                    item:SetParent(this)
                    item:SkipLoadShow(go)
                    fun.set_active(go,true)
                    table.insert(rankItemList,item)
                else
                    item = rankItemList[itemIndex]
                    fun.set_active(item.go,true)
                end
                item:SetRankData(climbData[i] , isBlackTier)
                item:SetLayerIndex(0)
            --log.log("黑金 检查位置 other" , pos , item.go.name)
                fun.set_gameobject_pos(item.go,0,pos,0,true)
                itemIndex = itemIndex + 1
                pos = pos + itemHeight

            else
                self.myData = climbData[i]
                log.log("周榜调整 跳过相同UID终点")
            end
        end
        -- pos = pos + itemHeight
    end

    -- log.r("============================>> " .. #climbData .. "  " .. #rankItemList)
    -- local climbDataNum = #climbData
    -- local rankItemListNum = #rankItemList
    -- if climbDataNum ~= rankItemListNum then
    --     for i = climbDataNum, rankItemListNum,1 do
    --         fun.set_active(rankItemList[i].go.transform,false)
    --     end
    -- end
  
    local section = ModelList.TournamentModel:GetSection()
    if section then
        maxSection = section[3]
        this.section1.sizeDelta = Vector2.New(20,(section[2] / section[3]) * 726)
        this.section2.sizeDelta = Vector2.New(20,(section[1] / section[3]) * 726)
    end
    this.slider_tournament.value =  1 - ModelList.TournamentModel:GetSettleClimbPreviousOrder(rank_index) / maxSection
    local tiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
    self:SetTopReward(tiers,difficulty)
end

function TournamentBlackGoldSettleView:SetTopReward(tiers,difficulty)
    local useSection = ModelList.TournamentModel:GetUseSection()
    this.text_thValue.text = useSection * 0.1
    log.log("周榜调整 奖杯展示 " , tiers , difficulty)
    local view = require("View/CommonView/CollectRewardsItem")
    local csvData = ModelList.TournamentModel.GetTournamentCsvData()
    for index, value in ipairs(csvData) do
        if tiers == value.tiers_id and 
        difficulty == value.difficulty and 
        6 == value.ranking[1] then
            local cacheIndex = 1
            if not topRewardCachItem then
                topRewardCachItem = {}
            end
            for index, value2 in ipairs(value.reward) do
                local item = nil
                if topRewardCachItem[cacheIndex] then
                    item = topRewardCachItem[cacheIndex]
                else
                    item = view:New()
                    table.insert(topRewardCachItem,item)
                    local go = fun.get_instance(this.reward_item,this.reward_content)
                    item:SkipLoadShow(go)
                    fun.set_active(go,true)
                end
                item:SetReward(value2)
                cacheIndex = cacheIndex + 1
            end
            break
        end
    end

    local trophyName = fun.GetCurrTournamentActivityImg(tiers)
    log.log("周榜调整 奖杯展示名字 " , tiers , trophyName)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            this.img_trophy.sprite = sprite
        end
    end)
end

function TournamentBlackGoldSettleView:StartClimb()
    if ModelList.TournamentModel:IsClimbRank(rank_index)  then
        if myRankItem then
            self:FlyScore(function()
                myRankItem:LoadLightEffect(function()
                    self:DoClimbRankItem()
                end)
            end)
        end
    else
        self:FlyScore(function()
            self._fsm:GetCurState():ClimbNext(self._fsm)
        end)
    end
end

function TournamentBlackGoldSettleView:FlyScore(callback)
    local lastTier = ModelList.TournamentModel:GetClimbTiers(rank_index)
    local rank = ModelList.TournamentModel:GetSettleClimbPreviousOrder(rank_index)
    local myScore = ModelList.TournamentModel:GetSettleClimbCurrentScore(rank_index)
    if ModelList.TournamentModel:CheckIsBlackTire(lastTier) and rank == 1 then
        --是最高段位第一名 加积分就结束流程
        TournamentShowTopOneView:FlyScore(callback ,myScore )
        log.log("加积分结束流程")
    else
        if myRankItem then
            myRankItem:FlyScore(callback, myScore)
        end
    end

end

function TournamentBlackGoldSettleView:FinishClim(rankItem, index)
    myRankItem:SetRankData(nil)
    local myCurOrder = ModelList.TournamentModel:GetSettleClimbCurrentOrder(rank_index)
    if self:CheckIsBlackTier() and myCurOrder == 1 then
        myRankItem:FadeOutLightEffect(false)
    else
        myRankItem:FadeOutLightEffect(true)
    end

    self._fsm:GetCurState():ClimbNext(self._fsm)
    UISound.play("rank_determine")
end

function TournamentBlackGoldSettleView:ClimbTopOne(myRankItem, finishFunc)

    fun.set_active(self.TournamentGoldSettleViewShow, false)
    local topOnePos = fun.get_gameobject_pos(  self.TournamentGoldSettleViewShow)
    local downPos = fun.get_gameobject_pos( myRankItem)
    local downItem = self:GetEmptyRankItem()
    log.log("掉落数据检查" , downItem.go.name)
    downItem.transform.position = topOnePos

    local topOneData = self:GetFakeTopOneData()
    local isBlackTier = self:CheckIsBlackTier()
    downItem:TopOneDown(topOneData , isBlackTier)

    local myData = ModelList.TournamentModel:GetMyRankData(rank_index)
    Anim.move_ease(myRankItem.go,topOnePos.x,topOnePos.y,topOnePos.z,0.5,false,DG.Tweening.Ease.InOutFlash,function()
        if self:CheckIsBlackTier() then
            TournamentShowTopOneView:ClimbTopOne(myData)
            fun.set_active(self.TournamentGoldSettleViewShow, true)
        else
            fun.set_active(self.TournamentGoldSettleViewShow, false)
        end
        
    end)

    Anim.move_ease(downItem.go,downPos.x,downPos.y,downPos.z,0.5,false,DG.Tweening.Ease.InOutFlash,function()
        if finishFunc then
            Invoke(function()
                if finishFunc then
                    finishFunc()
                end
            end,1)   
        end
    end)
end

function TournamentBlackGoldSettleView:DoClimbRankToTop()
    self:ClimbTopOne(myRankItem, function()
        self:FinishClim(myRankItem , rank_index)
    end)
end

function TournamentBlackGoldSettleView:DoClimbRankItem()
    local myCurOrdertPos = 0
    local temOrder = 50000
    local myCurOrder = ModelList.TournamentModel:GetSettleClimbCurrentOrder(rank_index)
    local mypreviousOrder = ModelList.TournamentModel:GetSettleClimbPreviousOrder(rank_index)
    local lastTier = ModelList.TournamentModel:GetClimbTiers(rank_index)
    local myPreOrderPos = myRankItem:GetPosY()
    local temPos = 100000
    local myPreOrderTop1Item = nil
    local rankItemCount = 0

    if mypreviousOrder == 2 and self:CheckIsBlackTier() then
        --排名第二 直接替换第一位 不用其他动画 前提是玩家是黑榜
        self:DoClimbRankToTop()
        return
    end

    local isBlackTier = self:CheckIsBlackTier()
    for index, value in ipairs(rankItemList) do
        local order = value:GetOrder()
        if myCurOrder <= order and order <= temOrder then
            temOrder = order
            myCurOrdertPos = value:GetPosY() --我这次的目标位置
        end
        local pos = value:GetPosY()
        if pos > myPreOrderPos and pos < temPos then
            myPreOrderTop1Item = value
            temPos = pos
        end
        rankItemCount = rankItemCount + 1
    end
    local topItemPos = 0 --这几个item中最高位置
    temPos = myPreOrderTop1Item:GetPosY() --比我上次排名（移动前）高一个item的位置
    for key, value in pairs(rankItemList) do
        local posY = value:GetPosY()
        if posY > topItemPos then
            topItemPos = value:GetPosY()
        end
        if posY > myPreOrderPos then
            value:CachePosOffset(temPos - posY)
        else
            value:CachePosOffset(temPos -itemHeight - posY)
        end
    end
    local callbackCount = 0
    local callback = function()
        callbackCount = math.max(0,callbackCount - 1)
        if 0 == callbackCount then
            if self:CheckEnterTopOne(myCurOrder) and ModelList.TournamentModel:CheckIsBlackTire(lastTier) then
                --这里放第二名到第一名的变化内容
                self:ClimbTopOne(myRankItem, function()
                    self:FinishClim(myRankItem , rank_index)
                end)
            else
                self:FinishClim(myRankItem , rank_index)
            end
        end
    end
    local movePos = math.max(0,topItemPos - itemHeight * 4)--最高位置 - 4个item 如果小于0，则是0
    local move2Pos = temPos - movePos
    local duration = 1.25
    if rankItemCount > 15 then
        duration = 2.25
    end
    if myCurOrdertPos > itemHeight * 4 then
        callbackCount = callbackCount + 1
        Anim.move_ease_update(myPreOrderTop1Item.go,0, move2Pos - itemHeight,0,duration,true,DG.Tweening.Ease.InOutFlash,function()
            local temPos = myPreOrderTop1Item:GetPosY()
            for index, value in ipairs(rankItemList) do
                if value ~= myPreOrderTop1Item then
                    local posY = value:GetPosY()
                    if temPos > myPreOrderPos then
                        if posY > myPreOrderPos then
                            value:SetPosByOffset(temPos)
                        end
                    else
                        if temPos >= move2Pos then
                            value:SetPosByOffset(temPos)
                        elseif value:GetOrder() >= myCurOrder then
                            value:SetPosByOffset(temPos)
                        else
                            value:SetPosByOffset(math.max(temPos,move2Pos))
                        end
                    end
                end
            end
        end,function()
            for index, value in ipairs(rankItemList) do
                value:ChangeOrder(mypreviousOrder,myCurOrder,isBlackTier)
            end
            callback()
        end)

        if myPreOrderPos < itemHeight - 10 then
            Anim.move_ease(myRankItem.go,0,itemHeight,0,0.5,true,DG.Tweening.Ease.InOutFlash,function()
                Invoke(function()
                    callbackCount = callbackCount + 1
                    if myRankItem and fun.is_not_null(myRankItem.go) then
                        Anim.move_ease(myRankItem.go,0,myCurOrdertPos - movePos,0,duration - 0.5,true,DG.Tweening.Ease.InOutFlash,callback)
                    else
                        callback()
                    end
                end,0.25)   
            end)
        else
            Anim.move_ease(myRankItem.go,0,myPreOrderPos,0,0.5,true,DG.Tweening.Ease.InOutFlash,function()
                Invoke(function()
                    callbackCount = callbackCount + 1
                    Anim.move_ease(myRankItem.go,0,myCurOrdertPos - movePos,0,duration - 0.5,true,DG.Tweening.Ease.InOutFlash,callback)
                end,0.25)       
            end)
        end
        myRankItem:DoSmoothRankOrderNum(myCurOrder,duration + 0.2,DG.Tweening.Ease.InOutFlash,function(score)
            myRankItem:SetOrderDataOnly(score,isBlackTier)
            self.slider_tournament.value =  1 - score / maxSection
        end,nil)
    else
        Anim.move_ease_update(myPreOrderTop1Item.go,0, move2Pos - itemHeight,0,duration,true,DG.Tweening.Ease.InOutFlash,function()
            local temPos = myPreOrderTop1Item:GetPosY()
            for index, value in ipairs(rankItemList) do
                if value ~= myPreOrderTop1Item then
                    local posY = value:GetPosY()
                    if movePos > 10 and temPos > myPreOrderPos then
                        if posY > myPreOrderPos then
                            value:SetPosByOffset(temPos)
                        end
                    else
                        if temPos > move2Pos then
                            value:SetPosByOffset(temPos)
                        elseif movePos > 10 then
                            if value:GetOrder() >= myCurOrder then
                                value:SetPosByOffset(temPos)
                            end
                        elseif value:GetOrder() < mypreviousOrder and value:GetOrder() >= myCurOrder then
                            value:SetPosByOffset(temPos) 
                        end    
                    end
                end
            end
        end,function()
            for index, value in ipairs(rankItemList) do
                value:ChangeOrder(mypreviousOrder,myCurOrder,isBlackTier)
            end
            callback()
        end)

        callbackCount = callbackCount + 1
        Anim.move_ease(myRankItem.go,0,myCurOrdertPos - movePos,0,duration,true,DG.Tweening.Ease.InOutFlash,callback) 
        myRankItem:DoSmoothRankOrderNum(myCurOrder,duration + 0.2,DG.Tweening.Ease.InOutFlash,function(score)
            myRankItem:SetOrderDataOnly(score,isBlackTier)
            self.slider_tournament.value =  1 - score / maxSection
        end,nil)
    end

    UISound.play("rank_rise")
end

function TournamentBlackGoldSettleView:CheckEnterTopOne(myCurOrder)
    return myCurOrder == 1
end

function TournamentBlackGoldSettleView:ShowContinuButton()
    if self.btn_continue then
        fun.set_active(self.btn_continue,true)
        self._fsm:GetCurState():ClimbNext(self._fsm)
    end
    for key, value in pairs(rankItemList) do
        if value:GetPosY() < 0 then
            value:Close()
        end
    end
    -- self.scrollRect.enabled = true
end

function TournamentBlackGoldSettleView:ClimbStage2()
    if ModelList.TournamentModel:IsChangeTier(rank_index) then
        self:playChangeTier()
    else
        self:ShowContinuButton()
        self:CheckAnimEndToTopOne()
    end
end

function TournamentBlackGoldSettleView.OnResphonePlayerInfo()
    this._fsm:GetCurState():OnShowPlayerInfo(this._fsm)
end

function TournamentBlackGoldSettleView:OnShowPlayerInfo()
    if ModelList.TournamentModel:GetPlayerInfo() then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentTrophyView)
    end
end

function TournamentBlackGoldSettleView:on_btn_help_click()
    self._fsm:GetCurState():ShowHelpView(self._fsm)
end

function TournamentBlackGoldSettleView:OnShowHelpView()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentBlackGoldHelperView)
end

function TournamentBlackGoldSettleView:CheckIsMax()
    local model = ModelList.TournamentModel

    local myTiers = model:GetClimbTiers(rank_index)
    if model:CheckTargetMaxTrophy(myTiers) then
        return true
    end
    return false
end

function TournamentBlackGoldSettleView:OpenNextRankTrophyView()
    -- if nextTrophyView ~= nil then
    --     return
    -- end
    -- local model = ModelList.TournamentModel
    
    -- local nextScore = model:GetRankNextTiersNeedScore()
    -- if not nextScore or nextScore <= 0 then
    --     log.log("周榜兼容旧版 不展示下阶段")
    --     return
    -- end

    -- if self:CheckIsMax() then
    --     --满级不展示奖杯
    --     return
    -- end

    -- if not model:GetSettleClimbIsFirst(rank_index) then
    --     log.log("还不是第一名")
    --     return
    -- end
    
    -- local lastTiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
    -- log.log("周榜调整 展示下个经验值" , rank_index )

    -- local TournamentRankNextTrophy = require "View/Tournament/TournamentRankNextTrophy" 
    -- nextTrophyView = TournamentRankNextTrophy:New(lastTiers)
    -- nextTrophyView:SkipLoadShow(self.nextTrophy.gameObject)
end

function TournamentBlackGoldSettleView:OpenNextRankRewardView()
    if nextRewardView ~= nil then
        return
    end

    local model = ModelList.TournamentModel
    if self:CheckIsMax() then
        return
    end

    if model:CheckIsBlackGoldUser() and model:GetSettleClimbCurrentOrder(rank_index) == 1 then
        log.log("黑金用户第一名不展示下个阶段奖励"  , rank_index)
        return
    end

    local tiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
    if tiers <= 0 then
        return
    end
    local TournamentRankNextReward = require "View/Tournament/TournamentRankNextReward"
    nextRewardView = TournamentRankNextReward:New(tiers)
    nextRewardView:SkipLoadShow(self.nextRewards.gameObject)
end


function TournamentBlackGoldSettleView:RankClickNextRewardBtn()
    self:StopDelayAutonReward()
    self:AnimCloeNextReward()
end


function TournamentBlackGoldSettleView:AddTopAreaEvent()
    Event.AddListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)

end

function TournamentBlackGoldSettleView:RemoveTopAreaEvent()
    Event.RemoveListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)

end

function TournamentBlackGoldSettleView:on_btn_OepnNextReward_click()
   self:AnimOpenNextReward()
end

function TournamentBlackGoldSettleView:on_btn_OepnNextRewardBlackGol_click()
    self:AnimOpenNextReward()
end


function TournamentBlackGoldSettleView:AnimOpenNextReward()
    self:OpenNextRankRewardView()
    if nextRewardView then
        nextRewardView:AnimOpenView()
    end
end

function TournamentBlackGoldSettleView:AnimRefreshNextReward()
    self:OpenNextRankRewardView()
    if nextRewardView then
        local tiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
        nextRewardView:RefreshTiers(tiers)
        nextRewardView:AnimOpenView()
    end
end

function TournamentBlackGoldSettleView:AnimCloeNextReward()
    if nextRewardView then
        nextRewardView:AnimCloseView()
    end
end

function TournamentBlackGoldSettleView:AnimOpenNextTrophy()
    -- self:OpenNextRankTrophyView()
    -- if nextTrophyView then
    --     nextTrophyView:AnimOpenView()
    -- end
end

function TournamentBlackGoldSettleView:RefreshNextTrophy()
    -- if nextTrophyView ~= nil then
    --     local lastTiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
    --     if nextTrophyView then
    --         nextTrophyView:RefreshNextTrophy(lastTiers)
    --         nextTrophyView:AnimOpenView()
    --     end
    -- else
    --     self:OpenNextRankTrophyView()
    -- end
end

function TournamentBlackGoldSettleView:AnimCloeNextTrophy()
    -- if nextTrophyView then
    --     nextTrophyView:AnimCloseView()
    -- end
end

function TournamentBlackGoldSettleView:ShowNextTrophyFull()
    -- if nextTrophyView then
    --     self:RefreshNextTrophy()
    --     nextTrophyView:ShowNextTrophyFull()
    -- else
    --     self:OpenNextRankTrophyView()    
    --     if nextTrophyView then
    --         nextTrophyView:ShowNextTrophyFull()
    --     else
    --         log.log("周榜替换 没有原始的")
    --     end
    -- end
end


function TournamentBlackGoldSettleView:OepnNextTrophy()
    -- self:AnimOpenNextTrophy()
end


function TournamentBlackGoldSettleView:CheckShowTopArea()
    local model = ModelList.TournamentModel
    if self:CheckIsMax() then
        --最高段位
        return
    end

    local isFirst = model:GetRankIsFirst()
    if isFirst then
        self:OpenNextRankTrophyView()
    else
        --未达到第一名 只显示base reward
        -- self:OpenNextRankRewardView()
        -- self.autoDelayReward = LuaTimer:SetDelayFunction(3, function()
        --     self:AnimCloeNextReward()
        --     self:StopDelayAutonReward()
        -- end)
    end
end


function TournamentBlackGoldSettleView:StopDelayAutonReward()
    if self.autoDelayReward then
        LuaTimer:Remove(self.autoDelayReward)
        self.autoDelayReward = nil
    end
end

function TournamentBlackGoldSettleView.StopDelayAutonTrophy()
    if self.autoDelayTrophy then
        LuaTimer:Remove(self.autoDelayTrophy)
        self.autoDelayTrophy = nil
    end
end

function TournamentBlackGoldSettleView:AnimRefreshRankData()
    -- if nextTrophyView then
        -- nextTrophyView:AnimRefreshRankData()
    -- end
end

--滚动结束后 检查玩家升到了第一名
function TournamentBlackGoldSettleView:CheckAnimEndToTopOne()
    local myRank = ModelList.TournamentModel:GetChangeMyRank(rank_index)
    self:UpdateShowNextTrophyScoreByIndex()
    if myRank == 1 then
        if self:CheckHasClimb(myRank) then
            --通过积分变化 上升到了第一名
            self:RefreshNextTrophy()
        else
            --原本就在第一名 需要刷新积分
            self:AnimRefreshRankData()
        end
    else
        --还不是第一名 关闭奖杯
        self:AnimCloeNextTrophy()
        self:AnimRefreshNextReward()        
    end
end

--每经过一轮 替换model数据
function TournamentBlackGoldSettleView:UpdateShowNextTrophyScoreByIndex()
    ModelList.TournamentModel:UpdateShowNextTrophyScoreByIndex(rank_index)
end

--检查上次的排名和这次新排名有变化
function TournamentBlackGoldSettleView:CheckHasClimb(newRank)
    if lastMyRank and  newRank ~= lastMyRank then
        return true
    end
    return false
end

function TournamentBlackGoldSettleView:on_btn_continue_rank_click()
    if self:CheckIsBlackTier() then
        if TournamentShowTopOneView:IsBingUI() then
            local topOneData = self:GetTopOneData()
            TournamentShowTopOneView:ReplaceTopOne(topOneData)
        else
            self:ShowTopOnePlayer()
        end
    end
  
    fun.enable_button(self.btn_continue_rank,false)
	Event.Brocast(NotifyName.Tournament.ShowNewTierContinue)
end

function TournamentBlackGoldSettleView:ShowTopOnePlayer()
    fun.set_active(self.tournamentBlackGold, true)
    local topOneData = self:GetFakeTopOneData()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    if myUid == topOneData.uid then
        --第一名是自己 分数使用lastscore
        local lastScore = ModelList.TournamentModel:GetSettleClimbPreviousScore(rank_index)
        topOneData.score = lastScore
    end
    TournamentShowTopOneView:SetParent(self)
    TournamentShowTopOneView:OnEnable({topOneUi = self.tournamentBlackGold , topOneData = topOneData})
end

function TournamentBlackGoldSettleView:on_btn_topOne_click()
    self:RequestPlayerTournamentInfo()
end

function TournamentBlackGoldSettleView:RequestPlayerTournamentInfo()
    local topOneData = self:GetTopOneData()
    if not topOneData then
        log.r("错误缺少第一名玩家数据")
        return
    end
    local myUid = ModelList.PlayerInfoModel:GetUid()
    if topOneData.uid == myUid then
        log.log("自己是第一名不处理")
        return
    end
    if topOneData then
        ModelList.TournamentModel.C2S_RequestPlayerTournamentInfo(topOneData.uid,topOneData.robot)
    end
end

--从列表中拿出一个 作为第一名下降到第二名的UI
function TournamentBlackGoldSettleView:GetEmptyRankItem()
    if topOneDownItem then
        return topOneDownItem
    end

    local go = fun.get_instance(this.rank_item1,this.rank_content)
    topOneDownItem = TournamentRankItem:New(true)
    topOneDownItem:SkipLoadShow(go)
    fun.set_active(go,true)
    return topOneDownItem
end

--隐藏第二名
function TournamentBlackGoldSettleView:HideTopTwoItem()
    if topOneDownItem then
        topOneDownItem.transform.position = Vector3.New(10000,10000,0)
    end
end


function TournamentBlackGoldSettleView:GetTopOneData()
    local dt =  ModelList.TournamentModel:GetTrouamentClimbRankTopOneData(rank_index)
    return dt
end

function TournamentBlackGoldSettleView:GetFakeTopOneData()
    local dt =  ModelList.TournamentModel:GetTrouamentClimbRankFakeTopOneData(rank_index)
    if not dt or not dt.uid then
        return self:GetTopOneData()
    end
    return dt
end

function TournamentBlackGoldSettleView:CheckSoltSpin()
    fun.set_active(self.slotTicket, false)
    if not ModelList.PiggySloltsGameModel.CheckPiggySlotsGameExist() then
        return
    end

    local num = ModelList.PiggySloltsGameModel.GetBreakNum()
    if num and num > 0 then
        fun.set_active(self.slotTicket, true)
        if fun.is_not_null(self.ticketNum) then
            self.ticketNum.text = "x" .. tostring(num)
        end
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Tournament.ResphonePlayerInfo,func = this.OnResphonePlayerInfo}
}

return this