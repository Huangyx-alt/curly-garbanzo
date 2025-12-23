local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleOriginalState"
local TournamentSettleEnterState = require "State/TournamentSettle/TournamentSettleEnterState"
local TournamentSettleExiteState = require "State/TournamentSettle/TournamentSettleExiteState"
local TournamentSettleClimbRankState = require "State/TournamentSettle/TournamentSettleClimbRankState"
local TournamentSettleCheckTierState = require "State/TournamentSettle/TournamentSettleCheckTierState"

require "View/CommonView/RemainTimeCountDown"
local TournamentShowNextRewardView = require "View/Tournament/TournamentShowNextRewardView"

TournamentSettleView = TopBarControllerView:New("TournamentSettleView","TournamentAtlas")
local this = TournamentSettleView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local TournamentRankItem = require "View/Tournament/TournamentRankItem"
local TournamentMyRankItem = require "View/Tournament/TournamentMyRankItem"
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
    "text_refresh",
    "img_trophy",
    "anima",
    "scrollRect",
    "section1",
    "section2",
    "btn_speedUp",
    "nextTrophy",
    "nextRewards",
    "btn_OepnNextReward",
    "backgroundbei",
    "topOneRewardItem",
    "topOneItemList",
    "myNewRewardItem",
    "myNewRewardList",
    "btn_continue_rank",
    "TournamentSprintBuffFlag",
    "slotTicket",
    "ticketNum",
}

function TournamentSettleView:Awake(obj)
    self:on_init()
end

function TournamentSettleView:OnEnable(params)
    Facade.RegisterView(self)
    self:AddTopAreaEvent()
    self:BuildFsm()
    self:CheckShowTopArea()
    if params then
        self._exit_callback = params
    end

    rank_index = 1
    --ModelList.TournamentModel:SetTestData()
    self:InitRankItem()

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

function TournamentSettleView:ShowBuffEffect()
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

function TournamentSettleView:IsSelfHasSprintBuff()
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

function TournamentSettleView:OnDisable()
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
    ModelList.TournamentModel:CleartSettleInfo()
    self.myData = nil
end

function TournamentSettleView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentSettleView",self,{
        TournamentSettleOriginalState:New(),
        TournamentSettleEnterState:New(),
        TournamentSettleExiteState:New(),
        TournamentSettleClimbRankState:New(),
        TournamentSettleCheckTierState:New()
    })
    self._fsm:StartFsm("TournamentSettleOriginalState")
end

function TournamentSettleView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentSettleView:on_btn_continue_click()
    self._fsm:GetCurState():PlayExite(self._fsm)
end

function TournamentSettleView:CloseTopBarParent()
    self:on_btn_continue_click()
end

function TournamentSettleView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"in","TournamentSettleViewenter"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        self._fsm:GetCurState():StartClimb(self._fsm)
    end)
end

function TournamentSettleView:initSpeedUp()

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


function TournamentSettleView:on_btn_speedUp_click()
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

function TournamentSettleView:PlayExite()
    AnimatorPlayHelper.Play(self.anima,{"out","TournamentSettleViewexit"},false,function()
        if self._exit_callback then
            self._exit_callback()
        end
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function TournamentSettleView:playChangeTier()
    UISound.play("list_ascending")
    self:ShowNextTrophyFull()
    LuaTimer:SetDelayFunction(0.3, function()
        self:playChangeRoll()
    end)
end

function TournamentSettleView:playChangeRoll()
    LuaTimer:SetDelayFunction(1.5, function()
        rank_index = rank_index + 1
        if ModelList.TournamentModel:IsTrouamentClimbRank(rank_index) then  --需要这个
            self:InitRankItem()  --需要这个
        end
    end)

    fun.enable_button(self.btn_continue_rank,false)
    Event.AddListener(NotifyName.Tournament.ShowNewTierContinue,self.ShowNewTierContinue,self)
    self:ShowNextReward()
    
    AnimatorPlayHelper.Play(self.anima,{"change","TournamentSettleViewchange"},false,2,function()
    end,function()
        fun.enable_button(self.btn_continue_rank, true)
        self:AnimCloeNextTrophy()
        self:AnimRefreshNextReward()  --原来的
        self._fsm:GetCurState():ClimbNext(self._fsm)
        --这里加入奖励变更弹窗
        -- self._fsm:GetCurState():StartClimb(self._fsm) --原来的
    end)
end

function TournamentSettleView:ShowNextReward()
    TournamentShowNextRewardView:OnEnable({topOneRewardItem = self.topOneRewardItem,topOneItemList = self.topOneItemList,myNewRewardItem = self.myNewRewardItem,myNewRewardList = self.myNewRewardList,climbIndex = rank_index})
end

function TournamentSettleView:ShowNewTierContinue()
    if fun.is_not_null(self.anima) and self._fsm then
        AnimatorPlayHelper.Play(self.anima,{"changeexit","TournamentSettleViewchangeexit"},false,2,function()
        end,function()
            self._fsm:GetCurState():StartClimb(self._fsm)
            TournamentShowNextRewardView:OnDestroy()
        end)
    else
        TournamentShowNextRewardView:OnDestroy()
    end
end

--获取自身初始节点位置
function TournamentSettleView:GetTargetInitIndex(climbData , climbListData)
    local lastIndex = climbListData.lastSectionIndex
    local currentIndex = climbListData.mySectionIndex
    return lastIndex
end

function TournamentSettleView:InitRankItem()
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
                fun.set_active(go.transform,true)
            end
            myRankItem:SetRankData(climbData[i])
            self.myData = climbData[i]
            myRankItem:SetLayerIndex(0)
            fun.set_gameobject_pos(myRankItem.go,0,pos,0,true)
            pos = pos + itemHeight
        else
            if climbData[i].uid ~=  myUid then
                local item = nil
                if rankItemList[itemIndex] == nil then
                  
                    local go = fun.get_instance(this.rank_item1,this.rank_content)
                    item = TournamentRankItem:New(true)
                    item:SetParent(this)
                    item:SkipLoadShow(go)
                    fun.set_active(go.transform,true)
                    table.insert(rankItemList,item)
                else
                    item = rankItemList[itemIndex]
                end
                item:SetRankData(climbData[i])
                item:SetLayerIndex(0)
                fun.set_gameobject_pos(item.go,0,pos,0,true)
                itemIndex = itemIndex + 1
                pos = pos + itemHeight
            else
                log.log("周榜调整 跳过相同UID终点")
            end
        end
        -- pos = pos + itemHeight
    end
    --log.r("============================>> " .. #climbData .. "  " .. #rankItemList)
    for i = #climbData, #rankItemList,1 do
        fun.set_active(rankItemList[i].go.transform,false)
    end
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

function TournamentSettleView:SetTopReward(tiers,difficulty)
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
                    fun.set_active(go.transform,true)
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

function TournamentSettleView:StartClimb()
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

function TournamentSettleView:FlyScore(callback)
    if myRankItem then
        myRankItem:FlyScore(callback,ModelList.TournamentModel:GetSettleClimbCurrentScore(rank_index))
    end
end

function TournamentSettleView:DoClimbRankItem()
    local myCurOrdertPos = 0
    local temOrder = 50000  --如果出现了后台数据正常 但是排名下降了 检查这个参数和列表中最低排名  至少不能超过这个
    local myCurOrder = ModelList.TournamentModel:GetSettleClimbCurrentOrder(rank_index)
    local mypreviousOrder = ModelList.TournamentModel:GetSettleClimbPreviousOrder(rank_index)
    local myPreOrderPos = myRankItem:GetPosY()
    local temPos = 100000
    local myPreOrderTop1Item = nil
    local rankItemCount = 0
    for index, value in ipairs(rankItemList) do
        local order = value:GetOrder()
        if myCurOrder <= order and order <= temOrder then
            temOrder = order
            myCurOrdertPos = value:GetPosY()
        end
        local pos = value:GetPosY()
        if pos > myPreOrderPos and pos < temPos then
            myPreOrderTop1Item = value
            temPos = pos
        end
        rankItemCount = rankItemCount + 1
    end
    local topItemPos = 0
    temPos = myPreOrderTop1Item:GetPosY()
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
            myRankItem:SetRankData(nil,rank_index)
            myRankItem:FadeOutLightEffect()
            self._fsm:GetCurState():ClimbNext(self._fsm)
            UISound.play("rank_determine")
        end
    end
    local movePos = math.max(0,topItemPos - itemHeight * 4)
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
                value:ChangeOrder(mypreviousOrder,myCurOrder)
            end
            callback()
        end)

        if myPreOrderPos < itemHeight - 10 then
            Anim.move_ease(myRankItem.go,0,itemHeight,0,0.5,true,DG.Tweening.Ease.InOutFlash,function()
                Invoke(function()
                    callbackCount = callbackCount + 1
                    Anim.move_ease(myRankItem.go,0,myCurOrdertPos - movePos,0,duration - 0.5,true,DG.Tweening.Ease.InOutFlash,callback)
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
            myRankItem:SetOrderDataOnly(score)
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
                value:ChangeOrder(mypreviousOrder,myCurOrder)
            end
            callback()
        end)

        callbackCount = callbackCount + 1
        Anim.move_ease(myRankItem.go,0,myCurOrdertPos - movePos,0,duration,true,DG.Tweening.Ease.InOutFlash,callback) 
        myRankItem:DoSmoothRankOrderNum(myCurOrder,duration + 0.2,DG.Tweening.Ease.InOutFlash,function(score)
            myRankItem:SetOrderDataOnly(score)
            self.slider_tournament.value =  1 - score / maxSection
        end,nil)
    end

    UISound.play("rank_rise")
end

function TournamentSettleView:ShowContinuButton()
    if self.btn_continue then
        fun.set_active(self.btn_continue.transform,true)
        self._fsm:GetCurState():ClimbNext(self._fsm)
    end
    for key, value in pairs(rankItemList) do
        if value:GetPosY() < 0 then
            value:Close()
        end
    end
    self.scrollRect.enabled = true
end

function TournamentSettleView:ClimbStage2()
    if ModelList.TournamentModel:IsChangeTier(rank_index) then
        self:playChangeTier()
    else
        self:ShowContinuButton()
        self:CheckAnimEndToTopOne()
    end
end

function TournamentSettleView.OnResphonePlayerInfo()
    this._fsm:GetCurState():OnShowPlayerInfo(this._fsm)
end

function TournamentSettleView:OnShowPlayerInfo()
    if ModelList.TournamentModel:GetPlayerInfo() then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentTrophyView)
    end
end

function TournamentSettleView:on_btn_help_click()
    self._fsm:GetCurState():ShowHelpView(self._fsm)
end

function TournamentSettleView:OnShowHelpView()
    Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentHelperView)
    -- Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentBlackGoldHelperView)

end

function TournamentSettleView:CheckIsMax()
    local model = ModelList.TournamentModel

    local myTiers = model:GetClimbTiers(rank_index)
    if model:CheckTargetMaxTrophy(myTiers) then
        return true
    end
    return false
end

function TournamentSettleView:OpenNextRankTrophyView()
    if nextTrophyView ~= nil then
        return
    end
    local model = ModelList.TournamentModel
    
    local nextScore = model:GetRankNextTiersNeedScore()
    if not nextScore or nextScore <= 0 then
        log.log("周榜兼容旧版 不展示下阶段")
        return
    end

    if self:CheckIsMax() then
        --满级不展示奖杯
        return
    end

    if not model:GetSettleClimbIsFirst(rank_index) then
        log.log("还不是第一名")
        return
    end
    
    local lastTiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
    log.log("周榜调整 展示下个经验值" , rank_index )

    local TournamentRankNextTrophy = require "View/Tournament/TournamentRankNextTrophy" 
    nextTrophyView = TournamentRankNextTrophy:New(lastTiers)
    nextTrophyView:SkipLoadShow(self.nextTrophy.gameObject)
end

function TournamentSettleView:OpenNextRankRewardView()
    if nextRewardView ~= nil then
        return
    end

    local model = ModelList.TournamentModel
    if self:CheckIsMax() then
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


function TournamentSettleView:RankClickNextRewardBtn()
    self:StopDelayAutonReward()
    self:AnimCloeNextReward()
end


function TournamentSettleView:AddTopAreaEvent()
    Event.AddListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)

end

function TournamentSettleView:RemoveTopAreaEvent()
    Event.RemoveListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)

end

function TournamentSettleView:on_btn_OepnNextReward_click()
   self:AnimOpenNextReward()
end

function TournamentSettleView:AnimOpenNextReward()
    self:OpenNextRankRewardView()
    if nextRewardView then
        nextRewardView:AnimOpenView()
    end
end

function TournamentSettleView:AnimRefreshNextReward()
    self:OpenNextRankRewardView()
    if nextRewardView then
        local tiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
        nextRewardView:RefreshTiers(tiers)
        nextRewardView:AnimOpenView()
    end
end

function TournamentSettleView:AnimCloeNextReward()
    if nextRewardView then
        nextRewardView:AnimCloseView()
    end
end

function TournamentSettleView:AnimOpenNextTrophy()
    self:OpenNextRankTrophyView()
    if nextTrophyView then
        nextTrophyView:AnimOpenView()
    end
end

function TournamentSettleView:RefreshNextTrophy()
    if nextTrophyView ~= nil then
        local lastTiers,difficulty = ModelList.TournamentModel:GetSettleClimbPreviousTier(rank_index)
        if nextTrophyView then
            nextTrophyView:RefreshNextTrophy(lastTiers)
            nextTrophyView:AnimOpenView()
        end
    else
        self:OpenNextRankTrophyView()
    end
end

function TournamentSettleView:AnimCloeNextTrophy()
    if nextTrophyView then
        nextTrophyView:AnimCloseView()
    end
end

function TournamentSettleView:ShowNextTrophyFull()
    if nextTrophyView then
        self:RefreshNextTrophy()
        nextTrophyView:ShowNextTrophyFull()
    else
        self:OpenNextRankTrophyView()    
        if nextTrophyView then
            nextTrophyView:ShowNextTrophyFull()
        else
            log.log("周榜替换 没有原始的")
        end
    end
end


function TournamentSettleView:OepnNextTrophy()
    self:AnimOpenNextTrophy()
end


function TournamentSettleView:CheckShowTopArea()
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


function TournamentSettleView:StopDelayAutonReward()
    if self.autoDelayReward then
        LuaTimer:Remove(self.autoDelayReward)
        self.autoDelayReward = nil
    end
end

function TournamentSettleView.StopDelayAutonTrophy()
    if self.autoDelayTrophy then
        LuaTimer:Remove(self.autoDelayTrophy)
        self.autoDelayTrophy = nil
    end
end

function TournamentSettleView:AnimRefreshRankData()
    if nextTrophyView then
        nextTrophyView:AnimRefreshRankData()
    end
end

--滚动结束后 检查玩家升到了第一名
function TournamentSettleView:CheckAnimEndToTopOne()
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
function TournamentSettleView:UpdateShowNextTrophyScoreByIndex()
    ModelList.TournamentModel:UpdateShowNextTrophyScoreByIndex(rank_index)
end

--检查上次的排名和这次新排名有变化
function TournamentSettleView:CheckHasClimb(newRank)
    if lastMyRank and  newRank ~= lastMyRank then
        return true
    end
    return false
end

function TournamentSettleView:on_btn_continue_rank_click()
    fun.enable_button(self.btn_continue_rank,false)
	Event.Brocast(NotifyName.Tournament.ShowNewTierContinue)
    -- Facade.SendNotification(NotifyName.CloseUI,self)
end

function TournamentSettleView:CheckSoltSpin()
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