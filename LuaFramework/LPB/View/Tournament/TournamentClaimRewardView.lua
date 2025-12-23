
local TournamentClaimRewardTier1State = require "State/TournamentClaimReward/TournamentClaimRewardTier1State"
local TournamentClaimRewardTier2State = require "State/TournamentClaimReward/TournamentClaimRewardTier2State"
local TournamentClaimRewardTier3State = require "State/TournamentClaimReward/TournamentClaimRewardTier3State"
local TournamentClaimRewardTier4State = require "State/TournamentClaimReward/TournamentClaimRewardTier4State"
local TournamentClaimRewardTier5State = require "State/TournamentClaimReward/TournamentClaimRewardTier5State"
local TournamentClaimRewardWaitBoxState = require "State/TournamentClaimReward/TournamentClaimRewardWaitBoxState"
local TournamentClaimRewardOpenBoxState = require "State/TournamentClaimReward/TournamentClaimRewardOpenBoxState"
local TournamentClaimRewardFlyRewardState = require "State/TournamentClaimReward/TournamentClaimRewardFlyRewardState"

local TournamentClaimRewardView = BaseView:New("TournamentClaimRewardView","TournamentAtlas")
local this = TournamentClaimRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local Input = UnityEngine.Input
local KeyCode = UnityEngine.KeyCode

local cacheData = nil

this.auto_bind_ui_items = {
    "anima",
    "item1_1",
    "item2_1",
    "item2_2",
    "item3_1",
    "item3_2",
    "item3_3",
    "item4_1",
    "item4_2",
    "item4_3",
    "item4_4",
    "item5_1",
    "item5_2",
    "item5_3",
    "item5_4",
    "item5_5",
    "text_rank",
    "img_trophy"
}

function TournamentClaimRewardView:Awake(obj)
    self:on_init()
end

function TournamentClaimRewardView:OnEnable(params)
    Facade.RegisterView(self)
    self:BuildFsm()

    local order = ModelList.TournamentModel:GetTournamentRewardOrder()
    local tier,difficulty = ModelList.TournamentModel:GetTournamentRewardTier()
    self.text_rank.text = tostring(order)

    local trophyName = fun.GetCurrTournamentActivityImg(tier)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            self.img_trophy.sprite = sprite
        end
    end)

    self.update_x_enabled = true
    self:start_x_update()

    UISound.play("list_reward")
end

function TournamentClaimRewardView:OnDisable()
    Facade.RemoveView(self)
    self:DisposeFsm()
    cacheData = nil
    Event.Brocast(EventName.Event_popup_tournament_reward)
end

function TournamentClaimRewardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentClaimRewardView",self,{
        TournamentClaimRewardTier1State:New(),
        TournamentClaimRewardTier2State:New(),
        TournamentClaimRewardTier3State:New(),
        TournamentClaimRewardTier4State:New(),
        TournamentClaimRewardTier5State:New(),
        TournamentClaimRewardWaitBoxState:New(),
        TournamentClaimRewardOpenBoxState:New(),
        TournamentClaimRewardFlyRewardState:New()
    })
    local tiers,difficulty = ModelList.TournamentModel:GetTournamentRewardTier()
    self._fsm:StartFsm(string.format("TournamentClaimRewardTier%sState",tiers))
end

function TournamentClaimRewardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentClaimRewardView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        self._fsm:GetCurState():DoClick(self._fsm)
    end
end

function TournamentClaimRewardView:PlayTier1Reward()
    AnimatorPlayHelper.Play(self.anima,{"enter01","Tournamentboxenter01"},false,function()
        self._fsm:GetCurState():Change2WaitForOpen(self._fsm,1)
    end)
end

function TournamentClaimRewardView:PlayTier2Reward()
    AnimatorPlayHelper.Play(self.anima,{"enter02","Tournamentboxenter02"},false,function()
        self._fsm:GetCurState():Change2WaitForOpen(self._fsm,2)
    end)
end

function TournamentClaimRewardView:PlayTier3Reward()
    AnimatorPlayHelper.Play(self.anima,{"enter03","Tournamentboxenter03"},false,function()
        self._fsm:GetCurState():Change2WaitForOpen(self._fsm,3)
    end)
end

function TournamentClaimRewardView:PlayTier4Reward()
    AnimatorPlayHelper.Play(self.anima,{"enter04","Tournamentboxenter04"},false,function()
        self._fsm:GetCurState():Change2WaitForOpen(self._fsm,4)
    end)
end

function TournamentClaimRewardView:PlayTier5Reward()
    AnimatorPlayHelper.Play(self.anima,{"enter05","Tournamentboxenter05"},false,function()
        self._fsm:GetCurState():Change2WaitForOpen(self._fsm,5)
    end)
end

function TournamentClaimRewardView:PlayOpenRewardBox(rewardCount)
    AnimatorPlayHelper.Play(self.anima,{string.format("open%s",rewardCount),string.format("Tournamentboxopen%s",rewardCount)},false,function()
        self._fsm:GetCurState():OpenRewardSucceed(self._fsm)
    end)
end

function TournamentClaimRewardView:PlayExit()
    AnimatorPlayHelper.Play(self.anima,{"exit","Tournamentboxexit"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function TournamentClaimRewardView:RequestTournamentReward()
    AddLockCountOneStep()
    ModelList.TournamentModel:C2S_RequestTournamentRewardInfo()
end

function TournamentClaimRewardView.OnResphoneRewardRequest()
    local rewards = ModelList.TournamentModel:GetTournamentRewardList() --[[or  {{id = 1,value = 23},{id = 2,value = 23}}--]]
    if rewards then
        cacheData = {}
        local reward_index = 1
        local count = math.max(1,#rewards)
        for i = 1, count do
            local icon = Csv.GetData("resources",rewards[reward_index].id,"icon")
            local sp = this[string.format("item%s_%s",count,i)]
            table.insert(cacheData,{icon = sp,id = rewards[reward_index].id})
            Cache.SetImageSprite("ItemAtlas",icon,sp)
            local tex_obj = fun.find_child(sp,sp.transform.parent.name)
            local txtpro = fun.get_component(tex_obj,fun.TXTPRO)
            if txtpro then
                local strvalue = fun.NumInsertComma(rewards[reward_index].value)
                txtpro.text="x"..strvalue
            end
            reward_index = reward_index + 1
        end
        this._fsm:GetCurState():OpenRewardBox(this._fsm,count)
    else
        this:PlayExit()
    end
end

function TournamentClaimRewardView:FlyReward()
    local delay = 0
    local coroutine_fun = nil
    for key, value in pairs(cacheData) do
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value.icon.transform.position,value.id,function()
                Event.Brocast(EventName.Event_currency_change)
            end,nil,self._promote_topconsole)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    coroutine_fun = function()
        delay = delay + 0.2
        coroutine.wait(delay)
        self:PlayExit()
    end
    coroutine.resume(coroutine.create(coroutine_fun))
end

this.NotifyList = {
    {notifyName = NotifyName.Tournament.ResphoneRewardRequest,func = this.OnResphoneRewardRequest}
}

return this