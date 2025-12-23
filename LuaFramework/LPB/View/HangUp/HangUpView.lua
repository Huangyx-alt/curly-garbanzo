--require("M1.MachineArtConfig")
require("View/Bingo/EffectPool/BattleEffectPool")
local BaseBingoView = require("View.Bingo.UIView.MainView.BaseBingoView")

---@class HangUpView : BaseBingoView
local HangUpView = BaseBingoView:New('HangUpView',"hangupatlas");
setmetatable(HangUpView,BaseBingoView)
local this = HangUpView;
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items = {
    "Bg",
    "winning",
    "RollBall",
    "Bingosi",
    "JackpotList",
    "ItemContainer",
    "Bingo",
    "box",
    "ef_Bingo_firework",
    "GoldRate",
    "DiamondRate",
    "powerup",
    "Gold",
    "Diamond",
    "btn_main",
    "Jackpot",
    "magnifier",
    "card4",
    "card8",
    "card12",
    "MapType",
    "click_tip_clone",
    "btn_speedup",
    "bottle",
    "btn_power",
    "Buff",
    "HangMap",
    "EffectContainer",
    "PowerUpContainer",
    "Card",
    "switchCard",
    "hangup_anima",
    "topLayer",
    "Right",
    "BingoSpawn",
}


function HangUpView:Awake()
    this:on_init()
    this:BaseAwake()
    this:InitCityBg()
end

function HangUpView:OnEnable()
    --this.__index.OnEnable(this)
    self:BaseEnable()
    ModelList.HangUpModel:SetModelView(this)
    --BattleEffectPool:CreateHangUpBattleEffect(this)
    --this.effectObjContainer = require("View.Bingo.UIView.OtherView.EffectObjContainer")
    --this.effectObjContainer:Init(this.EffectContainer)

    --this.cardView =  require("View.Bingo.UIView.CardView.HangUpCardView")
    --this:SetChildCardView(this.cardView, this, this.Bingosi, this.data.systemTime <= this.data.hintTime)

    --this.jackpotView =  require("View/HangUp/HangUpJackpotView")
    --this:SetChildJackpotView(this.jackpotView,this.JackpotList,this.data.jackpotRuleId,this.Jackpot)

    --this.bingoEffect =  require("View.Bingo.UIView.PartView.GameBingoEffectView")
    --this:SetChildEffectView(this.bingoEffect,this.Bingo,this)

    --this.betView =  require("View/HangUp/HangUpBetView")
    --this:SetChildBetView(this.betView,this.Bet,this)

    --this.powerView =  require("View/HangUp/HangUpPowerUpView")
    --this:SetChildPowerUpView(this.powerView, this.powerup, this)
    --this.powerView:InitForHangUp()

    --叫号
    --this.callNumView = require("View/Bingo/UIView/PartView/GameCallNumberView")
    --this:SetChildCallNumberView(this.callNumView, this.RollBall, this, this.OnDropBall)


    --local topLayerGo = fun.GameObject_find("Canvas/GameUI/NormalNode/HangUpTopLayerView")
    --local refer = fun.get_component(topLayerGo,fun.REFER)

    --战利品
    self.winningsView = require("View/HangUp/HangUpWinningsView")
    self.winningsView:Init(self.winning,self)

    --this.boxView = require("View/Bingo/UIView/PartView/GameBoxView")
    --this.boxView:SkipLoadShow(this.box.gameObject)

    fun.set_active(this.btn_speedup, false)
    self:SetSpeed()
    this:HangUpRegisterEvent()
    this.SetIMetaTableValues()

    self.luabehaviour:AddToggleChange(self.switchCard, function(go,check)
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartSwitchCard()
    end)
end

function HangUpView.OnDropBall(currNumber)

end

function HangUpView:IsAuto()
    return true
end

function HangUpView.SetIMetaTableValues()
    local count = ModelList.HangUpModel:GetCardCount()
    if count == 4 then
        this.__index.bingoScale = 0.7
    elseif count == 8 then
        this.__index.bingoScale = 0.7
    else
        this.__index.bingoScale = 0.5
    end
end


function HangUpView:OnDisable()
    --log.r("hangupview disable")
    --this.__index:OnDisable()
    self:BaseDisable()
    --this.effectObjContainer.OnDisable()
    --this.effectObjContainer.OnDisable()
    --log.r("hangupview disable")
    this:HangUpUnRegisterEvent()
end

function HangUpViewOnDestroy()
    self:BaseOnDestroy()
end

function HangUpView:InitCityBg()
    --[[
    local bg = "luaprefab_textures_hangup_bgzdgj"
    Cache.load_texture(bg,"bgzdgj",function(objs)
        if self.Bg then
            self.Bg.texture = objs
        end
    end)
    --]]
end
function HangUpView:InitHangUpSpecial()
    --[[
    local bg = "luaprefab_textures_hangup_bgzdgj"
    Cache.load_texture(bg,"bgzdgj",function(objs)
        if self.Bg then
            self.Bg.texture = objs
        end
    end)
    --]]
end

function HangUpView:on_btn_main_click()
    this.__index.ShowQuitView(self)
end


function HangUpView:HandleForSettle()

end

function HangUpView:SetContainerForRocketView(parentObj)

end


function HangUpView:HangUpRegisterEvent()
    Event.AddListener( EventName.Event_HangUp_Ready_Settle,this.HandleForSettle)
    --this.__index:RegisterEvent()
end


function HangUpView:HangUpUnRegisterEvent()
    Event.RemoveListener( EventName.Event_HangUp_Ready_Settle,this.HandleForSettle)
    --this.__index:UnRegisterEvent()
end


function HangUpView:SetSpeed()
    local curr_speed  = fun.read_value(MCT.HangUpSpeedConfig,1)
    this.speed_state = curr_speed
    local new_sprite = nil
    if this.speed_state == 2 then
        new_sprite =  AtlasManager:GetSpriteByName("HangUpAtlas","gj_play_02")
    else
        new_sprite = AtlasManager:GetSpriteByName("HangUpAtlas","gj_play_01")
    end
    if new_sprite and this.btn_speedup.sprite.name ~= new_sprite.name then
        this.btn_speedup.sprite = new_sprite
    end
end


this.speed_state = 1
local last_click_time_speed= 0
function HangUpView:on_btn_speedup_click()
    if UnityEngine.Time.time - last_click_time_speed > 1  then
        if this.speed_state == 1 then
            this.btn_speedup.sprite = AtlasManager:GetSpriteByName("HangUpAtlas","gj_play_02")
            this.speed_state = 2
            local speed2 = Csv.GetData("control", 45, "content")[1][1]
            UnityEngine.Time.timeScale = speed2
        else
            this.btn_speedup.sprite = AtlasManager:GetSpriteByName("HangUpAtlas","gj_play_01")
            this.speed_state = 1
            UnityEngine.Time.timeScale = 1
        end
        fun.save_value(MCT.HangUpSpeedConfig,this.speed_state)
        --ModelList.HangUpModel:ReqSpeedup(this.speed_state)
        last_click_time_speed = UnityEngine.Time.time
    end
end



function HangUpView:on_btn_power_click()
    this.powerView:ClickPowerUp()
end

function HangUpView:HideTopLayer()
    if self.topLayer then
        fun.set_active(self.topLayer.transform,false)
    end
end

function HangUpView:IsCardShowing(cardid)
    return true
end


return this