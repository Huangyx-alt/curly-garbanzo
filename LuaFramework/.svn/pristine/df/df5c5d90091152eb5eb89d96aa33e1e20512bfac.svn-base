HangUpSettleView = BaseView:New('HangUpSettleView');

local CardsSummaryItems = require "View.Bingo.UIView.ChildView.CardsSummaryItems"

local this = HangUpSettleView;
this.viewType = CanvasSortingOrderManager.LayerType.None
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

function HangUpSettleView.Awake(obj)
    --this.update_x_enabled = true
    this:on_init()

end

function HangUpSettleView.OnEnable()
    Facade.RegisterView(this)
    this:OpenRound1()
--[[
    this._fsm = Fsm.CreateFsm("HangUpSettleView",this,{
        GameViewNormalState:New(),
        GameViewTweenInState:New()
    })
    this._fsm:InitFsm()
    this._fsm:StartFsm("GameViewTweenInState")
    this._fsm:GetCurState():InitTweenIn(this._fsm)
    --]]
end

--function HangUpSettleView:on_x_update()
--end

function HangUpSettleView.OnDisable()
    --Facade.RemoveView(this)
    --log.r("HangUpSettleView:on_close")
end


function HangUpSettleView.OnDestroy()
    this:Destroy()
    --log.r("HangUpSettleView:OnDestroy")
end

--结算面板 阶段1  显示Round1动画
function HangUpSettleView:OpenRound1()
    this.GameOverRound1.gameObject:SetActive(true)

    --1秒后切换到2
    this.StartCountdown1()
end

--结算面板 阶段1  显示Round2动画
function HangUpSettleView:OpenRound2()
    this.GameOverRound1.gameObject:SetActive(false)
    this.GameOverRound2.gameObject:SetActive(true)
    this.HandleRound2()
    this:StartCountdown2()
end

--结算面板 阶段2处理
function HangUpSettleView:HandleRound2()

end

function HangUpSettleView.StartCountdown2()
    this.timerId2 = LuaTimer:SetDelayFunction(2, function()
        this:OpenRound3()
        this.StopCountdown2()
    end,false,LuaTimer.TimerType.BattleUI)
end

function HangUpSettleView.StopCountdown2()
    if this.timerId2 then
        LuaTimer:Remove(this.timerId2)
        this.timerId2 = nil
    end
end


--结算面板 阶段3  显示Round3
function HangUpSettleView:OpenRound3()
    if not fun.is_null(this.GameOverRound2) then
        fun.set_active(this.GameOverRound2,false)
        fun.set_active(this.GameOverRound3,true)
        this.HandleRound3()
        this.StartCountdown3()
    end
end

--结算面板 阶段3处理
function HangUpSettleView:HandleRound3()
    this.settleData = ModelList.HangUpModel:GetSettleData()
    --local refTemp = fun.get_component(this.GameOverRound3,fun.REFER)
    for i = 1, #this.settleData.ranks do
        local rank = this.settleData.ranks[i].rank
        local obj = fun.find_child(this.GameOverRound3,"SettleHead"..rank)
        this:SetRound3Head(obj,rank,this.settleData.ranks[i].score,this.settleData.ranks[i].nickName)
    end
end



--结算面板 阶段4  显示Round4
function HangUpSettleView:OpenRound4()
    if not fun.is_null(this.GameOverRound3) then
        fun.set_active(this.GameOverRound3,false)
        fun.set_active(this.GameOverRound4,true)
        this.HandleRound4()
        this.StartCountdown4()
    end
end

--结算面板 阶段3处理
function HangUpSettleView:HandleRound4()

end


--结算面板 阶段4  显示Round5
function HangUpSettleView:OpenRound5()
    if not fun.is_null(this.GameOverRound5)  then
        fun.set_active(this.GameOverRound4,false)
        fun.set_active(this.GameOverRound5,true)
        this.HandleRound5()
    end
end

--结算面板 阶段5处理
function HangUpSettleView:HandleRound5()
    if fun.is_null(this.text_coin_awards) then
        return
    end
    this.text_coin_summary.text = this.settleData.chips
    this:CreatSummaryItem()
    this:SettleBingoAwards()
    this:SettleItemsAwards()

end


function HangUpSettleView:InitBingoAwards(data,clone)
    clone.text = data.tips[1].tip
    local childTxt = fun.find_child(clone,"text_coin_awards")
    local tx = fun.get_component(childTxt,"Text")
    tx.text = data.tips[1].content


end





--初始化卡牌summary
function HangUpSettleView:InitCardSummary(data,clone)

    this.single_card_clone.gameObject:SetActive(true)




    clone.text = data.tips[1].tip
    local childTxt = fun.find_child(clone,"text_coin_awards")
    local tx = fun.get_component(childTxt,"Text")
    tx.text = data.tips[1].content
end

-- 结算面板 Card SUmmary 信息
function HangUpSettleView:CreatSummaryItem()
    local roundata = ModelList.HangUpModel:GetRoundData()

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
function HangUpSettleView:SettleBingoAwards()
    local refTemp = fun.get_component(this.GameOverRound5,fun.REFER)
    if #this.settleData.tips == 0 then
        local no_bingo_tip = refTemp:Get("no_bingo_tip")
        local tip_content = Csv.GetData("description",90001,"description")
        no_bingo_tip.text = tip_content
        return
    end
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
function HangUpSettleView:SettleItemsAwards()
    local refTemp = fun.get_component(this.GameOverRound5,fun.REFER)
    local clone = refTemp:Get("item_award_clone")
    for j = 1,#this.settleData.reward.resourceInfo do
        local go = fun.get_instance(clone,clone.transform.parent)
        fun.set_active(go,true,0)
        local text = fun.find_child(go,"text")
        local tip = fun.get_component(text,"Text")
        tip.text = this.settleData.reward.resourceInfo[j].value
        local  chile = fun.find_child(go,"icon")
        local mIcon = fun.get_component(chile,fun.IMAGE)
        mIcon.sprite = this:GetItemIcon(this.settleData.reward.resourceInfo[j].id)
    end
    for j = 1,#this.settleData.reward.itemInfo do
        local go = fun.get_instance(clone,clone.transform.parent)
        fun.set_active(go,true,0)
        local text = fun.find_child(go,"text")
        local tip = fun.get_component(text,"Text")
        tip.text = this.settleData.reward.itemInfo[j].value
        local  chile = fun.find_child(go,"icon")
        local mIcon = fun.get_component(chile,fun.IMAGE)
        mIcon.sprite = this:GetItemIcon(this.settleData.reward.itemInfo[j].id)
    end
end

function HangUpSettleView:GetItemIcon(itemid)
    if itemid > 1000 then
        local icon = Csv.GetData("Item",itemid,"icon")
        return   AtlasManager:GetSpriteByName("ItemAtlas",icon)
    else
        log.y("结算  "..itemid)
        local icon = Csv.GetData("resources",itemid,"icon")
        return   AtlasManager:GetSpriteByName("ItemAtlas",icon)
    end
end




function HangUpSettleView:SetRound3Head(obj,rank,score,nickname)
    local refTemp = fun.get_component(obj,fun.REFER)
    --refTemp.Get("img_head_icon")
    refTemp:Get("Name").text = nickname
    refTemp:Get("score").text = score
    local nu = math.random(1,10)
    local icon = "b_bingo_head1"
    if nu >=5 then   icon = "b_bingo_head2" end
    refTemp:Get("img_head_icon").sprite = AtlasManager:GetSpriteByName("HeadAtlas",icon)
end







function HangUpSettleView.StartCountdown1()
    this.timerId1 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
            this:OpenRound3()
            this.StopCountdown1()
    end,false,LuaTimer.TimerType.BattleUI)
end

function HangUpSettleView.StopCountdown1()
    if this.timerId1 then
        LuaTimer:Remove(this.timerId1)
        this.timerId1 = nil
    end
end


function HangUpSettleView.StartCountdown3()
    this.timerId3 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
        this:OpenRound4()
        this.StopCountdown3()
    end,false,LuaTimer.TimerType.BattleUI)

end

function HangUpSettleView.StopCountdown3()
    if this.timerId3 then
        LuaTimer:Remove(this.timerId3)
        this.timerId3 = nil
    end
end


function HangUpSettleView.StartCountdown4()
    this.timerId4 = LuaTimer:SetDelayFunction(SHOW_TIME, function()
        this:OpenRound5()
        this.StopCountdown4()
    end,false,LuaTimer.TimerType.BattleUI)
end

function HangUpSettleView.StopCountdown4()
    if this.timerId4 then
        LuaTimer:Remove(this.timerId4)
        this.timerId4 = nil
    end
end




function HangUpSettleView:on_btn_skip_click()
    self:OpenRound3()
end
function HangUpSettleView:on_btn_continue_click()
    --Facade.SendNotification(NotifyName.ShowUI,ViewList.SceneLoadingHomeView)
    ModelList.HangUpModel:Clear()

    LoadScene("SceneHome",ViewList.SceneLoadingHomeView,false)
end
return this







