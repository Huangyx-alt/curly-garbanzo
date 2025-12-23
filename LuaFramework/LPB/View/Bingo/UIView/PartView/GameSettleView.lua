require("View/Bingo/SettleModule/State/SettleClimbRankState")
require("View/Bingo/SettleModule/State/SettleDetailState")
require("View/Bingo/SettleModule/State/SettleEvaluationState")
require("View/Bingo/SettleModule/State/SettleRankState")
require("View/Bingo/SettleModule/State/SettleRocketState")
require("View/Bingo/SettleModule/State/SettleTransitionState")
local SettleSmallGameState = require("View/Bingo/SettleModule/State/SettleSmallGameState")

local GameSettleView = BaseView:New('GameSettleView','SettleAtlas');
--local _rocketView = SettleRocketView:New("SettleRocketView",'SettleAtlas')

local this = GameSettleView;
this.auto_bind_ui_items = {
    "GameOverRound1",
    "GameOverRound2",
    "GameOverRound3",
    "GameOverRound4",
    "GameOverRound5",
    "bingo_awards_clone",
    "single_card_clone",
    "text_coin_summary",
    "Content",
    "TopCurrencyView",
    "background",
    "reward_type_icon",
    "GameSettleView",
    "round2_num",
    "round2_get_daubs",
    "round2_rocket_icon",
    "round2_rocket_num",
    "round2_bg1",
    "round2_bg2",
    "round2_rocket_num2",
    "round2_rocket_num3"
}


this.round = 1

this.speedScale = 1 

function GameSettleView.Awake(obj)
    this:on_init()
end

function GameSettleView.OnEnable()
    --Facade.RegisterView(this)
    --resMgr:LoadAtlas(AssetList["SettleAtlas"],"SettleAtlas")
    if ViewList.GameQuitView  and ViewList.GameQuitView.go  and  fun.get_active_self(ViewList.GameQuitView.go) then
        Facade.SendNotification(NotifyName.HideUI, ViewList.GameQuitView)
    end
    --this:OpenTransitionView()

    --this:BuildFsm()
    --this:SetBetRateInfo(self._tem_cardspend,self._tem_betRate,self._tem_rate)
    this.speedScale = ModelList.BattleModel.getGameSpeed()
end

function GameSettleView.OnDisable()
    --log.r("GameSettleView.OnDisable")
    AssetManager.unload_ab_on_game_over()
    UISound.unload_machine_res()
end

function GameSettleView.OnDestroy()
    this:Destroy()
end

--结算界面到下一个面板
function GameSettleView:JumpNextView()
    this._fsm:GetCurState():FinishOperate(this._fsm)
end

--结算界面到下一个面板
function GameSettleView:ExitTransitionView(nextViewName)
    if nextViewName == "SettleRocketView" then
        this._fsm:ChangeState("SettleRocketState")
    elseif nextViewName == "SettleRankView" then
        if ModelList.BattleModel:GetCurrModel():IsSettleRankBeforeThree() then
            this._fsm:ChangeState("SettleRankState")
            --this:DestoryPrviousSettleView(2)
            this:DestoryPrviousSettleView(4)
        else
            this._fsm:ChangeState("SettleDetailState")
        end
    elseif nextViewName == "SettleDetailView" then
        this._fsm:ChangeState("SettleDetailState")
    elseif nextViewName == "SettleClimbRankedView" then
        this._fsm:ChangeState("SettleClimbRankState")
    end
end

--结算面板 阶段1  显示Round1动画
function GameSettleView:OpenTransitionView()
    this.round = 1
    ViewList.SettleTransitionView:SkipLoadShow(this.GameOverRound1)
end

--结算面板阶段2  Round2动画
function GameSettleView:OpenRound2()
    this.round = 2
    ViewList.SettleRocketView.SkipLoadShow(ViewList.SettleRocketView, this.GameOverRound2)
    --_rocketView.SkipLoadShow(_rocketView, this.GameOverRound2)
end

-- 爬结算面板 阶段4  
function GameSettleView:ExitClimbRankView()
    this.round = 3
    --this.GameOverRound4.gameObject:SetActive(true)
end

function GameSettleView:DestoryPrviousSettleView(roundId)
    --Destroy(this["GameOverRound"..roundId])
end

--结算面板 阶段3  显示Round3
function GameSettleView:OpenRound3()
    if this.round< 3 then
        log.r("OpenRound3 OpenRound3")
        this.round = 3
        ViewList.SettleRankView.SkipLoadShow(ViewList.SettleRankView,this.GameOverRound3)
        this.GameOverRound1.gameObject:SetActive(false)
        this.GameOverRound2.gameObject:SetActive(false)
        this.GameOverRound3.gameObject:SetActive(true)
    end
end

--结算面板 阶段4  显示Round4
function GameSettleView:OpenRound4()
    this.round = 4
    ViewList.SettleEvaluationView:SkipLoadShow(this.GameOverRound4)
    this.GameOverRound3.gameObject:SetActive(false)
    --this.GameOverRound4.gameObject:SetActive(true)
end


--结算面板 阶段4  显示Round5
function GameSettleView:OpenRound5()
    this.round = 5

    coroutine.start(function()
        --- 清理卡牌
        local cardMapObj = ModelList.BattleModel:GetCurrBattleView():GetCardMapsObject()
        if cardMapObj and #cardMapObj > 0 then
            for i = 1, #cardMapObj do
                if  fun.is_not_null(cardMapObj[i]) then
                    --- 遍历cardMapObj的子物体，除jackpot特效，其他都销毁
                    for j = cardMapObj[i].transform.childCount,1,-1  do
                        if fun.is_not_null(cardMapObj[i]) and fun.is_not_null(cardMapObj[i].transform) then
                            if cardMapObj[i].transform.childCount> j -1 then
                                local child = cardMapObj[i].transform:GetChild(j-1)
                                if  fun.is_not_null(child)  and not string.find(child.name,"ackpot") then
                                    Destroy(child)
                                    WaitForEndOfFrame()
                                end
                            end
                        else
                            break
                        end
                    end
                else
                    break
                end
            end
        end
        ViewList.SettleDetailView:SkipLoadShow(this.GameOverRound5)
        WaitForFixedUpdate()
        this.GameOverRound4.gameObject:SetActive(false)
        Destroy(this.GameOverRound4)
        WaitForFixedUpdate()
        Destroy(this.GameOverRound1)
        WaitForFixedUpdate()
        Destroy(this.GameOverRound2)
        WaitForFixedUpdate()
        Destroy(this.GameOverRound3)
    end)
end

function GameSettleView:SpeedUp(scale)
    
    if this.speedScale == 1 then 
        this.speedScale = scale
        UnityEngine.Time.timeScale = scale
        ModelList.BattleModel.setGameSpeed(scale)
    else 
        this.speedScale = 1
        UnityEngine.Time.timeScale = 1
        ModelList.BattleModel.setGameSpeed(1)
    end 

    return this.speedScale == 1 -- 是否加速没有
end

function GameSettleView:SetSpeedUp(scale)
    this.speedScale = scale
    UnityEngine.Time.timeScale = scale
end 

function GameSettleView:GetSpeedUp()
    this.speedScale = ModelList.BattleModel.getGameSpeed()

    return this.speedScale == 1 -- 是否加速没有
end

function GameSettleView:BuildFsm()
    this:DisposeFsm()
    this._fsm = Fsm.CreateFsm("GameSettleView",this,{
        SettleTransitionState:New(this.GameOverRound1),
        SettleRocketState:New(this.GameOverRound2),
        SettleClimbRankState:New(this.GameOverRound2),
        --SettleRankState:New(this.GameOverRound3),
        --SettleEvaluationState:New(this.GameOverRound4),
        SettleDetailState:New(this.GameOverRound5),
        SettleClimbRankState:New(),
        SettleSmallGameState:New(),
    })
    this._fsm:StartFsm("SettleTransitionState")
end

function GameSettleView:DisposeFsm()
    if this._fsm then
        this._fsm:Dispose()
        this._fsm = nil
    end
end

return this

