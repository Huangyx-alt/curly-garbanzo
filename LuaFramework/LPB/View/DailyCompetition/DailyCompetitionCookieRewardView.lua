

local CompetitionRewardEnter = require("State.Competition.RewardView.CompetitionRewardEnter")
local CompetitionRewardIdle = require("State.Competition.RewardView.CompetitionRewardIdle")
local CompetitionRewardReq = require("State.Competition.RewardView.CompetitionRewardReq")
local CompetitionRewardReward = require("State.Competition.RewardView.CompetitionRewardReward")


local DailyCompetitionCookieRewardView = BaseView:New("DailyCompetitionCookieRewardView","CompetitionCookieAtlas")
local this = DailyCompetitionCookieRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole


this.auto_bind_ui_items = {
    "btn_continue",
    "content",
    "singleRewarditem",
    "anima",
    "doubleRewarditem",
    "doubleFlag",
    "grid_layou",
}

local rewardData = nil
local rewardItemsCache = nil
local gift_time = 0
local isDoubleBuff = false
local maxCollectItem = 9
function DailyCompetitionCookieRewardView:Awake()
    self:on_init()
end

function DailyCompetitionCookieRewardView:OnEnable()
    self:RegisterEvent()
    self:BuildFsm()
    isDoubleBuff = false
    UISound.play("gift_pop_up")
    --self:SetInfo()
    --log.r("SetInfo")
end

function DailyCompetitionCookieRewardView:OnDisable()
    self:UnRegisterEvent()
end


function DailyCompetitionCookieRewardView:on_close()
    rewardData = nil
    rewardItemsCache = nil
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end


function DailyCompetitionCookieRewardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TopCompetitionRewardView",self,{
        CompetitionRewardEnter:New(),
        CompetitionRewardIdle:New(),
        CompetitionRewardReq:New(),
        CompetitionRewardReward:New(),
    })
    self._fsm:StartFsm("CompetitionRewardEnter")
end

function DailyCompetitionCookieRewardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function DailyCompetitionCookieRewardView:InitTimer()
end

function DailyCompetitionCookieRewardView:OnTimerCall()
end

function DailyCompetitionCookieRewardView:SetInfo()
    local buffTime = ModelList.CompetitionModel:GetDoubleRewardBuffTime()
    local hasDoubleReward = ModelList.CompetitionModel:HasDoubleUnclaimedRewards()
    isDoubleBuff = buffTime > 0 and true or false
    if buffTime > 0 then
        gift_time = buffTime
        self:OnTimerCall()
        self:InitTimer()
    end
    fun.set_active(self.doubleFlag,hasDoubleReward or isDoubleBuff)
    self:LoadReward(hasDoubleReward or isDoubleBuff)
end

function DailyCompetitionCookieRewardView:LoadReward(hasDoubleReward)
    if not rewardData then rewardData = ModelList.CompetitionModel:GetRoundReward() end
    if rewardItemsCache == nil then
        rewardItemsCache = {}
    end
    local collectNum = 0
    if rewardData and #rewardData >0 then
        local clone = nil
        local CompetitionRewardItem = require("View.DailyCompetition.CompetitionRewardItem")
        if hasDoubleReward then clone = self.doubleRewarditem
        else clone = self.singleRewarditem end
        for i = 1, #rewardData do
            local newReward =  fun.get_instance(clone,clone.transform.parent)
            local rewardItem = CompetitionRewardItem:New()
            rewardItem:SetReward(rewardData[i],hasDoubleReward)
            rewardItem:SkipLoadShow(newReward,true,nil)
            if rewardItemsCache[i] == nil and collectNum < maxCollectItem then
                table.insert(rewardItemsCache,rewardItem)
                collectNum = collectNum + 1
            end
        end
        self:SetRewardBigger(#rewardData <= 3)
    end
    if #rewardData >3 then
        local rect = fun.get_component(self.content,fun.RECT)
        rect.sizeDelta  = Vector2.New(920,self.grid_layou.cellSize.y* math.ceil(#rewardData/3) )
    end
end

--- 奖励数少于3个的，icon增大1.2
function DailyCompetitionCookieRewardView:SetRewardBigger(isLessThree)
    if isLessThree then
        if self.grid_layou then
            local ori = self.grid_layou.cellSize
            self.grid_layou.cellSize = Vector2.New(ori.x*1.15,ori.y*1.15)
        end
        for i = 1, #rewardItemsCache do
            rewardItemsCache[i]:SetBigger()
        end
    end
end


function DailyCompetitionCookieRewardView:ShowReward()
    local delay = 0
    local coroutine_fun = nil
    AddLockCountOneStep(true)
    for key, value in pairs(rewardItemsCache) do
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                Event.Brocast(EventName.Event_currency_change)
                AddLockCountOneStep(false)
            end)

            if key >= #rewardItemsCache then
                if ModelList.CompetitionModel:IsActivityAvailable() then
                    Event.Brocast(EventName.Event_popup_competition_finish)
                else
                    ModelList.CompetitionModel.ShowCompetitionHistoryRankInfo()
                end
            end

        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    coroutine_fun = function()
        delay = delay + 0.2
        coroutine.wait(delay)
        AnimatorPlayHelper.Play(self.anima,{"out","CookieRewardViewexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
            --if ModelList.CompetitionModel:IsActivityAvailable() then
            --    Event.Brocast(EventName.Event_popup_competition_finish)
            --else
            --    ModelList.CompetitionModel.ShowCompetitionHistoryRankInfo()
            --end
        end)

    end
    coroutine.resume(coroutine.create(coroutine_fun))

end

local click_interval = 0
function DailyCompetitionCookieRewardView:on_btn_continue_click()
    if os.time() - click_interval >= 2 then
        self._fsm:ChangeState("CompetitionRewardReq")
        click_interval = os.time()
    end

end


function DailyCompetitionCookieRewardView:GetReward(data)
    if data == RET.RET_SUCCESS then
        self._fsm:ChangeState("CompetitionRewardReward")
        Event.Brocast(EventName.Event_popup_competition_finish)
    else
        Facade.SendNotification(NotifyName.HideUI,self)
        Event.Brocast(EventName.Event_popup_competition_finish)
    end
    --Facade.SendNotification(NotifyName.HideUI,ViewList.CompetitionRewardView)
end

function DailyCompetitionCookieRewardView:BuffChange()
    local buffTime = ModelList.CompetitionModel:GetDoubleRewardBuffTime()
    fun.set_active(self.doubleFlag,buffTime>0 and true or false)
    if buffTime > 0 then
        gift_time = buffTime
        self:InitTimer()
        self:CheckChangeToDoubleCollect()
    end
end

--- 购买双倍buff后，奖励翻倍
function DailyCompetitionCookieRewardView:CheckChangeToDoubleCollect()
    if not isDoubleBuff then
        isDoubleBuff = true
        for i = 1, #rewardItemsCache do
            rewardItemsCache[i]:ChangeDouble()
        end
    end
end

--- 检查是否有双倍buff,
function DailyCompetitionCookieRewardView:CheckItemsDoubleEffect()
    if isDoubleBuff  or ModelList.CompetitionModel:HasDoubleUnclaimedRewards()  then
        for i = 1, #rewardItemsCache do
            rewardItemsCache[i]:ChangeDouble()
        end
    end
end


function DailyCompetitionCookieRewardView:RegisterEvent()
    --Event.AddListener(EventName.Event_show_topquick_task,self.GetReward,self)
    Event.AddListener(EventName.Event_competition_receive_reward,self.GetReward,self)
    Event.AddListener(EventName.Event_double_competition_reward_change,self.BuffChange,self)
    --Event.AddListener(EventName.Event_Check_Double_Activity,self.OnTaskUpdate,self)
end

function DailyCompetitionCookieRewardView:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_show_topquick_task,self.GetReward,self)
    Event.RemoveListener(EventName.Event_competition_receive_reward,self.GetReward,self)
    Event.RemoveListener(EventName.Event_double_competition_reward_change,self.BuffChange,self)
    -- Event.RemoveListener(EventName.Event_Check_Double_Activity,self.OnTaskUpdate,self)
end

return this







