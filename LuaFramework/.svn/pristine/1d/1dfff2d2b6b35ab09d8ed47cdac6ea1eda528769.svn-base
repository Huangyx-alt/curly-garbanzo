GameSettleFSMView = BaseView:New('GameSettleFSMView');

local CardsSummaryItems = require "View.Bingo.UIView.ChildView.CardsSummaryItems"

local this = GameSettleFSMView;
this.auto_bind_ui_items = {
    "GameOverRound1",
    "GameOverRound2",
    "GameOverRound3",
    "GameOverRound4",
    "GameOverRound5",
    "btn_skip",
    "bingo_awards_clone",
    "single_card_clone",
    "text_coin_summary",
    "Content",
    "btn_continue"
}

local SHOW_TIME = 3
this.settleData = nil

function GameSettleFSMView.Awake(obj)
    --this.update_x_enabled = true
    this:on_init()

end

function GameSettleFSMView.OnEnable()
    Facade.RegisterView(this)
    this:OpenRound1()

    this._fsm = Fsm.CreateFsm("GameSettleFSMView",this,{
        GameViewNormalState:New(),
        GameViewTweenInState:New()
    })
    this._fsm:InitFsm()
    this._fsm:StartFsm("GameViewTweenInState")
    this._fsm:GetCurState():InitTweenIn(this._fsm)

end

--function GameSettleFSMView:on_x_update()
--end

function GameSettleFSMView.OnDisable()
    --Facade.RemoveView(this)
    log.r("GameSettleFSMView:on_close")
end


function GameSettleFSMView.OnDestroy()
    this:Destroy()
    log.r("GameSettleFSMView:OnDestroy")
end

--结算面板 阶段1  显示Round1动画
function GameSettleFSMView:OpenRound1()
    this.GameOverRound1.gameObject:SetActive(true)

    --1秒后切换到2
    this.StartCountdown1()
end

--结算面板 阶段1  显示Round2动画
function GameSettleFSMView:OpenRound2()
    this.GameOverRound1.gameObject:SetActive(false)
    this.GameOverRound2.gameObject:SetActive(true)
    this.HandleRound2()
end

--结算面板 阶段2处理
function GameSettleFSMView:HandleRound2()
    --节省性能，把bingo界面的卡牌拿过来直接使用
    local map1,map2,map3,map4 = ViewList.GameBingoView:GetCardMapsObject()
    local count = ModelList.GameModel:GetCardCount()
    local par = fun.find_child(this.GameOverRound2,"Node"..count)
    for i= 1,count do
        local child = fun.find_child(par,"Map"..i)
        local child2 = nil
        if i == 1 then    child2 = map1
        elseif i == 2 then child2 = map2
        elseif i == 3 then  child2 = map3
        else  child2 = map4       end
        if child2 then
            fun.set_parent(child2,child,true)
            --fun.set_gameobject_scale(child2,1,1,1)
        end
    end
end


--结算面板 阶段3  显示Round3
function GameSettleFSMView:OpenRound3()
    this.GameOverRound2.gameObject:SetActive(false)
    this.GameOverRound3.gameObject:SetActive(true)
    this.HandleRound3()
    this.StartCountdown3()
end

--结算面板 阶段3处理
function GameSettleFSMView:HandleRound3()
    this.settleData = ModelList.GameModel:GetSettleData()
    --local refTemp = fun.get_component(this.GameOverRound3,fun.REFER)
    for i = 1, #this.settleData.ranks do
        local rank = this.settleData.ranks[i].rank
        local obj = fun.find_child(this.GameOverRound3,"SettleHead"..rank)
        this:SetRound3Head(obj,rank,this.settleData.ranks[i].score,this.settleData.ranks[i].nickName)
    end
end



--结算面板 阶段4  显示Round4
function GameSettleFSMView:OpenRound4()
    this.GameOverRound3.gameObject:SetActive(false)
    this.GameOverRound4.gameObject:SetActive(true)
    this.HandleRound4()
    this.StartCountdown4()
end

--结算面板 阶段3处理
function GameSettleFSMView:HandleRound4()

end


--结算面板 阶段4  显示Round5
function GameSettleFSMView:OpenRound5()
    if not fun.is_null(this.GameOverRound5) then
        fun.set_active(this.GameOverRound4,false)
        fun.set_active(this.GameOverRound5,true)
        this.HandleRound5()
    end
end

--结算面板 阶段5处理
function GameSettleFSMView:HandleRound5()
    
    this.text_coin_summary.text = this.settleData.chips

    --this:InitBingoAwards(data,this.bingo_awards_clone)

    this:CreatSummaryItem()
    this:SettleBingoAwards()
    this:SettleItemsAwards()

end


function GameSettleFSMView:InitBingoAwards(data,clone)
    clone.text = data.tips[1].tip
    local childTxt = fun.find_child(clone,"text_coin_awards")
    local tx = fun.get_component(childTxt,"Text")
    tx.text = data.tips[1].content


end





--初始化卡牌summary
function GameSettleFSMView:InitCardSummary(data,clone)

    this.single_card_clone.gameObject:SetActive(true)




    clone.text = data.tips[1].tip
    local childTxt = fun.find_child(clone,"text_coin_awards")
    local tx = fun.get_component(childTxt,"Text")
    tx.text = data.tips[1].content
end

-- 结算面板 Card SUmmary 信息
function GameSettleFSMView:CreatSummaryItem()
    local roundata = ModelList.GameModel:GetRoundData()

    if roundata then
        self.cardsItems = {}
        for k,v in pairs(roundata) do
            local reapData = {isBingo = v.isBingo,isJackpot = v.isJackpot,cards = {}}
            for j = 1, #v.cards do
                if v.cards[j].sign and v.cards[j].sign >0 then
                    table.insert(reapData.cards,v.cards[j])
                end
                --table.insert(self.cardsItems,items)
            end
            local go = fun.get_instance(this.single_card_clone,self.Content)
            fun.set_active(go,true,0)
            CardsSummaryItems:New(go,reapData)
            --items:Init(go)
            --go.gameObject:SetActive(false)
        end

--[[
        for i = 1, #roundata do
            local reapData = {}
            local matureNoReap = 0
            for j = 1, #roundata[i].roundData do
                if roundata[i].roundData[j].isReap then
                    table.insert(reapData,roundata[i].roundData[j])
                elseif roundata[i].roundData[j].isMature then
                    matureNoReap = matureNoReap + 1
                end
            end
            local go = fun.get_instance(self.awardItems,self.contenGo)
            fun.set_active(go,true,0)
            local items = CardsSummaryItems:New(go,reapData,matureNoReap)
            table.insert(self.cardsItems,items)
        end
        --]]
    end
end

--结算面板 bingo Awards 展示
function GameSettleFSMView:SettleBingoAwards()
    local refTemp = fun.get_component(this.GameOverRound5,fun.REFER)
    local clone = refTemp:Get("bingo_awards_clone")
    for i = 1, #this.settleData.tips do
        if this.settleData.tips then
            local go = fun.get_instance(clone,clone.gameObject.transform.parent)
            fun.set_active(go,true,0)
            local tip = fun.get_component(go,"Text")
            tip.text = this.settleData.tips[i].tip
            --local  chile = fun.find_child(go,"text_coin_awards")
            local content = fun.get_component(go,"Text")
            content.text = this.settleData.tips[i].content
        end
    end
end


--结算面板道具 Awards 展示
function GameSettleFSMView:SettleItemsAwards()
    local refTemp = fun.get_component(this.GameOverRound5,fun.REFER)
    local clone = refTemp:Get("item_award_clone")
    for i = 1, #this.settleData.rewards do
        local go = fun.get_instance(clone,clone.transform.parent)
        fun.set_active(go,true,0)
        local text = fun.find_child(go,"text")
        local tip = fun.get_component(text,"Text")
        tip.text = this.settleData.rewards[i].num
        local  chile = fun.find_child(go,"icon")
        local mIcon = fun.get_component(chile,fun.IMAGE)
        mIcon.sprite = this:GetItemIcon(this.settleData.rewards[i].itemId)
    end
end

function GameSettleFSMView:GetItemIcon(itemid)
    if itemid > 1000 then
        local icon = Csv.GetData("Item",itemid,"icon")
        return   AtlasManager:GetSpriteByName("ItemAtlas",icon)
    elseif itemid == 1 then  return   AtlasManager:GetSpriteByName("HallMainAtlas","w_small_coins")
    elseif itemid == 3 then  return   AtlasManager:GetSpriteByName("BingoAtlas","icon_diamond")
    end
end




function GameSettleFSMView:SetRound3Head(obj,rank,score,nickname)
    local refTemp = fun.get_component(obj,fun.REFER)
    --refTemp.Get("img_head_icon")
    refTemp:Get("Name").text = nickname
    refTemp:Get("score").text = score
    local nu = math.random(1,10)
    local icon = "b_bingo_head1"
    if nu >=5 then   icon = "b_bingo_head2" end
    refTemp:Get("img_head_icon").sprite = AtlasManager:GetSpriteByName("HeadAtlas",icon)
end







function GameSettleFSMView.StartCountdown1()
    this.timerId1 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
            this:OpenRound2()
            this.StopCountdown1()
    end,false)

end

function GameSettleFSMView.StopCountdown1()
    if this.timerId1 then
        LuaTimer:Remove(this.timerId1)
        this.timerId1 = nil
    end
end


function GameSettleFSMView.StartCountdown3()
    this.timerId3 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
        this:OpenRound4()
        this.StopCountdown3()
    end,false)

end

function GameSettleFSMView.StopCountdown3()
    if this.timerId3 then
        LuaTimer:Remove(this.timerId3)
        this.timerId3 = nil
    end
end


function GameSettleFSMView.StartCountdown4()
    this.timerId4 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
        this:OpenRound5()
        this.StopCountdown4()
    end,false,LuaTimer.TimerType.BattleUI)

end

function GameSettleFSMView.StopCountdown4()
    if this.timerId4 then
        LuaTimer:Remove(this.timerId4)
        this.timerId4 = nil
    end
end




function GameSettleFSMView:on_btn_skip_click()
    self:OpenRound3()
end
function GameSettleFSMView:on_btn_continue_click()
    --Facade.SendNotification(NotifyName.ShowUI,ViewList.SceneLoadingHomeView)
    ModelList.GameModel:Clear()

    LoadScene("SceneHome",ViewList.SceneLoadingHomeView,false)
end
return this







