--local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardOriginalState =require "View/ClaimRewardsView/ClaimRewardOriginalState"
local ClaimRewardEnterState =require "View/ClaimRewardsView/ClaimRewardEnterState"
local ClaimRewardGushState =require "View/ClaimRewardsView/ClaimRewardGushState"
local ClaimRewardObtainState =require "View/ClaimRewardsView/ClaimRewardObtainState"
local ClaimRewardStiffState =require "View/ClaimRewardsView/ClaimRewardStiffState"

local ClaimRewardsView = BaseView:New("ClaimRewardsView")
local this = ClaimRewardsView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "reward_1item1",
    "reward_2item1",
    "reward_2item2",
    "reward_3item1",
    "reward_3item2",
    "reward_3item3",
    "reward_4item1",
    "reward_4item2",
    "reward_4item3",
    "reward_4item4",
    "reward_5item1",
    "reward_5item2",
    "reward_5item3",
    "reward_5item4",
    "reward_5item5"
}

local rewards_item = nil
local click_callback = nil
local enter_animation = nil

local isInit = nil

local Input = UnityEngine.Input
local KeyCode = UnityEngine.KeyCode

local open_anima = nil

local cacheData = nil

function ClaimRewardsView:New(viewName, atlasName)
    local o = {viewName = viewName, atlasName = atlasName, isShow = false, isLoaded = false, changeSceneClear = true}
    self.__index = self
    setmetatable(o, self)
    return o
end

function ClaimRewardsView:Awake(obj)
    self:on_init()
end

function ClaimRewardsView:OnEnable(param)
    isInit = true
    self._promote_topconsole = param
    self:ShowRewards()
    self.update_x_enabled = true
    self:start_x_update()

    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm)
end

function ClaimRewardsView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        self._fsm:GetCurState():DoClick(self._fsm)
    end
end

function ClaimRewardsView:OnDisable()
    self:Close()
    self:DisposeFsm()
end

function ClaimRewardsView:on_close()
    rewards_item = nil
    click_callback = nil
    enter_animation = nil
    isInit = nil
    open_anima = nil
    cacheData = nil
    self._promote_topconsole = nil
end

function ClaimRewardsView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("ClaimRewardsView",self,{
        ClaimRewardOriginalState:New(),
        ClaimRewardEnterState:New(),
        ClaimRewardGushState:New(),
        ClaimRewardObtainState:New(),
        ClaimRewardStiffState:New()
    })
    self._fsm:StartFsm("ClaimRewardOriginalState")
end

function ClaimRewardsView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function ClaimRewardsView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,enter_animation,false,function()
        self._fsm:GetCurState():Finish(self._fsm)
    end)
end

function ClaimRewardsView:PlayGush()
    AnimatorPlayHelper.Play(self.anima,open_anima,false,function()
        self._fsm:GetCurState():Finish(self._fsm)
    end)
end

function ClaimRewardsView:GetExitAnimaName()
    return {"exit","efPuzzleClaimexit"}
end

function ClaimRewardsView:ObtainReward()
    if click_callback then
        local delay = 0
        local coroutine_fun = nil
        for key, value in pairs(cacheData) do
            coroutine_fun = function()
                delay = delay + 0.2
                coroutine.wait(delay)
                if not self:IsLifeStateDisable() then
                    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value.icon.transform.position,value.id,function()
                        Event.Brocast(EventName.Event_currency_change)
                    end,nil,self._promote_topconsole)
                end
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            if not self:IsLifeStateDisable() then
                AnimatorPlayHelper.Play(self.anima,self:GetExitAnimaName(),false,function()
                    click_callback()
                    click_callback = nil
                    Facade.SendNotification(NotifyName.CloseUI,self)
                end)
            end
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
end

function ClaimRewardsView:SetRewards(rewards)
    rewards_item = rewards
    if isInit then
        self:ShowRewards()
    end
end

function ClaimRewardsView:SetCallBack(callback)
    click_callback = callback
end

function ClaimRewardsView:SetAnimation(anima)
    this.RewardAnimation = anima
    if anima == ClaimRewardAnimation.task then
        enter_animation = {"efPuzzleClaimenterrenwu","efPuzzleClaimenterrenwu"}
    elseif anima == ClaimRewardAnimation.food then
        enter_animation = {"entermeishi","efPuzzleClaimentermeishi"}
    elseif anima == ClaimRewardAnimation.puzzle then
        enter_animation = {"efPuzzleClaimenterpintu","efPuzzleClaimenterpintu"}
    elseif anima == ClaimRewardAnimation.puzzleStage then
        enter_animation = {"enter","efPuzzleBoxnter"}
    elseif anima == ClaimRewardAnimation.sevenDayLogin then
        enter_animation = {"enterforgot","enterforgot"}
    else
        enter_animation = {"enter","efPuzzleClaimenter"}    
    end
end

function ClaimRewardsView:GetOpenAnimaName(param)
    return string.format("efPuzzleClaimopen%s",param)
end


function ClaimRewardsView:ShowRewards()
    if rewards_item then
        cacheData = {}
        local count = #rewards_item
        open_anima = {string.format("open%s",count),self:GetOpenAnimaName(count)}
        for key, value in pairs(rewards_item) do
            local icon = Csv.GetItemOrResource(value[1] or value.id,"icon")
            local sp = self[string.format("reward_%sitem%s",count,key)]
            if icon and sp then
                table.insert(cacheData,{icon = sp,id = value[1] or value.id})
                Cache.SetImageSprite("ItemAtlas",icon,sp)
                local tex_obj = fun.find_child(sp,sp.transform.parent.name)
                local tex = fun.get_component(tex_obj,fun.TXTPRO)
                if tex then
                    local strvalue= fun.NumInsertComma(value[2] or value.value) --tostring(value[2] or value.value)
                    if  icon=="b_bingo_find" then
                        tex.text=strvalue.."s"
                    else
                        tex.text="x"..strvalue
                    end
                end
            end
        end
    end
end

return this