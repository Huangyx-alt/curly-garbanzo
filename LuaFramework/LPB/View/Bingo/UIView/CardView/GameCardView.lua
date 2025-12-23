require("Combat.GlobalMachine.DelayFuncMachine")

---@class GameCardView : BaseChildView
local GameCardView = BaseChildView:New();
local this = GameCardView;

function GameCardView:New(name)
    local o = {
    name = name
    ,cardMap = {}   --卡牌组包括所有格子
    ,cardObjMap = {}   --卡牌obj
    ,pageFrontCards ={}  --前页卡牌
    ,pageBackCards ={}  --前页卡牌
    ,clickCellMap = {} --每个卡牌棋子上的 筹码
    ,number_sprite_list = {}  --数字sprite列表
    ,wish_number_sprite_list = {}  --Wish状态下数字sprite列表
    ,reward_sprite_list = {}  --卡牌基础奖励sprite列表
    ,ball_sprite_list = {}  --号球sprite列表
    ,ball_img_num = 5 --号球图片数量
    ,parent = {}
    ,idToMap = {}
    ,waitRollOver = false  --等待达成bingo的棋子先跳起来旋转一圈,
    ,lastRollCell = {}         --达成bingo的棋子,最后一个播放特效的
    ,lastCardId = 0
    ,lastNumbers = {}
    ,loadData = {}
    ,ballList = nil                    --所有号球列表
    ,rollList = {}                     -- 横向滚动球的列表
    ,coinsPool = {}
    ,number_offset = 24
    ,hide_coin_cb = nil
    ,hide_box_cb = nil
    ,leftTxt = nil
    ,hide_card_reward_list = {}
    ,model = nil
    ,GuideAction = nil
    ,kick_call_name = nil
    ,extTable = nil
    }
    setmetatable(o, self);
    self.__index = self
    return o
end

local reward_xp = 0
local reward_coin = 0

function GameCardView:LoadRequire()
    local gameType = ModelList.BattleModel:GetGameCityPlayID()
    local game_card_data = Csv.GetData("new_game_card",gameType)
    self.cardLoad = require("View.Bingo.CardModule.CardLoad")                       -- 卡牌加载
    self.moduleList = require("View.Bingo.BattleModuleList")
    self.parent = self.parent
    --- 加载自动盖章提示
    if game_card_data["card_sign_tip"] ~= "" then
        self._card_sign_tip = require("View.Bingo.UIView.CardView.CardChildView."..game_card_data["card_sign_tip"])
    end
end

function GameCardView:OnEnable(bingoView, bingosiRef, is_open_search)
    self:BaseEnable(bingoView, bingosiRef, is_open_search)
end

function GameCardView:BaseEnable(bingoView, bingosiRef, is_open_search)
    self:LoadRequire()
    self:SetParentView(bingoView)
    self:GetControlModel()
    self:CacheNumberSprites()
    local gameType = ModelList.BattleModel:GetGameCityPlayID()
    local cardLoadType = Csv.GetData("new_game_card", gameType, "card_load_type")
    if cardLoadType == 1 then
        self:InitCardMapObj()
        self:InitParams()
    else
        self:InitParams()
        self:InitCardMapObj()
    end
    self:InitCity()
    --self:InitCallNumber(bingosiRef)
    self:InitNumberCall()
    Event.Brocast(EventName.Magnifier_Default_Attribute, is_open_search)
end

function GameCardView:InitParams()
    self.lastRollCell = {}
    require("Combat.BattleLogic.BattleLogic")
    BattleLogic:LoadBingoLogic()
    self.moduleList.LoadCardModule(self)
    self.effContainer = self.moduleList.GetModule("EffectEntry")  --效果模块，较为常用，单独设置一个直接引用
    self:GetLoadingData()
    self.cardLoad:SetCardView(self)
    local gameType = ModelList.BattleModel:GetGameCityPlayID()
    local cardLoadType = Csv.GetData("new_game_card",gameType,"card_load_type")
    if cardLoadType == 1 then
        self.cardLoad:LoadNormalCardData(self.parent.Bg)
    elseif cardLoadType == 2 then
        self.cardLoad:LoadHangUpCardData(self.parent.Bg,self:GetParentView().MapType,self:GetParentView().HangMap)
    end
    if self.loadData.extra then
        self.extTable = JsonToTable(self.loadData.extra)
    else
        self.extTable = {}
    end
end

function GameCardView:InitCardMapObj()
    for i = 1, 20 do
        if self.parent["BingoMap" .. i] then
            self:SetCardMapObj(i, self.parent["BingoMap" .. i])
        else
            break
        end
    end
end

function GameCardView:ShowAutoSignFlag(isopen)
    local ref = fun.get_component(self:GetCardMap(3), fun.REFER)
    fun.set_active(ref:Get("autoFlag"),isopen)
    local ref = fun.get_component(self:GetCardMap(4), fun.REFER)
    fun.set_active(ref:Get("autoFlag"),isopen)
end

function GameCardView:SetParentView(my_parent)
    self.parent = my_parent
end

function GameCardView:GetParentView()
    return self.parent
end

function GameCardView:GetLoadingData()
    self.loadData = self.model:LoadGameData()
end

function GameCardView:SetNumberOffset(num)
    self.number_offset = num
end

function GameCardView:SetHide_coin_cb(cb)
    self.hide_coin_cb = cb
end
function GameCardView:SetHide_box_cb(cb)
    self.hide_box_cb = cb
end

--是否是默认格子
function GameCardView:GetDefaultCellAnimOrder(cardId, cellIndex)
    local data = this.defaultCells and this.defaultCells[cardId]
    data = data and data[cellIndex]
    local order = data and data.order
    if order then
        return order
    end
end

function GameCardView:EnableDefaultOpenCellSign(cardID, enable)
    if cardID and this.defaultCells[cardID] then
        table.walk(this.defaultCells[cardID], function(v, cellIndex)
            --盖章动画
            local obj = self.cardMap[cardID][cellIndex]
            local effect = self.effContainer:GetCellChip(cardID, cellIndex, obj)
            fun.set_active(effect, enable)
        end)
    end
end

--- 设置默认打开的格子
---@param animName string 盖章动画
---@param mIndex number 指定哪一张卡  
---@param order number  盖章动画的优先级，如果要播的动画优先级低于正在播的，则不会执行
-------order分三种情况：1、默认盖章后动画order=1；2、bingo后盖章动画order=2；3、Bingo特效出现后盖章状态改变order>=2
function GameCardView:SetDefaultOpenCell(animName, mIndex, order)
    order = order or 1
    if mIndex and this.defaultCells[mIndex] then
        table.walk(this.defaultCells[mIndex], function(v, cellIndex)
            if v.order <= order then
                v.order = order
                
                --盖章动画
                local obj = self.cardMap[mIndex][cellIndex]
                animName = animName or "free_idle"
                local effect = self.effContainer:GetCellChip(mIndex, cellIndex, obj)
                fun.set_active(effect, true)
                effect:Play(animName)
            end
        end)
        return
    end
    
    this.defaultCells = {}
    local currModel = ModelList.BattleModel:GetCurrModel()
    local loadData = currModel:LoadGameData()
    local cellIndex = {13}
    table.walk(loadData and loadData.cardsInfo, function(info)
        local cardId, cardIndex = tostring(info.cardId), tonumber(info.cardId)
        if mIndex and cardIndex ~= mIndex then
            return
        end
        
        this.defaultCells[cardIndex] = this.defaultCells[cardIndex] or {}
        table.walk(info.beginMarkedPos or cellIndex, function(pos)
            local cellPos = ConvertServerPos(pos)
            if not this.defaultCells[cardIndex][cellPos] then
                this.defaultCells[cardIndex][cellPos] = { order = order }
            end
    
            --盖章动画
            local cardCell = self.cardMap[cardIndex][cellPos]
            animName = animName or "free_idle"
            local effect = self.effContainer:GetCellChip(cardIndex, cellPos, cardCell)
            fun.set_active(effect, true)
            effect:Play(animName)

            --盖章类型数据保存
            local cellData = self.model:GetRoundData(cardIndex, cellPos)
            cellData:SetSignType(1)
            cellData:SetMark(1)
            --self:SignCardEffect(cardIndex, cellPos , cardCell, 0, 0, false, 0)
            --self.model:RefreshRoundDataByIndex(i, cellPos, 1, false, -1)

            local ref_temp = fun.get_component(cardCell, fun.REFER)
            self.effContainer:HideCellChild(ref_temp)
            
            Event.Brocast(EventName.CardPower_Sign_Cell, cardIndex, cellPos)
        end)
    end)
end

--获取照相机
function GameCardView:InitCity()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local curr_city = Csv.GetData("new_city_play", playId, "callreward")
    local curr_bet = ModelList.CityModel:GetBetRate()
    --reward_xp = curr_city[curr_bet][2]
    --reward_coin = curr_city[curr_bet][3]
end

--获取道具信息
function GameCardView:GetItemDataByIconName(icon_name)
    local data = Csv.item
    for k, v in pairs(data) do
        if v["icon"] == icon_name then
            return v
        end
    end
end

function GameCardView:PlayBingoTipEffect(cardid, num)
    local key = "B"
    if num <= 15 then key = "B"
    elseif num <= 30 then key = "I"
    elseif num <= 45 then key = "N"
    elseif num <= 60 then key = "G"
    elseif num <= 75 then key = "O" end
    local ctrlKey = string.format("tishi_%s", key)
    ctrlKey = string.lower(ctrlKey)
    
    local mapObj = self:GetCardMap(cardid)
    local refer = fun.get_component(mapObj, fun.REFER)
    local call_tip = refer:Get(ctrlKey)
    fun.set_active(call_tip, true)
    fun.play_animator(call_tip, "act", true)
end

--播放卡牌额外奖励特效
function GameCardView:HideCardReward(cardid)
    self.HideCardRewardState = self.HideCardRewardState or {}
    if not self.HideCardRewardState[cardid] then
        if ModelList.BattleModel:CheckHavePuzzleReward(cardid) then
            self.HideCardRewardState[cardid] = true
            local mapObj = self:GetCardMap(cardid)
            local refer = fun.get_component(mapObj, fun.REFER)
            local reward1 = refer:Get("reward1")
            local reward2 = refer:Get("reward2")
            
            local count = ModelList.BattleModel:GetCurrModel():GetCardCount()
            local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
            onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
            if count == 4 and not onlyShow2Card then
                if cardid % 2 ~= 0 then
                    fun.play_animator(reward1, "over")
                else
                    fun.play_animator(reward2, "over")
                end
            else
                fun.play_animator(reward1, "over")
            end
        end
    end
    
    --for i = 1, #self.hide_card_reward_list do
    --    if self.hide_card_reward_list[i].cardId == cardid then
    --        if self.hide_card_reward_list[i].hide_state == 1 then
    --            self.hide_card_reward_list[i].hide_state = 2
    --        end
    --        return
    --    end
    --end
end

function GameCardView:HideRewardWhenIdle()
    --for i = 1, #self.hide_card_reward_list do
    --    if self.hide_card_reward_list[i].hide_state == 2 then
    --        local map = self.idToMap[tostring(self.hide_card_reward_list[i].cardId)]
    --        local ref_temp = fun.get_component(map, fun.REFER)
    --        local anima = ref_temp:Get("rewardPar")
    --        --local cuc = anima:GetCurrentAnimatorStateInfo(0)
    --        anima:Play(self:GetHideRewardName())
    --        self.hide_card_reward_list[i].hide_state = 3
    --        local fooddz = ref_temp:Get("fooddz")
    --        local foodBag = fun.get_instance(fooddz.gameObject, self:GetParentView().effectObjContainer.FlyGiftContainer)
    --        fun.set_same_position_with(foodBag, fooddz)
    --        --Event.Brocast(EventName.FlyItem_FoodBag_Fly, foodBag, self.hide_card_reward_list[i].cardId)
    --        --Util.EditorPause()
    --    end
    --end
end

function GameCardView:GetIdToMap(cardId)
    return self.idToMap[tostring(cardId)]
end

function GameCardView:GetControlModel()
    self.model = ModelList.BattleModel:GetCurrModel()
end

--播放卡牌额外奖励特效
function GameCardView:DelayPlayCardEffect()
    --self.cardEffect:PlayCardRewardEffect()
    Event.Brocast(EventName.CardEffect_Reward_Effect)
    self.parent:SetReadyForPreUseItem(5)
end

function GameCardView:BINGO_DO_TWEEN_IN()
    self.DelayPlayCardEffect()
end


function GameCardView:GetIndexByNumber(cardid, num)
    local roundData = self.model:GetRoundData(cardid)
    for i = 1, #roundData.cards do
        if roundData.cards[i].num == num then
            return i
        end
    end
    return 0
end


--宠物技能效果
function GameCardView:ResPowerSkill(data)
    for i = 1, #data.nums do
        local cellIndex = self:GetIndexByNumber(data.cardId, data.nums[i])
        local obj = self.cardMap[data.cardId][cellIndex]
        self:SignCardEffect(data.cardId, cellIndex, obj)
    end
end

---获取单张卡牌的指定单元格
function GameCardView:GetCardCell(cardid, index)
    cardid = tonumber(cardid)
    if index then
        if self.cardMap[cardid] then
            return self.cardMap[cardid][index]
        end
    elseif cardid then
        return self.cardMap[cardid]
    else
        return self.cardMap
    end
end

--- 只储存所有格子，这是一个快捷列表，直接设置所有格
function GameCardView:SetCardCell(cardid,obj)
    cardid = tonumber(cardid)
    self.cardMap[cardid] = obj
end

function GameCardView:SetSkill_cell_handler(cb)
    self.skill_cell_handler = cb
end

function GameCardView:EnableCardCollider(cardID, enable)
    cardID = tonumber(cardID)
    table.walk(self.cardMap[cardID], function(cellObj)
        local ref_temp = fun.get_component(cellObj, fun.REFER)
        local collider = ref_temp:Get("collider")
        --fun.set_active(collider, enable)
        fun.enable_component(collider, enable)
    end)
end

---获取单张卡牌的指定单元格
function GameCardView:GetEffectContainer()
    return self.effContainer
end


--初始化叫号
function GameCardView:InitNumberCall ()
    self:SetSkill_cell_handler(function(owner, data)
        self:ResPowerSkill(data)
    end)

    self:RegisterEvent()
end

--展示maxbet时的特殊效果
function GameCardView:ShowMaxBetEffect(cb)
    fun.SafeCall(cb)
end

--更新拼图碎片奖励展示状态
function GameCardView:ShowPuzzleReward(cb)
    self.HideCardRewardState = {}
    
    local loadData = self.model:LoadGameData()
    table.walk(loadData and loadData.cardsInfo, function(v)
        if ModelList.BattleModel:CheckHavePuzzleReward(v.cardId) then
            local mapObj = self:GetCardMap(v.cardId)
            local refer = fun.get_component(mapObj, fun.REFER)
            local reward1 = refer:Get("reward1")
            local reward2 = refer:Get("reward2")
            
            local count = ModelList.BattleModel:GetCurrModel():GetCardCount()
            local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
            onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
            if count == 4 and not onlyShow2Card then
                if v.cardId % 2 ~= 0 then
                    fun.set_active(reward1, true)
                    fun.set_active(reward2, false)
                else
                    fun.set_active(reward1, false)
                    fun.set_active(reward2, true)
                end
            else
                fun.set_active(reward1, true)
                fun.set_active(reward2, false)
            end
        end
    end)
    fun.SafeCall(cb)
end

function GameCardView:RegisterEvent()
    Event.AddListener(Notes.START_PLAY_CARD_REWARD, self.DelayPlayCardEffect,self)
    Event.AddListener(EventName.Refresh_CardSign, self.RefreshCardSign,self)
    Event.AddListener(EventName.Test_Normal_Auto_Click, self.GMClickCardByNum,self)
    --Event.AddListener(EventName.Normal_Auto_Background_Click, self.AutoClickBackgroundCardByNum,self)
    Event.AddListener(EventName.Event_Show_Auto_Sign_Tip, self.ShowAutoSignTip,self)
    Event.AddListener(EventName.Event_Show_Hide_All_Sign_Tip, self.HideAutoSignTip,self)
    Event.AddListener(EventName.Normal_Auto_Click, self.ClickCardByNum, self)
    Event.AddListener(EventName.Show_Puzzle_Reward, self.ShowPuzzleReward, self)
    Event.AddListener(EventName.Show_Max_Bet_Effect, self.ShowMaxBetEffect, self)
    self:RegisterExtraEvent()
end

function GameCardView:RegisterExtraEvent()

end

function GameCardView:UnRegisterEvent()
    Event.RemoveListener(Notes.START_PLAY_CARD_REWARD, self.DelayPlayCardEffect,self)
    Event.RemoveListener(EventName.Refresh_CardSign, self.RefreshCardSign,self)
    Event.RemoveListener(EventName.Test_Normal_Auto_Click, self.GMClickCardByNum,self)
    --Event.RemoveListener(EventName.Normal_Auto_Background_Click, self.AutoClickBackgroundCardByNum,self)
    Event.RemoveListener(EventName.Event_Show_Auto_Sign_Tip, self.ShowAutoSignTip,self)
    Event.RemoveListener(EventName.Event_Show_Hide_All_Sign_Tip, self.HideAutoSignTip,self)
    Event.RemoveListener(EventName.Normal_Auto_Click, self.ClickCardByNum, self)
    Event.RemoveListener(EventName.Show_Puzzle_Reward, self.ShowPuzzleReward, self)
    Event.RemoveListener(EventName.Show_Max_Bet_Effect, self.ShowMaxBetEffect, self)
    self:UnRegisterExtraEvent()
end

function GameCardView:UnRegisterExtraEvent()
end

-- 遍历数组
function GameCardView:IsInTable(value, tbl)
    for k, v in pairs(tbl) do
        if v == value then
            return true;
        end
    end
    return false;
end

function GameCardView:IsCardShowing(cardId)
    --return self.parent:IsCardShowing(cardId) or ModelList.BattleModel:IsRocket()
    return true
end

function GameCardView:OnClickCard(cardid, cardNum, cardCell, double_num, index, mark)
    if self.model:GetRoundData() and self.model:GetRoundData(cardid):GetForbid(cardid) then
        log.r("[GameCardView] OnClickCard, is Forbid, cardid:" .. cardid)
        return
    end
    
    cardCell = self:GetCardCell(cardid, index)
    local CmdClickTriggerSign = require "Logic.Command.Battle.InBattle.Sign.CmdClickTriggerSign"
    local cmd = CmdClickTriggerSign.New()
    cmd:Execute({
        cardView = self,
        cardid = cardid,
        cardNum = cardNum,
        cardCell = cardCell,
        double_num = double_num,
        index = index,
        mark = mark,
    })
end

function GameCardView:ClickEmpty(cardid, cardNum, cardCell)
    --子类重写
end

function GameCardView:CheckCardKickMusic(cardid, index)
    local data = self.model:GetRoundData(cardid, index)
    local gifts = data.gift
    
    --活动道具不算入道具
    local check = false
    table.each(gifts, function(itemId)
        local effect = Csv.GetData("new_item", itemId, "effectid")
        local checkEffect = fun.is_not_null(effect) and effect ~= "0" 
        local puCfg = table.find(Csv["new_powerup"], function(k, v)
            return v.itemid == itemId
        end)
        if not checkEffect or puCfg then
            check = true
        end
    end)
    
    if not check then
        UISound.play(BattleSoundMachine.kick)
    else
        UISound.play("kick_gift")
    end
end

function GameCardView:OnClickCardIgnoreJudgeByIndex(cardid, cellIndex, mark,extraPos,callBack)
    if self.model:GetRoundData() and self.model:GetRoundData(cardid):GetForbid(cardid) then
        log.r("[GameCardView] OnClickCardIgnoreJudgeByIndex, is Forbid, cardid:" .. cardid)
        return 
    end

    local cardCell = self:GetCardCell(cardid, cellIndex)
    
    local CmdSkillTriggerSign = require "Logic.Command.Battle.InBattle.Sign.CmdSkillTriggerSign"
    local cmd = CmdSkillTriggerSign.New()
    cmd:Execute({
        cardView = self,
        cardid = tonumber(cardid),
        cardCell = cardCell,
        index = cellIndex,
        mark = mark,
        extraPos = extraPos,
        callBack = callBack,
    })
end

function GameCardView:CanClickCard(cardid, cardNum, cardCell, index)
    local double_num = self.model:GetRoundData(cardid, index).double_num
    local is_callde = self.model:IsCalledNumber(cardNum) or self.model:IsCalledNumber(double_num)
    local result = is_callde and self.model:IsSigned(cardid, cardNum)
    return result
end

function GameCardView:CanShowMirror(cardid, card_index)
    local result = self.model:IsMirror2(cardid, card_index)
    return result
end

function GameCardView:SignCard(cardCell, signType, delay, cellIndex, cardid)
    --if this:GetDefaultCellAnimOrder(cardid, cellIndex) then
    --    local effect = self.effContainer:GetCellChip(cardid, cellIndex, cardCell)
    --    effect:Play("free_bingo_show")
    --    return
    --end
    
    local ll_data = self.model:GetRoundData(cardid,cellIndex)
    local self_bingo = false
    local giftLen = 0

    self_bingo = ll_data.self_bingo
    giftLen = #ll_data:GetGift()
    if ll_data.sign > signType + 1 then
        signType = ll_data.sign - 1
    end
    self:SignCardEffect(cardid, cellIndex, cardCell, signType, delay, self_bingo, giftLen)
end


--显示盖章效果
function GameCardView:SignCardEffect(cardid, cellIndex, cardCell, signType, delay, self_bingo, giftLen)
    self.effContainer:SignCardEffect(cardid, cellIndex, cardCell, signType, delay, self_bingo, giftLen)
end

function GameCardView:on_x_update()
    --if self.waitRollOver then
    --    for i = #self.lastRollCell, 1, -1 do
    --        if UnityEngine.Time.time >= self.lastRollCell[i].endTime then
    --            local cuc = self.lastRollCell[i].lastRollCell:GetCurrentAnimatorStateInfo(0)
    --            --if (cuc.normalizedTime > 0.8 and cuc:IsName("bingo_show")) then
    --            if cuc:IsName("bingo_idel") then
    --                ModelList.BattleModel:GetCurrModel():ShowBingoRefresh()
    --                table.remove(self.lastRollCell, i)
    --            end
    --        end
    --    end
    --    if #self.lastRollCell == 0 then
    --        self.waitRollOver = false
    --    end
    --end

    --- 应该有个标志位，标识是否Enabled,未开启则不执行，此处先这样写
    if not self.effContainer then return end

    self.effContainer:on_x_update()
    self:HideRewardWhenIdle()
end

function GameCardView:CoinsFlyEffect(mapIndex, pos)
    --self.effContainer:InitFlyCoins(mapIndex, pos, self:GetParentView().box)
end

function GameCardView:IconFlyEffect(mapIndex, pos)
    --self.effContainer:InitFlyIcons(mapIndex, pos, self:GetParentView().box)
end

function GameCardView:ShowBox(box_type)
    --if box_type == nil or box_type == "b_bingo_xz" then
    --    self.parent.box:Play("bingo_box_enter")
    --elseif box_type == "b_bingo_pz" then
    --    self.parent.bottle:Play("bingo_bottlexin")
    --elseif box_type == "pot" then
    --    self.parent.pot:Play("bingo_box_enter")
    --end
end

function GameCardView:OutFrame()
    if fun.is_not_null(self.parent.bottle) and self.parent.bottle.transform.localPosition.x < 300 then
        return false
    end

    if fun.is_not_null(self.parent.box) and self.parent.box.transform.localPosition.x < 300 then

        return false
    end

    if fun.is_not_null(self.parent.pot) and self.parent.pot.transform.localPosition.x < 300 then

        return false
    end

    return true
    --return self.parent.bottle.transform.localPosition.x > 300 and self.parent.box.transform.localPosition.x > 300 and self.parent.pot.transform.localPosition.x > 300
end

function GameCardView:GetAtlasBySpriteName(sprite_name)
    return self.moduleList["CardItem"]:GetAtlasBySpriteName(sprite_name)
end

function GameCardView:PlayStarToCard(extra_info)
    for k, v in pairs(extra_info) do
        local cardId = tonumber(k)
        for j = 1, #v do
            if v[j] > 0 then
                local obj = self.cardMap[cardId][v[j]]
                if obj == nil then
                    log.r("PlayStarToCard  没有对应的格子 " .. cardId .. "    " .. v[j])
                else
                    Event.Brocast(EventName.PowerUpEffect_Sign_To_Card, obj)
                end
            end
        end
    end
end

----------------


function GameCardView:OnDisable()
    self.effectContainerList = {}
    self:BaseDisable()
end

function GameCardView:BaseDisable()
    self:UnRegisterEvent()
    self:DisableAction()
    self.effContainer:OnDisable()
    self.moduleList.UnLoadCardModule()
    self:Close()
end




function GameCardView:DisableAction()
    self.cardMap = {}   --卡牌组

    self.number_img_num = 10 --数字的图片数量
    self.bg_sprite_list = {}  --格子背景sprite列表
    self.doublenum_bg_sprite_list = {}
    self.number_sprite_list = {}  --数字sprite列表
    self.wish_number_sprite_list = {} 
    self.reward_sprite_list = {}  --卡牌基础奖励sprite列表
    self.ball_sprite_list = {}  --号球sprite列表
    self.ball_img_num = 5 --号球图片数量
    self.parent = {}
    self.idToMap = {}

    self.waitRollOver = false  --等待达成bingo的棋子先跳起来旋转一圈,
    self.lastRollCell = {}         --达成bingo的棋子,最后一个播放特效的
    self.lastCardId = 0
    self.lastNumbers = {}

    self.loadData = {}

    self.ballList = nil                    --所有号球列表
    self.rollList = {}                     -- 横向滚动球的列表

    self.parent = nil
    self.cardObjMap = {}
    self.pageFrontCards ={}  --前页卡牌
    self.pageBackCards ={}  --前页卡牌
    self.coinsPool = {}
    --self.number_offset = 20
    self.cardMap = {}
    self.effContainer.OnDisable()
    self.hide_card_reward_list = {}
    self.cardLoad:OnDisable()
    if self.GuideAction then
        self.GuideAction = nil
        ModelList.GuideModel:RestoreFirstBattle()
    end
end

function GameCardView:CopyThisIndex(new_this)
    self = new_this
end

--刷新格子盖章显示
function GameCardView:RefreshCardSign( card_id, card_index, sign_type, self_bingo, giftLen)
    if sign_type > 1 then
        return
    end

    --只有普通盖章才能继续走逻辑
    local obj = self.cardMap[tonumber(card_id)][card_index]
    self:SignCardEffect(card_id, card_index, obj, sign_type, 0, self_bingo, giftLen)
end

function GameCardView:CheckDelayAnimaPlay()
    self.effContainer:on_x_update()
end

function GameCardView:ClearDelayTime()
    --for k,v in pairs(self.coinFlyTime) do
    --    LuaTimer:Remove(v)
    --end
end

----------------------------Guide----------------
function GameCardView:AddGuideAction(event)
    self.GuideAction = event
end
---------------------------------------------------

--卡牌miss效果
function GameCardView:ShowMisseffect(cardId, cellIndex)
    self.effContainer:ShowMisseffect(cardId, cellIndex)
end

--卡牌perfect效果
function GameCardView:ShowPerfectEffect(cardId)
    self.effContainer:ShowPerfectEffect(cardId)
end

function GameCardView:GMClickCardByNum(currNumber)
    if not ModelList.GMModel.IsAutoBattle and not ModelList.GMModel.IsAutoSign then
        return
    end
    
    local currModel = ModelList.BattleModel:GetCurrModel()
    local roundData = currModel:GetRoundData()
    local loadData = currModel:LoadGameData()
    local req_info = { gameId = ModelList.GameModel:GetGameId(), total = {} }
    for i = 1, #loadData.cardsInfo do
        local id = loadData.cardsInfo[i].cardId
        if not currModel:GetRoundData(tonumber( id)):GetForbid() then
            local id_str = tostring(id)
            for j = 1, #loadData.cardsInfo[i].numbers do
                local get_num = loadData.cardsInfo[i].numbers[j]
                local double_num = roundData[id_str].cards[j].double_num
                local sign_type = roundData[id_str].cards[j].sign
                local index = roundData[id_str].cards[j].index
                if sign_type == 0 and (get_num == currNumber or double_num == currNumber) then
                    self:OnClickCard(id, get_num, nil, double_num, index)
                    --local info = { cardId = id, number = get_num, index = index, isDouble = (double_num == currNumber) }
                    --table.insert(req_info.total, info)
                end
            end
        end
    end
    
    --if req_info.total and #req_info.total > 0 then
    --    ModelList.BattleModel:GetCurrModel():ReqSignCard(req_info)
    --    self:AutoClickCard(req_info)
    --end
end

function GameCardView:ClickCardByNum(currNumber)
    local currModel = ModelList.BattleModel:GetCurrModel()
    local roundData = currModel:GetRoundData()
    local loadData = currModel:LoadGameData()
    local req_info = { gameId = ModelList.GameModel:GetGameId(), total = {} }
    for i = 1, #loadData.cardsInfo do
        local id = loadData.cardsInfo[i].cardId
        if not currModel:GetRoundData(tonumber( id)):GetForbid() then
            local id_str = tostring(id)
            for j = 1, #loadData.cardsInfo[i].numbers do
                local get_num = loadData.cardsInfo[i].numbers[j]
                local double_num = roundData[id_str].cards[j].double_num
                local sign_type = roundData[id_str].cards[j].sign
                local index = roundData[id_str].cards[j].index
                if sign_type == 0 and (get_num == currNumber or double_num == currNumber) then
                    local info = { cardId = id, number = get_num, index = index, isDouble = (double_num == currNumber) }
                    table.insert(req_info.total, info)
                end
            end
        end
    end

    if req_info.total and #req_info.total > 0 then
        ModelList.BattleModel:GetCurrModel():ReqSignCard(req_info)
        self:AutoClickCard(req_info)
        Event.Brocast(EventName.Switch_View_Refresh,req_info.total,true)
    end
end

--- 展示自动盖章提示
function GameCardView:ShowAutoSignTip(cardId)
    local cardObj = self:GetCardMap(cardId)
    self._card_sign_tip:ShowTip(cardObj,cardId)
end

--- 隐藏自动盖章提示
function GameCardView:HideAutoSignTip()
    self._card_sign_tip:HideAllTip()
end


function GameCardView:AutoClickCard(sign_info)
    local has_contain_gift = false
    local has_sign = false
    local firstSignCell = nil -- 挂机第一个被盖章的棋子
    for i = 1, #sign_info.total do
        local card_id = tonumber(sign_info.total[i].cardId)
        local index = ModelList.GameModel:GetIndexByNum(sign_info.total[i].cardId, sign_info.total[i].number)
        local card_cell = self:GetCardCell(card_id, index)
        if not index then
            log.r("card_id      " .. sign_info.total[i].cardId .. "    type  " .. type(card_id) .. "      index  " .. sign_info.total[i].number)
        end
        local t_id = sign_info.total[i].cardId
        if not has_contain_gift and #ModelList.BattleModel:GetCurrModel():GetRoundData(t_id,index):GetGift()  > 0 then
            has_contain_gift = true
        end
        if firstSignCell == nil then
            firstSignCell = card_cell
        end
        --self:SignCardEffect(card_id, index, card_cell)
        local effectType = self.model:HasCardCellGift(card_id, index)
        Event.Brocast(EventName.CardEffect_MapClick_Effect, card_id, effectType and 3 or 1, index)
        Event.Brocast(EventName.CardSingEffect_CellTip, card_cell, false, sign_info.total[i].number, 0)
        has_sign = true
        Event.Brocast(Notes.SYNC_SIGN,card_id,index)
        if sign_info.total[i].isDouble then
            Event.Brocast(EventName.CallNumberMachine_Quick_Click, 0, sign_info.total[i].number, card_id)
        else
            Event.Brocast(EventName.CallNumberMachine_Quick_Click, 111, sign_info.total[i].number, card_id)
        end
    end

    if has_contain_gift then
        UISound.play("kick_reword")
    end
    if #sign_info > 0 then
        UISound.play(BattleSoundMachine.kick)
    end
end

function GameCardView:GetPowerupView()
    return self:GetParentView().powerView
end

---单屏最大卡牌数量
function GameCardView:GetMaxCardCount()
    if ModelList.BattleModel:GetGameType() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        return 8
    else
        return 2
    end
end

function GameCardView:ActiveMaps(cardCount,isEnter)
    for i = 1, #self.cardObjMap do
        if i <= cardCount then
            self.cardObjMap[i]:ActiveCard(true, i,isEnter,cardCount,this:GetMaxCardCount())
        else
            self.cardObjMap[i]:ActiveCard(false, i,isEnter,cardCount,this:GetMaxCardCount())
        end
    end
end


function GameCardView:AddEffectToCellReference(cardId,effectType,parent,cellReference)
    if self.cardObjMap and self.cardObjMap[cardId] then
        self.cardObjMap[cardId]:AddCommonEffect(effectType,parent,cellReference)
    end
end

function GameCardView:SetCardMapObj(cardId, obj)
    cardId = tonumber(cardId)
    local singleCardViewName = Csv.GetData("new_game_mode",ModelList.BattleModel:GetGameCityPlayID(),"singlecardview")
    local cardView = require("Combat.Common.View."..singleCardViewName)
    local newCard =  cardView:Clone(singleCardViewName)
    newCard:BindObj(obj,self, cardId)
    self.cardObjMap[cardId] = newCard
end

--- 获取card GameObject方法
---@return "GameObject"
function GameCardView:GetCardMap(mapIndex)
    mapIndex = tonumber(mapIndex)
    if mapIndex then
        if self.cardObjMap[mapIndex] then
            return self.cardObjMap[mapIndex]:GetCardObj()
        else
            return nil    
        end
    else
        return self.cardObjMap
    end
end

--- 获取card GameObject方法
---@return "GameObject"
function GameCardView:GetAllCardMapObj()
    local objList = {}
    for i = 1, #self.cardObjMap do
        table.insert(objList,self.cardObjMap[i]:GetCardObj())
    end
    return objList
end

---@param pageId_页面ID
---获取对应页面的卡牌列表
function GameCardView:GetPageCards(pageId)
    local objList = {}
    for i = 1, #self.cardObjMap do
        table.insert(objList,self.cardObjMap[i]:GetCardObj())
    end
    return objList
end

---  obsolete_获取card方法,建议使用GetCardMap 获取card GameObject
function GameCardView:GetCard(mapIndex)
    mapIndex = tonumber(mapIndex)
    if mapIndex then
        return self.cardObjMap[mapIndex]
    else
        return self.cardObjMap
    end
end

function GameCardView:GetCardMapList(startIndex, endIndex)
    local mapList = {}
    local mapIndex = 0
    for i = startIndex, endIndex do
        mapIndex = tonumber(i)
        table.insert(mapList, self.cardObjMap[mapIndex])
    end
    return mapList
end

--- 保存普通卡牌数字，方便调取
function GameCardView:StorageNormalNumberSprites(obj)
    local sp_container = fun.get_component(obj, fun.IMAGESPRITESCONTAINER)
    if sp_container then
        for i = 1, 10 do
            local sp = sp_container:GetAsIndex(i - 1)
            self.number_sprite_list[i] =sp
        end
    end
end

--- 返回普通卡牌数字，方便调取
function GameCardView:GetNormalNumberSprites(order)
    if not self.number_sprite_list or #self.number_sprite_list == 0 then
        self.number_sprite_list ={}
        if self:GetParentView().ItemContainer then
            self:StorageNormalNumberSprites(self:GetParentView().ItemContainer )
        end
        if #self.number_sprite_list == 0 and self:GetParentView().Bg then
            self:StorageNormalNumberSprites(self:GetParentView().Bg)
        end
    end
    if order == 0 then
        return self.number_sprite_list[10]
    end
    return self.number_sprite_list[order]
end

--- 设置黄色卡牌数字
function GameCardView:SetYellowNumberSprites(img, order)
    Cache.GetSpriteByName("BingoAtlas", "nubYellow" .. order, function(sprite)
        img.sprite = sprite
    end)
end

--- 恢复默认卡牌数字
function GameCardView:RestoreDefaultNumberSprites(img, order)
    img.sprite = self:GetNormalNumberSprites(order)
end

--- 每种卡牌 从ext拿的数据都不同，需要分开解析
---有miniGame
---wolfData
function GameCardView:GetExtInfo(cardId,cellIndex,dataName)
    cardId = tonumber(cardId)
    
    local serverPos = ConvertCellIndexToServerPos(cellIndex)
    if not self.extTable then
        self.extTable = JsonToTable(self.loadData.extra)
    end
    
    if self.extTable and self.extTable[dataName] then
        for i = 1, #self.extTable[dataName] do
            if self.extTable[dataName][i].cardId == cardId and self.extTable[dataName][i].pos == serverPos then
                return self.extTable[dataName][i].freeMarkPos
            end
        end
    end
    
    return nil
end

--- 卡牌数据初始化完成状态
function GameCardView:InitCardOver(state)
    self._isInitCardOver = state
    if state then
        self:OnCardLoadOver()
    end
end

--- 卡牌数据是否完成初始化
function GameCardView:IsCardOver()
    return self._isInitCardOver
end

--- 卡牌数据初始化完成之后
function GameCardView:OnCardLoadOver()

end

function GameCardView:GetDoublenumBgSprites(cellIndex)
    if not self.doublenum_bg_sprite_list or #self.doublenum_bg_sprite_list == 0 then
        self.doublenum_bg_sprite_list ={}
        local container = self:GetParentView().CellDoubleNumBgContainer
        if container then
            local sp_container = fun.get_component(container, fun.IMAGESPRITESCONTAINER)
            if sp_container then
                for i = 1, 6 do
                    local sp = sp_container:GetAsIndex(i - 1)
                    self.doublenum_bg_sprite_list[i] =sp
                end
            end
        end
    end
    if not cellIndex then
        return self.doublenum_bg_sprite_list[1]
    end

    if cellIndex < 6 then
        return self.doublenum_bg_sprite_list[2]
    elseif cellIndex < 11 then
        return self.doublenum_bg_sprite_list[3]
    elseif cellIndex < 16 then
        return self.doublenum_bg_sprite_list[4]
    elseif cellIndex < 21 then
        return self.doublenum_bg_sprite_list[5]
    else
        return self.doublenum_bg_sprite_list[6]
    end
end

function GameCardView:GetBgSprites(cellIndex)
    if not self.bg_sprite_list or #self.bg_sprite_list == 0 then
        self.bg_sprite_list ={}
        local cellBgContainer = self:GetParentView().CellBgContainer
        if cellBgContainer then
            local sp_container = fun.get_component(cellBgContainer, fun.IMAGESPRITESCONTAINER)
            if sp_container then
                for i = 1, 6 do
                    local sp = sp_container:GetAsIndex(i - 1)
                    self.bg_sprite_list[i] =sp
                end
            end
        end
    end
    if not cellIndex then
        return self.bg_sprite_list[1]
    end
    
    if cellIndex < 6 then
        return self.bg_sprite_list[2]
    elseif cellIndex < 11 then
        return self.bg_sprite_list[3]
    elseif cellIndex < 16 then
        return self.bg_sprite_list[4]
    elseif cellIndex < 21 then
        return self.bg_sprite_list[5]
    else
        return self.bg_sprite_list[6]
    end
end

--达成Bingo后格子变色
function GameCardView:ChangeCellBgOnBingo(cardId)
    for i = 1, 25 do
        local cell = self:GetCardCell(cardId, i)
        local refer = fun.get_component(cell, fun.REFER)
        local bg_tip = refer:Get("bg_tip")
        local sprite = self:GetBgSprites(i)
        bg_tip.sprite = sprite        
        
        local doublebg = refer:Get("doublebg")
        doublebg = fun.get_component(doublebg, fun.IMAGE)
        local doubleBgSprite = self:GetDoublenumBgSprites(i)
        doublebg.sprite = doubleBgSprite
    end
end

--- 设置放大镜状态下的数字
function GameCardView:SetNumberSpritesOnMirror(img, order)
    if order == 0 then
        order = 10
    end
    
    local sprite = self.wish_number_sprite_list[order]
    img.sprite = sprite
end

--缓存数字图片集合
function GameCardView:CacheNumberSprites()
    if not self.wish_number_sprite_list or #self.wish_number_sprite_list == 0 then
        self.wish_number_sprite_list ={}
        local container = self:GetParentView().MirrorNumberContainer
        if not IsNull(container) then
            local sp_container = fun.get_component(container, fun.IMAGESPRITESCONTAINER)
            if sp_container then
                for i = 1, 10 do
                    local sp = sp_container:GetAsIndex(i - 1)
                    self.wish_number_sprite_list[i] =sp
                end
            end
        end
    end
end

----------------------------------GM------------------------------------

local startId = 1
---每次调用将一张卡牌上的所有格子盖章
function GameCardView:GmSignTest()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        coroutine.start(function()
            table.each(jackpotRule, function(cellIndex)
                self:OnClickCardIgnoreJudgeByIndex(startId, cellIndex, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end)
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    else
        coroutine.start(function()
            for i = 25, 1,-1 do
                self:OnClickCardIgnoreJudgeByIndex(startId, i, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    end
end


----------------region mini game--------------------------

function GameCardView:ExtraBallClickCard(cardid, cellIndex)
    if self.model:GetRoundData() and self.model:GetRoundData(cardid):GetForbid(cardid) then
        return
    end

    local cardIdNum = tonumber(cardid)
    if not self.cardMap or not self.cardMap[cardIdNum] or not self.cardMap[cardIdNum][cellIndex] then
        return
    end

    local isSigned = self.model:GetRoundData(cardid, cellIndex).sign
    if isSigned == 0 then
        UISound.play(BattleSoundMachine.kick)
        local cardCell = self.cardMap[cardIdNum][cellIndex]
        Event.Brocast(EventName.CardSingEffect_CellTip, cardCell, false, 0, 0, cardid, cellIndex)
    end

    ModelList.GameModel:SignCardWithExtraBall(cardIdNum, cellIndex)
end

----------------endregion mini game--------------------------

----------------Bingo Bang Start--------------------------

--取特效播放的地方
function GameCardView:GetEffectPlayRoot(cardID, type)
    cardID = tonumber(cardID)
    self.effectContainerList = self.effectContainerList or {}
    if not self.effectContainerList[cardID] then
        self.effectContainerList[cardID] = {}
        local cardObj = self:GetCard(cardID)
        local refer = fun.get_component(cardObj.EffectRoot, fun.REFER)
        table.walk(BingoBangEntry.BattleContainerType, function(v, k)
            self.effectContainerList[cardID][v] = refer:Get(k)
        end)
    end

    local ret = self.effectContainerList[cardID][type]
    return ret
end

function GameCardView:OnPlayBingoEffect(cardID)
    cardID = tonumber(cardID)
    
    local cardObj = self:GetCardMap(cardID)
    local ref_temp = fun.get_component(cardObj, fun.REFER)
    local BingoGlow = ref_temp:Get("BingoGlow")
    fun.set_active(BingoGlow, false)
    fun.set_active(BingoGlow, true)
end

----------------Bingo Bang End--------------------------

return this

