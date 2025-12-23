

require "View/CommonView/RemainTimeCountDown"

local TournamentSettleTopPlayerView = BaseDialogView:New("TournamentSettleTopPlayerView","TournamentSettleTopPlayerAtlas")
local this = TournamentSettleTopPlayerView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "text_remainTime",
    "textTips",
    "player1",
    "player2",
    "player3",
    "btn_collect",
    "rewardList",
    "textRank",
    "imgTorphy",
    "rewards",
    "Content",
    "ScrollView",
    "bg",
    "moveDown",
    "btn_continue",
    "remainTime",
    "btn_box1",
    "btn_box2",
    "btn_box3",
    "title",

}

local flyItemList = {}
local isTopPlayer = false -- 是否是实际前三名 排序段位

function TournamentSettleTopPlayerView:Awake(obj)
    self:on_init()
end

function TournamentSettleTopPlayerView:OnEnable(params)
    AddLockCountOneStep(true)
    Event.Brocast(NotifyName.Tournament.ShowResultToCloseRankView)
    Facade.RegisterView(self)
    self:SetIsTopPlayer()
    self:SetTopPlayerUseToShow()
    self:StartCountDown()
    self:SetTopPlayerInfo()
    self:SetMyRewardInfo()
    self:SetMyTrophy()
    CommonState.BuildFsm(self,"TournamentSettleTopPlayerView")
    self:PlayEnterAnim()
    self:SetCollectInfo()
    self.textTips.text = Csv.GetDescription(997)
    self.title.text = Csv.GetDescription(1305)
    UISound.play("list_settlement") 
end

function TournamentSettleTopPlayerView:SetIsTopPlayer()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    if myRank > 3 then
        isTopPlayer = false
        return
    end

    local topPlayerInfo = ModelList.TournamentModel:GetTournamentResultTopPlayerData()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    isTopPlayer = false
    for k ,v in pairs(topPlayerInfo) do
        if v.uid == myUid then
            isTopPlayer = true
            break
        end
    end
end

function TournamentSettleTopPlayerView:PlayEnterAnim()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    local clipName = ""
    local motionName = ""
    if myRank <= 3 and isTopPlayer then
        clipName = "topstart"
        motionName= "TournamentSettleTopPlayerView_topstart"
    else
        clipName = "lowstart"
        motionName= "TournamentSettleTopPlayerView_lowstart"
    end
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{clipName,motionName},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonState2State", function()
                self:DelayShowRewardByRank()
            end)
        end)
    end)
end


function TournamentSettleTopPlayerView:OnDisable()
    AddLockCountOneStep(false)
    isTopPlayer = false
    flyItemList = {}
    self.topPlayerReward = {}
    Event.RemoveListener(NotifyName.Tournament.TopPlayerCollectRewardCloseView,self.TopPlayerCollectRewardCloseView,self)
    Event.Brocast(EventName.Event_popup_tournament_reward)
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function TournamentSettleTopPlayerView:DelayShowRewardByRank()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()

    if myRank <= 3 and isTopPlayer then
        self:UpdateTargetClickBoxBtnEnable(myRank, false)
        LuaTimer:SetDelayFunction(1, function()
            self._fsm:GetCurState():DoCommonState2Action(self._fsm,"CommonState3State" , function()
                self:OepnTopPlayerBox(myRank)
            end)
        end)
    else
        self._fsm:GetCurState():DoCommonState2Action(self._fsm,"CommonState3State" , function()
            LuaTimer:SetDelayFunction(1, function()
                fun.enable_button(self.btn_collect , true)
            end)
        end)
    end
end

function TournamentSettleTopPlayerView:StartCountDown()
    local nextOpenTime = ModelList.TournamentModel:GetTournamentResultNextOpenTime()
    if nextOpenTime <= 0 then
        fun.set_active(self.remainTime, false)
        return
    end
    if self.remainTimeCountDown == nil then
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,nextOpenTime,self.text_remainTime,function()
        fun.set_active(self.remainTime, false)
    end)
end

function TournamentSettleTopPlayerView:SetTopPlayerInfo()
    local topPlayerInfo = ModelList.TournamentModel:GetTournamentResultTopPlayerData()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    self.topRewardBoxList = {}
    for i = 1  , 3 do
        local playerObj = self["player" .. i]
        self:SetPlayerInfo(i ,topPlayerInfo[i] or nil ,  playerObj ,myRank )
    end
end

function TournamentSettleTopPlayerView:SetPlayerInfo(index , playerInfo, playerObj , myRank)
    if not playerInfo then
        return
    end
    local ref = fun.get_component(playerObj, fun.REFER)
    local head = ref:Get("head")
    local userName = ref:Get("userName")
    local textScore = ref:Get("textScore")
    local get = ref:Get("get")
    local rewardBox = ref:Get("rewardBox")
    local rewardBoxStart = ref:Get("rewardBoxStart")
    local imageFrame = ref:Get("imageFrame")
    self.topRewardBoxList[index] = rewardBox

    local model = ModelList.PlayerInfoSysModel

    local myUid = ModelList.PlayerInfoModel:GetUid()
    if myUid == tonumber(playerInfo.uid) then
        userName.text =  myUid
        model:LoadOwnHeadSprite(head)
        model:LoadOwnFrameSprite(imageFrame)
    else
        if playerInfo.robot == 0 then
            userName.text = playerInfo.nickname
        else
            userName.text =  Csv.GetData("robot_name", tonumber(playerInfo.uid), "name")
        end
        local useAvatarName = model:GetCheckAvatar(playerInfo.avatar , playerInfo.uid)
        model:LoadTargetHeadSpriteByName(useAvatarName ,head)
        local useFrameName = model:GetCheckFrame(playerInfo.frame , playerInfo.uid)
        model:LoadTargetFrameSpriteByName(useFrameName ,imageFrame)
    end
    textScore.text = fun.format_money(playerInfo. score)
    fun.set_active(get, myRank == index and isTopPlayer)
    self:ReBindRankImg(playerObj , index)
end


function TournamentSettleTopPlayerView:ReBindRankImg(playerObj , rank)
    if playerObj then
        local img =  fun.find_child(playerObj,"rank")
        if img then
            local icon = fun.get_component(img,fun.IMAGE)
            if icon then
                icon.sprite = AtlasManager:GetSpriteByName("TournamentSettleTopPlayerAtlas", "ZBNo"..rank)
            end
        end
    end
end

--排名在前三 放大背景 下移节点
function TournamentSettleTopPlayerView:SetViewNear()
    local nearVlaue = 1.3
    fun.set_gameobject_scale(self.bg ,nearVlaue,nearVlaue,nearVlaue)
    local farMoveDownPos = self.moveDown.transform.localPosition
    self.moveDown.transform.localPosition = Vector3.New(farMoveDownPos.x, farMoveDownPos.y - 65 , farMoveDownPos.z)
end

--排名在前三 放大背景 上移界面
function TournamentSettleTopPlayerView:SetViewFar()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    local nearVlaue = 1
    local farMoveDownPos = self.moveDown.transform.localPosition
    Anim.scale_to_xy(self.bg , nearVlaue, nearVlaue , 0.5 , function()
        self:SetCollectInfo()
    end)

    Anim.move_to_xy(self.moveDown ,farMoveDownPos.x,farMoveDownPos.y + 65, 0.3, function()
    end)
end

function TournamentSettleTopPlayerView:SetMyRewardInfo()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    if myRank <= 3 and isTopPlayer then
        fun.set_active(self.rewardList, false)
        return
    end
    fun.set_active(self.rewardList, true)
    local rewards = ModelList.TournamentModel:GetMyTournamentRewardItem()  --实际使用
    flyItemList = {}
    local view = require("View/CommonView/CollectRewardsItem")
    for k ,v in pairs(rewards) do
        local go = fun.get_instance(self.rewards,self.Content)
        local item = view:New()
        item:SkipLoadShow(go)
        item:SetReward(v)
        item:SkipLoadShow(go)
        fun.set_active(go.transform,true)
        flyItemList[k] = {
            itemInfo = v.id,
            obj = go
        }
    end
end

function TournamentSettleTopPlayerView:SetCollectInfo()
    local myRank = ModelList.TournamentModel:GetMyTournamentRank()
    if myRank <= 3 and isTopPlayer then
        fun.set_active(self.btn_collect , false)
        fun.set_active(self.rewardList , false)
        fun.set_active(self.textTips , true)
    else
        self.textRank.text = myRank
        fun.set_active(self.btn_collect, true)
        fun.set_active(self.rewardList , true)
        fun.set_active(self.textTips , false)
    end
end

function TournamentSettleTopPlayerView:SetMyTrophy()
    local tiers = ModelList.TournamentModel:GetMyTournamentTrophy()
    local trophyName = string.format("ZBjb0%s",tiers)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            self.imgTorphy.sprite = sprite
        end
    end)
end

function TournamentSettleTopPlayerView:TopPlayerCollectRewardCloseView()
    fun.set_active(self.btn_continue, true)
    local animBtnConeTinue = fun.get_component(self.btn_continue , fun.ANIMATOR)
    AnimatorPlayHelper.Play(animBtnConeTinue,{"start","btn_start"},false,function()
        self._fsm:GetCurState():DoCommonState3Action(self._fsm,"CommonState4State" , nil)
    end)
end

function TournamentSettleTopPlayerView:OepnTopPlayerBox(myRank)
    Event.AddListener(NotifyName.Tournament.TopPlayerCollectRewardCloseView,self.TopPlayerCollectRewardCloseView,self)
    local rewardBox = self:GetTopRewardBox(myRank)
    local startMovePos = rewardBox.transform.position
    Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentSettleRewardView , nil,false , {startMovePos = startMovePos , rewardBox = rewardBox})
end

function TournamentSettleTopPlayerView:on_btn_collect_click()
    self:UpdateClickBoxBtnEnable(false)
    self._fsm:GetCurState():DoCommonState3Action(self._fsm,"CommonState4State" , function()
        -- self:ResphoneRewardRequest() --测试用
        self:RequestTournamentReward()--实际使用
        LuaTimer:SetDelayFunction(3, function()
            self:DelayReturnState()
        end)
    end)
end

function TournamentSettleTopPlayerView:DelayReturnState()
    if self._fsm and self._fsm:GetCurState() then
        self:UpdateClickBoxBtnEnable(true)
        self._fsm:GetCurState():DoCommonState4Action(self._fsm,"CommonState3State" , function()
        end)
    end
end

function TournamentSettleTopPlayerView:ResphoneRewardRequest()
    local rewards = ModelList.TournamentModel:GetMyTournamentRewardItem()
    self:FlyRewardToTopArea()
end

function TournamentSettleTopPlayerView:FlyRewardToTopArea()
    LuaTimer:SetDelayFunction(1, function()
        for k , v in pairs(flyItemList) do
            local flyStartPos = v.obj.transform.position
            local flyitem = v.itemInfo
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,flyStartPos,flyitem, function()
                Event.Brocast(EventName.Event_currency_change)
                LuaTimer:SetDelayFunction(1, function()
                    self:PlayExit()
                end)
            end, nil, true)
        end
    end)
end

function TournamentSettleTopPlayerView:RequestTournamentReward()
    Event.AddListener(NotifyName.Tournament.ResphoneRewardRequest,self.ResphoneRewardRequest,self) --实际使用
    ModelList.TournamentModel:C2S_RequestTournamentRewardInfo()
end

function TournamentSettleTopPlayerView:GetTopRewardBox(rank)
    return self.topRewardBoxList[rank]
end

function TournamentSettleTopPlayerView:PlayExit()
    if not self or fun.is_null(self.anima) then
        Facade.SendNotification(NotifyName.CloseUI,self)
        return
    end
    AnimatorPlayHelper.Play(self.anima,{"end","TournamentSettleTopPlayerView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function TournamentSettleTopPlayerView:on_btn_continue_click()
    local animBtnConeTinue = fun.get_component(self.btn_continue , fun.ANIMATOR)
    self._fsm:GetCurState():DoCommonState4Action(self._fsm,"CommonState5State" , function()
        AnimatorPlayHelper.Play(animBtnConeTinue,{"end","btn_end"},false,function()
            self:PlayExit()
        end)
    end)
end

function TournamentSettleTopPlayerView:on_btn_box1_click()
    local pos = self.btn_box1.transform.position
    local offset = Vector3.New(0,-200 , 0)
    self:OpenTopPlayerRewardTip(1 ,offset, RewardShowTipOrientation.up, Vector2.New(0.5,0.5))
end

function TournamentSettleTopPlayerView:on_btn_box2_click()
    local offset = Vector3.New(-50, -100 , 0)
    self:OpenTopPlayerRewardTip(2 , offset,RewardShowTipOrientation.leftUp , Vector2.New(0,1))
end

function TournamentSettleTopPlayerView:on_btn_box3_click()
    local offset = Vector3.New(50, -100 , 0)
    self:OpenTopPlayerRewardTip(3 ,offset, RewardShowTipOrientation.rightUp, Vector2.New(1,1))
end

function TournamentSettleTopPlayerView:UpdateClickBoxBtnEnable(state)
    fun.enable_button(self.btn_box1 , state)
    fun.enable_button(self.btn_box2 , state)
    fun.enable_button(self.btn_box3 , state)
end

function TournamentSettleTopPlayerView:UpdateTargetClickBoxBtnEnable(index, state)
    fun.enable_button(self["btn_box" .. index] , state)
end

function TournamentSettleTopPlayerView:OpenTopPlayerRewardTip(index,offset , dir, pivot)
    local rewards = self:GetTopPlayerUseToShow(index)
    if not rewards then
        return
    end
    local btn = self["btn_box" .. index]
    local pos = btn.transform.position
    local rewardsNum = #rewards
    local params = {
        pivot = pivot,
        rewards = rewards, 
        bg_width = self:GetShowTipWidth(#rewards),
        pos = pos, 
        dir = dir, 
        offset = offset,
    }
    Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
end

--测试用
-- function TournamentSettleTopPlayerView:GetTestReward(rewards , type)
--     if not self.testClickList then
--         self.testClickList = {}
--     end
--     if not self.testClickList[type] then
--         self.testClickList[type] = 0
--     end
--     self.testClickList[type] =  self.testClickList[type] + 1
--     if  self.testClickList[type] == 7 then
--           self.testClickList[type] = 1
--     end
--     local rewardsT = {}
--     for i = 1 , self.testClickList[type] do
--         rewardsT[i] = rewards[1]
--     end
--     return rewardsT
-- end

function TournamentSettleTopPlayerView:SetTopPlayerUseToShow()
    self.topPlayerReward = {}
    local reward = ModelList.TournamentModel:GetTournamentResultTopPlayerData()
    local useReward = DeepCopy(reward)
    for k ,v in pairs(useReward) do
        self.topPlayerReward[k] = {}
        for z, w in pairs(v.reward) do
            table.insert(self.topPlayerReward[k] , {
                [1] = w.id,
                [2] = w.value
            })
        end
    end
end

function TournamentSettleTopPlayerView:GetTopPlayerUseToShow(rankIndex)
    if self.topPlayerReward and self.topPlayerReward[rankIndex] then
        return self.topPlayerReward[rankIndex]
    end
    return nil
end

function TournamentSettleTopPlayerView:GetShowTipWidth(rewardsNum)
    return (rewardsNum - 1) * 150 + 180
end


function TournamentSettleTopPlayerView.ReqWeekSettleError()
    --UIUtil.show_common_popup(8011,true)
    Facade.SendNotification(NotifyName.CloseUI, this)
end

this.NotifyList = 
{
    {notifyName = NotifyName.Tournament.ReqWeekSettleError,func = this.ReqWeekSettleError},

}

return this