local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"

local FunctionIconMiniGameView = FunctionIconBaseView:New()
local this = FunctionIconMiniGameView
this.viewType = CanvasSortingOrderManager.LayerType.None

local remainTimeCountDown = RemainTimeCountDown:New()
local remainTimeCountDownDoubleReward = RemainTimeCountDown:New()
local click_gap = nil

this.auto_bind_ui_items = {
    "anima",
    "slider",
    "miniExtra",
    "img_double",
    "btn_icon",
    "btn_booth",
    "btn_collect",
    "text_collect",
    "text_extra",
    "text_remainTime",
    "show",
    "Background",
    "text_remainTime_double_reward",
}

function FunctionIconMiniGameView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconMiniGameView:Awake()
    self:on_init()
end

function FunctionIconMiniGameView:OnEnable()
    self:OnMiniGameUpdateInfo()
    Event.AddListener(NotifyName.MiniGame01.MiniGameUpdateInfo,self.OnMiniGameUpdateInfo,self)
    Event.AddListener(EventName.Event_doublehatreward_change,self.OnDoubleHatChange,self)
    Event.AddListener(EventName.Event_doublehat_change,self.OnDoubleHatChange,self)
    self:AddPurchaseEvent()
end

function FunctionIconMiniGameView:OnDisable()
    click_gap = nil
    remainTimeCountDown:StopCountDown()
    remainTimeCountDownDoubleReward:StopCountDown()
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameUpdateInfo,self.OnMiniGameUpdateInfo,self)
    Event.RemoveListener(EventName.Event_doublehatreward_change,self.OnDoubleHatChange,self)
    Event.RemoveListener(EventName.Event_doublehat_change,self.OnDoubleHatChange,self)
    self:RemovePurchaseEvent()
end

function FunctionIconMiniGameView:OnMiniGameUpdateInfo()
    local doublehat = ModelList.ItemModel:get_doublehat()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 and doublehat > 0 then
        --双倍帽子和双倍奖励 都有
        self:ShowHatImage("MiniZDhat4")
        self:ShowHatBg("MiniZDhat5")
        fun.set_active(self.img_double.transform,true)
        fun.set_active(self.text_remainTime.transform.parent,true)
        remainTimeCountDown:StartCountDown(CountDownType.cdt2,doublehat,self.text_remainTime,function()
            self:OnMiniGameUpdateInfo()
        end)

        remainTimeCountDownDoubleReward:StartCountDown(CountDownType.cdt2,doubleReward,self.text_remainTime_double_reward,function()
            self:OnMiniGameUpdateInfo()
        end)
    elseif doubleReward > 0 and doublehat <= 0 then
        --只有双倍奖励
        self:ShowHatImage("MiniZDhat4")
        self:ShowHatBg("MiniZDhat5")
        fun.set_active(self.img_double.transform,false)
        fun.set_active(self.text_remainTime.transform.parent,false)
        remainTimeCountDownDoubleReward:StartCountDown(CountDownType.cdt2,doubleReward,self.text_remainTime_double_reward,function()
            self:OnMiniGameUpdateInfo()
        end)
    elseif doubleReward <= 0 and doublehat > 0  then
        --只有双倍帽子
        self:ShowHatImage("MiniZDhat2")
        self:ShowHatBg("MiniZDhat3")
        fun.set_active(self.img_double.transform,true)
        fun.set_active(self.text_remainTime.transform.parent,true)
        remainTimeCountDown:StartCountDown(CountDownType.cdt2,doublehat,self.text_remainTime,function()
            self:OnMiniGameUpdateInfo()
        end)
    else
        --没有任何buff
        self:ShowHatImage("MiniZDhat2")
        self:ShowHatBg("MiniZDhat3")
        fun.set_active(self.img_double.transform,false)
        fun.set_active(self.text_remainTime.transform.parent,false)
    end
    local minigameInfo = ModelList.MiniGameModel:GetMiniGameInfo(1)
    if minigameInfo then
        local percent = minigameInfo.progress / minigameInfo.target
        self.slider.value = math.min(1,percent)
        self.text_collect.text = string.format("%s%s",math.floor(math.min(100,percent * 100)), "%")
        fun.set_active(self.miniExtra.transform,percent  > 1 )
        if percent >= 1 then
            self.text_extra.text = string.format("EXTRA\n%s%s", math.floor((percent - 1) * 100  + 0.4), "%")
            fun.set_active(self.btn_collect.transform, true)
            fun.set_active(self.btn_booth.transform,false)
        else
            fun.set_active(self.btn_collect.transform, false)
            fun.set_active(self.miniExtra.transform,false)
            fun.set_active(self.btn_booth.transform,doublehat <= 0)
        end
    else
        fun.set_active(self.miniExtra.transform,false)
    end
end

function FunctionIconMiniGameView:OnDoubleHatChange()
    self:OnMiniGameUpdateInfo()
end

function FunctionIconMiniGameView:IsFunctionOpen()
    local minigameInfo = ModelList.MiniGameModel:GetMiniGameInfo(1)
    if minigameInfo then
        return true
    end
    return false
end

function FunctionIconMiniGameView:on_btn_icon_click()
    local minigameInfo = ModelList.MiniGameModel:GetMiniGameInfo(1)
    if minigameInfo then
        if minigameInfo.complete then
            self:on_btn_collect_click()
        else
            self:on_btn_booth_click()
        end
    end
end

function FunctionIconMiniGameView:on_btn_booth_click()
    if os.time() - (click_gap or 0) >= 2 then
        click_gap = os.time()
        require("MiniGame/MiniGame01/MiniGameEntrance")
        MiniGameEntrance:ShowHatBoost()
    end
end

function FunctionIconMiniGameView:on_btn_collect_click()
    if os.time() - (click_gap or 0) >= 2 then
        click_gap = os.time()
        require("MiniGame/MiniGame01/MiniGameEntrance")
        MiniGameEntrance:SartMiniGame()
    end
end



function FunctionIconMiniGameView:AddPurchaseEvent()
    Event.AddListener(NotifyName.MiniGame01.LobbyPurchaseFlyHatIconToLobby,self.OnFlyHatIcon,self)
    Event.AddListener(NotifyName.MiniGame01.LobbyPurchaseFlyDoubleRewardIcon,self.OnFlyDoubleRewardIcon,self)
end

function FunctionIconMiniGameView:RemovePurchaseEvent()
    Event.RemoveListener(NotifyName.MiniGame01.LobbyPurchaseFlyHatIconToLobby,self.OnFlyHatIcon,self)
    Event.RemoveListener(NotifyName.MiniGame01.LobbyPurchaseFlyDoubleRewardIcon,self.OnFlyDoubleRewardIcon,self)
end


local scaleFirstValue = 0.9
local scaleFirstTime = 0.1

local scaleSecondValue = 0.5
local scaleSecondTime = 0.3

local scaleThirdValue = 0.1
local scaleThirdTime = 0.2

local bezierUseTime = 0.6

function FunctionIconMiniGameView:OnFlyHatIcon(flyObj, callBack)
    self:CommonFlyPurchaseIcon(flyObj , callBack , function()
        self:OnMiniGameUpdateInfo()
    end)
end

function FunctionIconMiniGameView:OnFlyDoubleRewardIcon(flyObj, callBack)
    self:CommonFlyPurchaseIcon(flyObj , callBack , function()
        self:OnMiniGameUpdateInfo()
    end)
end

function FunctionIconMiniGameView:CommonFlyPurchaseIcon(flyObj, callBack, myCallBack)
    local endPos = self.btn_icon.transform.position
    local scale = scaleFirstValue
    Anim.scale_to_xy(flyObj,scale,scale, scaleFirstTime , function()
        scale = scaleSecondValue
        Anim.scale_to_xy(flyObj,scale,scale, scaleSecondTime , function()
            scale = scaleThirdValue
            Anim.scale_to_xy(flyObj,scale,scale, scaleThirdTime)
        end)
    end)

    local path = {}
    local startPosition = flyObj.transform.position
    path[1] = fun.calc_new_position_between(startPosition, endPos, 0, 1, 0)
    path[2] = endPos
    fun.set_active(self.show, false)
    Anim.bezier_move(flyObj,path, bezierUseTime,0,1,2,function()
        if callBack then
            callBack()
        end
        if myCallBack then
            myCallBack()
        end
        fun.set_active(self.show, true)

        LuaTimer:SetDelayFunction(0.5, function()
            fun.set_active(self.show, false)
        end)
    end)
end

function FunctionIconMiniGameView:ShowHatImage(stringHatName)
    local imageHat = fun.get_component(self.btn_icon , fun.IMAGE)
    Cache.GetSpriteByName("CommonAtlas",stringHatName,function(sprite)
        if sprite and imageHat and not fun.is_null(imageHat) then
            imageHat.sprite = sprite
        end
    end)
end

function FunctionIconMiniGameView:ShowHatBg(stringHatName)
    Cache.GetSpriteByName("CommonAtlas",stringHatName,function(sprite)
        if sprite and self.Background and not fun.is_null(self.Background) then
            self.Background.sprite = sprite
        end
    end)
end


return this