require "View/CommonView/WatchADUtility"

LobbyAdvertiseView = BaseView:New("LobbyAdvertiseView")
local this = LobbyAdvertiseView
this.viewType = CanvasSortingOrderManager.LayerType.None
--this.viewState = 0  --  1 金币进入
--this.animaName = ""
local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_HALL_COIN)

this.auto_bind_ui_items = {
    "gold",
    "diamond",
    "text_upto",
    "text_reward",
    "btn_LobbyAdvertise",
    "aniam"
}

function LobbyAdvertiseView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function LobbyAdvertiseView:OnEnable()
    self:RegisterAdEvent()
end

function LobbyAdvertiseView:OnDisable()
    if self.waitNext then
        LuaTimer:Remove(self.waitNext)
        self.waitNext = nil
    end
    self:RemoveAdEvent()
end

function LobbyAdvertiseView:OnDestroy()
    if self.waitNext then
        LuaTimer:Remove(self.waitNext)
        self.waitNext = nil
    end
    self:RemoveAdEvent()
    self:Close()
end

function LobbyAdvertiseView:PlayAnima(animaName)
    self.aniam:Play(animaName)
end

--this.lobbyAd = nil

function LobbyAdvertiseView:SetState(animaName, state, lobbyAd)
    --log.r("SetState " .. animaName)
    self.animaName = animaName
    self.viewState = state
    self.lobbyAd = lobbyAd
    self:SetText()
    if not fun.is_null( self.aniam) then
        self.aniam:Play(self.animaName)
    end
end

function LobbyAdvertiseView:CheckChange()
    local coinAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_COIN)
    local diamondAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    local hasCoinAd = this:HasCounat(coinAd)
    local hasDiamondAd = this:HasCounat(diamondAd)
    local waitNext = false
    if self.viewState == 1 and not hasCoinAd then
        if hasDiamondAd then
            self:SetState("Change_Gold", 2, diamondAd)
            waitNext = true
        else
            self:PlayExit()
        end
    elseif self.viewState == 2 and not hasDiamondAd then
        if hasCoinAd then
            self:SetState("Change_Diamond", 1, coinAd)
            waitNext = true
        else
            self:PlayExit()
        end
    end
end

function LobbyAdvertiseView:PlayNext()
    if self:IsLifeStateDisable() then
        return
    end 
    local coinAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_COIN)
    local diamondAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    local hasCoinAd = this:HasCounat(coinAd)
    local hasDiamondAd = this:HasCounat(diamondAd)
    local waitNext = false
    if self.viewState == 1 then
        if hasDiamondAd then
            self:SetState("Change_Gold", 2, diamondAd)
            self:ChangeEvent(2)
            waitNext = true
        elseif not hasCoinAd then
            self:PlayExit()
        end
    else
        if hasCoinAd then
            self:SetState("Change_Diamond", 1, coinAd)
            self:ChangeEvent(1)
            waitNext = true
        elseif not hasDiamondAd then
            self:PlayExit()
        end
    end
    if self.waitNext then
        LuaTimer:Remove(self.waitNext)
        self.waitNext = nil
    end
    if waitNext then
        self.waitNext = LuaTimer:SetDelayFunction(5, function()
            self:PlayNext()
        end,nil,LuaTimer.TimerType.UI)
    end
end

function LobbyAdvertiseView:PlayExit()
    if self.waitNext then
        LuaTimer:Remove(self.waitNext)
        self.waitNext = nil
    end
    if self.lobbyAd then
        if self.lobbyAd.adType == AD_EVENTS.AD_EVENTS_HALL_COIN then
            self.aniam:Play("Gold_exit")
        else
            self.aniam:Play("Diamon_exit")
        end
    end
    self.lobbyAd = nil
    LuaTimer:SetDelayFunction(0.5, function()
        self:Hide()
    end)
end

function LobbyAdvertiseView:HasCounat(data)
    return (data and data.count > 0) or false
end

function LobbyAdvertiseView:ChangeEvent(type)
    if type == 1 then
        SDK.ADShow(AD_EVENTS.AD_EVENTS_HALL_COIN)
    else
        SDK.ADShow(AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    end
end

function LobbyAdvertiseView:PlayEnter()
    local coinAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_COIN)
    local diamondAd = ModelList.AdModel.GeSingletAdByEventType(AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    local hasCoinAd = this:HasCounat(coinAd)
    local hasDiamondAd = this:HasCounat(diamondAd)
    if hasCoinAd and hasDiamondAd then
        --随机一个进场
        local ran = math.random(1, 2)
        if ran == 1 then
            self:SetState("Gold_enter", 1, coinAd)
            self:ChangeEvent(1)
        else
            self:SetState("Diamond_enter", 2, diamondAd)
            self:ChangeEvent(2)
        end
    elseif hasCoinAd and not hasDiamondAd then
        --金币机场
        self:SetState("Gold_enter", 1, coinAd)
        self:ChangeEvent(1)
    elseif not hasCoinAd and hasDiamondAd then
        --钻石机场
        self:SetState("Diamond_enter", 2, diamondAd)  
        self:ChangeEvent(2)
    end
    if hasDiamondAd or  hasCoinAd then
        self.waitNext = LuaTimer:SetDelayFunction(5, function()
            self:PlayNext()
        end,nil,LuaTimer.TimerType.UI)
    else
        self:Hide()
        self.lobbyAd = nil
        if self.go then
            fun.set_active(self.go,false)
        end
    end
end

function LobbyAdvertiseView:SetText()
    if self.lobbyAd then
        local reward = Csv.GetData("advertise", (self.lobbyAd .event % 100) + 1, "reward")
        local frequency = Csv.GetData("advertise", (self.lobbyAd .event % 100) + 1, "frequency")
        if not self.text_reward or fun.is_null(self.text_reward) then
            if self.go then
                local tt = fun.find_child(self.go,"text_reward")
                if tt then
                    self.text_reward = fun.get_component(tt,"RollingNumberUGUI")
                end
            end
            if not self.diamond then
                local tt2 = fun.find_child(self.go,"diamond")
                if tt2 then
                    self.diamond = tt2.gameObject
                end
            end
        end
        if not fun.is_null(self.text_reward ) then
            if reward == nil or #reward<2 or frequency ==nil then  return end
            local com =  fun.get_component(self.text_reward,"RollingNumberUGUI")
            local newValue = reward[2] * frequency
            if self.text_reward ~= com then
                self.text_reward = com
            end
            if # tostring(newValue)  > 10 then newValue =  tonumber( string.sub(newValue,1,10) ) end
            if com then
                self.text_reward:SetValue(newValue)
            end
        end
    end
end

function LobbyAdvertiseView:CheckLobbyAdvertise()

    --如果是大r 
    local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()  --判断是否是大R用户
  
    if isBigR then --就隐藏按钮
        self:Hide() 
        return
    end 

    self:PlayEnter()
    if self.lobbyAd then
        self:SetText()
        self:Show()
        if not fun.is_null(self.aniam) then
            self.aniam:Play(self.animaName)
        end
    else
        self:Hide()
    end
end

function LobbyAdvertiseView:on_btn_LobbyAdvertise_click()
    if self.viewState == 1 then
        SDK.ADClick(AD_EVENTS.AD_EVENTS_HALL_COIN)
    else
        SDK.ADClick(AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    end
    if SDK then
        if SDK.IsRewardedAdReady() then 
            Facade.SendNotification(NotifyName.LobbyAdvertise.RequestWatchAd, self.viewState)
        else
            self:PlayExit()
        end
    end
end

function LobbyAdvertiseView:DoLobbyWatchAd()
    local lobbyAd = ModelList.AdModel.GetAdByEventType(AD_EVENTS.AD_EVENTS_HALL_COIN, AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
    if lobbyAd then
        _watchADUtility:ChangeAdEvent(lobbyAd.event)
        _watchADUtility:WatchVideo(self,nil,"LobbyAdvertiseView")
    end
end

function LobbyAdvertiseView:RegisterAdEvent()
    Event.AddListener(EventName.WatchLobbyAdPosReward,self.AdCallBack,self)
end

function LobbyAdvertiseView:RemoveAdEvent()
    Event.RemoveListener(EventName.WatchLobbyAdPosReward,self.AdCallBack)
end

function LobbyAdvertiseView:AdCallBack(data)
    if data then
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,data,function()
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide, ClaimRewardViewType.CollectReward)
            Event.Brocast(EventName.Event_currency_change)
            self:CheckChange()
        end)
    end
end