--- 卡牌上Powerup 功能

----常驻技能
local _jokerSkill = require("View.Bingo.CardModule.Skill.JokerSkill")
local _iceBucket = require("View.Bingo.CardModule.Skill.HawaiiIceBucketSkill")
local _throwItem = require("View.Bingo.CardModule.Skill.ThrowItemSkill")
local _doubleNum = require("View.Bingo.CardModule.Skill.DoubleNumSkill")
local _snowBall = require("View.Bingo.CardModule.Skill.ChristmasSnowBall")
local _cityBoom = require("View.Bingo.CardModule.Skill.CityBoomSkill")
local _flyBomb = require("View.Bingo.CardModule.Skill.FlyBombSkill")
local _dolphinSkill = require("View.Bingo.CardModule.Skill.DolphinSkill")

local CardPower = Clazz(ClazzBase, "CardPower")
local this = CardPower
this.CellState = { Empty = 0, DoubleNum = 1, AddItem = 2, Signed = 10 }

this.cardAllHitPos = nil
this.cardCallHitPos = nil
this.powerUpData = nil
this.jackPotList = nil   --是否能形成jackpot
this.unhitPosList = nil  --不会被命中的格子
this.findMissPos = false  --up卡寻找不会命中的格子
this.CardPowerList = {}
---动态加载的技能
this.loadSkill = {}

function CardPower:SetCardView(cardView)
    this.cardView = cardView
    this.model = ModelList.BattleModel:GetCurrModel()
    this:LoadCardAllHitPos()
    this.CardPowerList = {}
    this.loadSkill = {}
    _jokerSkill:SetCardPower(this)
    _iceBucket:SetCardPower(this)
    _doubleNum:SetCardPower(this)
    _throwItem:SetCardPower(this)
    _snowBall:SetCardPower(this)
    _cityBoom:SetCardPower(this)
    _flyBomb:SetCardPower(this)
    _dolphinSkill:SetCardPower(this)
end

---加载模块对应的技能
function CardPower:SetModule(cardView)

end

function CardPower:SameScaleWithCard (effect, cardId)
    local card = this:GetCardView():GetCardMap(cardId)
    if card then
        effect.transform.localScale = card.transform.localScale
    end
end

this.skillRocketGetIndex = 1
local function CurrRocketIndex()
    local index = this.skillRocketGetIndex
    this.skillRocketGetIndex = this.skillRocketGetIndex + 1
    if this.skillRocketGetIndex > 3 then
        this.skillRocketGetIndex = 1
    end
    return index
end

function CardPower:SaveSkillInfo(cardId, obj)
    if obj == nil then
        table.insert(this.CardPowerList, { id = cardId, obj = nil })
        --log.r(cardId .. "  skill first  add   " .. #this.CardPowerList)
    else
        for i = 1, #this.CardPowerList do
            if this.CardPowerList[i].id == cardId and this.CardPowerList[i].obj == nil then
                this.CardPowerList[i].obj = obj
                --log.r(cardId .. "  skill  add   " .. i)
                break
            end
        end
    end
end

function CardPower:RemoveSkillInfo(obj)
    --log.r(" try skill remove    " .. obj.name)
    for i = 1, #this.CardPowerList do
        if this.CardPowerList[i].obj == obj then
            table.remove(this.CardPowerList, i)
            --log.r(" skill remove    " .. obj.name .. "      " .. i)
            break
        end
    end
end

function CardPower:IsSkillEffectComplete()
    return this.CardPowerList and #this.CardPowerList == 0 or false
end

--宠物技能
function CardPower:PetSkill(skill_id, cardId, cellIndex, powerId, extraPos, cb)
    local CmdPlayCellSkill = require "Logic.Command.Battle.InBattle.Skill.CmdPlayCellSkill"
    local cmd = CmdPlayCellSkill.New()
    cmd:Execute({
        cardPower = this,
        skill_id = skill_id,
        cardId = cardId,
        cellIndex = cellIndex,
        powerId = powerId,
        extraPos = extraPos,
        cb = cb,
    })
end

---加载模块的技能
function CardPower:CheckSkillRequire(skillName)
    if not this.loadSkill[skillName] then
        local requireName = Csv.GetData("new_game_mode", ModelList.BattleModel:GetGameCityPlayID(), "skill_require")
        this.loadSkill[skillName] = require("View.Bingo.CardModule.Skill." .. requireName[2])
        if this.loadSkill[skillName] then
            this.loadSkill[skillName]:SetCardPower(this)
        end
    end
end

local CreatePosByServerPos = function(pos)
    return { index = ConvertServerPos(pos), state = 0 }
end

local CreatePosByClientPos = function(pos)
    return { index = pos, state = 0 }
end

local InitUnHitPosList = function(cardAllHitPos)
    this.unhitPosList = {}
    if cardAllHitPos and #cardAllHitPos > 0 then
        for i = 1, #cardAllHitPos do
            local ClientAllHitPosList = BattleTool.GetFromServerPos(cardAllHitPos[i].pos)
            local temp = {}
            for k = 1, 25 do
                if not fun.is_include(k, ClientAllHitPosList) then
                    table.insert(temp, CreatePosByClientPos(k))
                end
            end
            local cardId = cardAllHitPos[i].cardId
            this.unhitPosList[cardId] = temp
        end
    end
end

local InitHitPosList = function(cardAllHitPos)
    this.cardAllHitPos = {}
    if cardAllHitPos and #cardAllHitPos > 0 then
        for i = 1, #cardAllHitPos do
            local posList = {}
            for k = 1, #cardAllHitPos[i].pos do
                table.insert(posList, CreatePosByServerPos(cardAllHitPos[i].pos[k]))
            end
            local cardId = cardAllHitPos[i].cardId
            this.cardAllHitPos[cardId] = posList
        end
    end

end

local InitCardCallHitPosList = function(cardCallHitPos)
    this.cardCallHitPos = {}
    if cardCallHitPos and #cardCallHitPos > 0 then
        for i = 1, #cardCallHitPos do
            local posList = {}
            for k = 1, #cardCallHitPos[i].pos do
                table.insert(posList, CreatePosByServerPos(cardCallHitPos[i].pos[k]))
            end
            local cardId = cardCallHitPos[i].cardId
            this.cardCallHitPos[cardId] = posList
        end
    end

end

function CardPower:LoadCardAllHitPos()
    this.powerUpData = this.model:LoadGameData().powerUpData
    local cardAllHitPos = this.model:LoadGameData().cardAllHitPos
    InitUnHitPosList(cardAllHitPos)
    InitHitPosList(cardAllHitPos)
    local cardCallHitPos = this.model:LoadGameData().cardCallHitPos
    InitCardCallHitPosList(cardCallHitPos)
    this.jackPotList = this.model:LoadGameData().jackpot
    this.publishNumbers = this.model:LoadGameData().publishNumbers
    this.findMissPos = false
end

--固定形状盖章类PU的额外盖章位置
function CardPower:GetFixedShapePuSignPos(cardId)
    local list = {}
    local powerUpList = this.powerUpData.powerUpList
    local targetPuDatas = table.findAll(powerUpList, function(k, v)
        if not v.isUsed then
            local puCfg = Csv.GetData("new_powerup", v.powerUpId)
            local itemCfg = Csv.GetData("new_item", puCfg.item_id)
            local skillID = itemCfg and itemCfg.result and itemCfg.result[2]
            local skillCfg = skillID and Csv.GetData("new_skill", skillID)
            if skillCfg and skillCfg.skill_type == 0 then
                --固定形状盖章类
                return true
            end
        end
    end)
    
    if #targetPuDatas == 0 then
        return list
    end
    
    table.walk(targetPuDatas, function(targetPuData)
        table.walk(targetPuData.cardEffect, function(v)
            if v.cardId == cardId then
                local effectData = v.effectData
                local posList = BattleTool.GetFromServerPos(effectData.posList)
                table.walk(posList, function(pos)
                    if this:GetSign(cardId, pos) == 0 then
                        table.insert(list, pos)
                    end
                end)
            end
        end)
    end)

    list = fun.table_unique(list)
    
    return list
end

function CardPower:GetNoHitPos(cardId, needCount, state)
    for k, v in pairs(this.unhitPosList) do
        if k == cardId then
            local temp = {}
            for i = 1, #v do
                if this:GetSign(cardId, v[i].index) == 0 and v[i].state < state then
                    table.insert(temp, v[i].index)
                    if needCount == #temp then
                        return temp
                    end
                end
            end
            if needCount > #temp then
                log.r("没有足够数量的空格子")
            end
        end
    end
    return nil
end

function CardPower:GetHitPos(cardId, needCount, state)
    local posList = {}
    for k, v in pairs(this.cardAllHitPos) do
        if k == cardId then
            for i = 1, #v do
                if this:GetSign(cardId, v[i].index) == 0 and v[i].state < state then
                    table.insert(posList, v[i].index)
                end
            end
        end
    end
    
    if needCount > #posList then
        log.r("没有足够数量的空格子")
    end
    
    --在判断[会盖章位置]时，优先选择非[涂鸦笔PU]的额外盖章位置。
    local lowOrderPosList = this:GetFixedShapePuSignPos(cardId)
    if #lowOrderPosList > 0 then
        table.sort(posList, function(a, b) 
            local checkA = table.keyof(lowOrderPosList, a) ~= nil
            local checkB = table.keyof(lowOrderPosList, a) ~= nil
            if not checkA and checkB then
                return true
            elseif checkA and not checkB then
                return false
            end
            return a < b
        end)
    end
    
    local ret = {}
    table.walk(posList, function(v)
        if needCount > 0 then
            table.insert(ret, v)
            needCount = needCount - 1
        end
    end)
    
    return ret
end

function CardPower:GetHitPosInColumn(cardId, colum, needCount, needSameColum, state)
    local posList = {}
    for k, v in pairs(this.cardAllHitPos) do
        if k == cardId then
            for i = 1, #v do
                if this:GetSign(cardId, v[i].index) == 0 and v[i].state < state then
                    local cellColum = math.floor((v[i].index - 1) / 5)
                    if needSameColum and cellColum == colum then
                        table.insert(posList, v[i].index)
                    elseif not needSameColum and cellColum ~= colum then
                        table.insert(posList, v[i].index)
                    end
                end
            end
        end
    end

    if needCount > #posList then
        log.r("没有足够数量的空格子")
    end

    --在判断[会盖章位置]时，优先选择非固定形状技能的额外盖章位置。
    local lowOrderPosList = this:GetFixedShapePuSignPos(cardId)
    if #lowOrderPosList > 0 then
        table.sort(posList, function(a, b)
            local checkA = table.keyof(lowOrderPosList, a) ~= nil
            local checkB = table.keyof(lowOrderPosList, a) ~= nil
            if not checkA and checkB then
                return true
            elseif checkA and not checkB then
                return false
            end
            return a < b
        end)
    end

    local ret = {}
    table.walk(posList, function(v)
        if needCount > 0 then
            table.insert(ret, v)
            needCount = needCount - 1
        end
    end)
    
    return ret
end

---随机一个不重复当前列数字的号码
---@param canHit boolean 是否会被叫中 
function CardPower:RandomUnRepeatedNumber(card_index, had_num_table, canHit, startIndex)
    local rand_num = 0
    if startIndex > 15 then
        return 0
    end
    if card_index <= 5 then
        rand_num = startIndex + 1
    elseif card_index <= 10 then
        rand_num = startIndex + 16
    elseif card_index <= 15 then
        rand_num = startIndex + 31
    elseif card_index <= 20 then
        rand_num = startIndex + 46
    else
        rand_num = startIndex + 61
    end
    startIndex = startIndex + 1

    if fun.is_include(rand_num, had_num_table) then
        return this:RandomUnRepeatedNumber(card_index, had_num_table, canHit, startIndex)
    else
        local isHit = fun.is_include(rand_num, this.publishNumbers)
        if not canHit then
            if isHit then
                return this:RandomUnRepeatedNumber(card_index, had_num_table, canHit, startIndex)
            end
        else
            if not isHit then
                return this:RandomUnRepeatedNumber(card_index, had_num_table, canHit, startIndex)
            end
        end
    end
    return rand_num
end

function CardPower:GetSign(cardId, cellIndex)
    return this.model:GetRoundData(cardId, cellIndex):GetSignType()
end

function CardPower:GetGiftCount(cardId, cellIndex)
    return this.model:GetRoundData(cardId, cellIndex):GetGiftCount()
end

function CardPower:GetCardView()
    return this.cardView
end

function CardPower:GetModel()
    return this.model
end

local SingToCardWithMissingPos = function(cardEffects, upId)
    local extra_info = {}
    coroutine.start(function()
        table.walk(cardEffects, function(v, k)
            local cardId, effectData, temp = v.cardId, v.effectData, {}
            if this.model:GetRoundData(cardId):GetForbid() then
                return
            end

            coroutine.wait((k - 1) * GlobalArtConfig.PowerUpUseIntervalPerCard)

            local posList = BattleTool.GetFromServerPos(effectData.posList)
            for i = 1, #posList do
                LuaTimer:SetDelayFunction(GlobalArtConfig.DaubIntervalOnCard * (i - 1), function()
                    if this.model:GetRoundData(tostring(cardId), posList[i]).sign == 0 then
                        local cellObj = this.cardView:GetCardCell(tonumber(cardId), posList[i])
                        BattleEffectCache:GetCachedPrefab_BingoBang(cardId, "FreeDaub", {
                            targetObj = cellObj,
                            recycleTime = 2,
                            parentContainerType = BingoBangEntry.BattleContainerType.PuEffectContainer,
                            cb = function(obj)
                                if not IsNull(obj) then
                                    LuaTimer:SetDelayFunction(0.5, function()
                                        this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, posList[i], upId)
                                        this:ChangeCellState(cardId, posList[i], this.CellState.Signed)
                                    end)
                                else
                                    this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, posList[i], upId)
                                    this:ChangeCellState(cardId, posList[i], this.CellState.Signed)
                                end
                            end
                        })
                        table.insert(temp, posList[i])
                    else
                        local otherPos = this:GetNoHitPos(cardId, 1, this.CellState.Signed)
                        if #otherPos > 0 then
                            local cellObj = this.cardView:GetCardCell(tonumber(cardId), otherPos[1])
                            BattleEffectCache:GetCachedPrefab_BingoBang(cardId, "FreeDaub", {
                                targetObj = cellObj,
                                recycleTime = 2,
                                parentContainerType = BingoBangEntry.BattleContainerType.PuEffectContainer,
                                cb = function(obj)
                                    if not IsNull(obj) then
                                        LuaTimer:SetDelayFunction(0.5, function()
                                            this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, otherPos[1], upId)
                                            this:ChangeCellState(cardId, otherPos[1], this.CellState.Signed)
                                        end)
                                    else
                                        this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, otherPos[1], upId)
                                        this:ChangeCellState(cardId, otherPos[1], this.CellState.Signed)
                                    end
                                end
                            })
                            table.insert(temp, otherPos[1])
                        else
                            log.r("no find right cell")
                        end
                    end
                end)
                BingoBangEntry.DaubPowerDaubCount = BingoBangEntry.DaubPowerDaubCount + 1
            end
            extra_info[cardId] = temp
        end)
    end)
    return extra_info
end

local SignToCard = function(cardEffects, upId)
    local extra_info = {}
    if this.findMissPos then
        extra_info = SingToCardWithMissingPos(cardEffects, upId)
        return extra_info
    end

    coroutine.start(function()
        table.walk(cardEffects, function(v, k)
            local cardId, effectData, temp = v.cardId, v.effectData, {}
            if this.model:GetRoundData(cardId):GetForbid() then
                return
            end

            coroutine.wait((k - 1) * GlobalArtConfig.PowerUpUseIntervalPerCard)

            local posList = BattleTool.GetFromServerPos(effectData.posList)

            --排序，格子盖章顺序为：1、普通格子 2、技能格子 3、格子Bingo
            table.sort(posList, function(a, b)
                local cellA, cellB = this.model:GetRoundData(cardId, a), this.model:GetRoundData(cardId, b)
                --格子Bingo
                if cellA.self_bingo and not cellB.self_bingo then
                    return false
                end
                if not cellA.self_bingo and cellB.self_bingo then
                    return true
                end
                --技能
                local puA, puB = cellA:GetPowerupId(1), cellB:GetPowerupId(1)
                if puA and not puB then
                    return false
                end
                if not puA and puB then
                    return true
                end
                return false
            end)

            --local root = this.cardView:GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.PuEffectContainer)
            for i = 1, #posList do
                LuaTimer:SetDelayFunction(GlobalArtConfig.DaubIntervalOnCard * (i - 1), function()
                    local cellObj = this.cardView:GetCardCell(tonumber(cardId), posList[i])
                    BattleEffectCache:GetCachedPrefab_BingoBang(cardId, "FreeDaub", {
                        targetObj = cellObj,
                        recycleTime = 2,
                        parentContainerType = BingoBangEntry.BattleContainerType.PuEffectContainer,
                        cb = function(obj)
                            if not IsNull(obj) then
                                LuaTimer:SetDelayFunction(0.5, function()
                                    this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, posList[i], upId)
                                    this:ChangeCellState(cardId, posList[i], this.CellState.Signed)
                                end)
                            else
                                this.cardView:OnClickCardIgnoreJudgeByIndex(cardId, posList[i], upId)
                                this:ChangeCellState(cardId, posList[i], this.CellState.Signed)
                            end
                        end
                    })
                end)
                table.insert(temp, posList[i])
                BingoBangEntry.DaubPowerDaubCount = BingoBangEntry.DaubPowerDaubCount + 1
            end
            extra_info[cardId] = temp
        end)
    end)

    return extra_info
end

local CellBecomeBingoWithMissingPos = function(item_id, effectData, index)
    local detail = Csv.GetData("new_item", item_id)
    local extra_info = {}
    local upObj = this.cardView:GetParentView().powerView:GetPowerObj(index)
    local iconObj = fun.get_child(upObj, 0)
    coroutine.start(function()
        for k, v in pairs(effectData) do
            coroutine.wait((k - 1) * GlobalArtConfig.PowerUpUseIntervalPerCard)

            local cardId = v.cardId
            local temp = {}
            if not this.model:GetRoundData(cardId):GetForbid() then
                local posList = BattleTool.GetFromServerPos(v.posList)
                for i = 1, #posList do
                    local index = posList[i]
                    local obj = this.cardView:GetCardCell(cardId, index)
                    --Event.Brocast(EventName.CardItem_Cell_Add_Item, obj, detail["icon"], nil, detail["item_type"], cardId)
                    Event.Brocast(EventName.Cell_Become_BingoCell, cardId, index, 1)
                    this.model:SetRoundGiftData(k, index, item_id, 0, 0, 1)

                    local cloneParent = UnityEngine.GameObject.New()
                    local root = this.cardView:GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.PuEffectContainer)
                    fun.set_parent(cloneParent, root, true)
                    fun.set_same_position_with(cloneParent, this.cardView:GetPowerupView():GetOneCard())
                    local clone = fun.get_instance(iconObj, cloneParent)
                    fun.set_same_position_with(clone, iconObj)
                    fun.set_active(clone, true)
                    Event.Brocast(EventName.CardItem_Cell_Add_Item, obj, detail["icon"], clone, detail["item_type"], cardId, function()
                        local curModel = ModelList.BattleModel:GetCurrModel()
                        if not curModel or curModel:CanShowSkillCellWish() then
                            Event.Brocast(EventName.CardBingoEffect_ShowWish, cardId, index, true)
                            CalculateBingoMachine.CalculateWishByCard(cardId)
                        end
                    end)
                    table.insert(temp, posList[i])
                end
            end
            extra_info[cardId] = temp
        end
    end)
    return extra_info
end

--把n个格子变成Bingo格，点击直接生成Bingo
local CellBecomeBingo = function(item_id, effectData, index, powerUpId)
    if this.findMissPos then
        return CellBecomeBingoWithMissingPos(item_id, effectData, index)
    end
    local extra_info = {}
    local detail = Csv.GetData("new_item", item_id)
    local upObj = this.cardView:GetParentView().powerView:GetPowerObj(index)
    local iconObj = fun.get_child(upObj, 0)

    coroutine.start(function()
        for k, v in pairs(effectData) do
            local cardId = v.cardId
            local temp = {}
            if not this.model:GetRoundData(cardId):GetForbid() then
                coroutine.wait((k - 1) * GlobalArtConfig.PowerUpUseIntervalPerCard)

                local posList = BattleTool.GetFromServerPos(v.posList)
                for i = 1, #posList do
                    local index = posList[i]
                    local obj = this.cardView:GetCardCell(cardId, index)
                    Event.Brocast(EventName.Cell_Become_BingoCell, cardId, index, 1)
                    this.model:SetRoundGiftData(k, index, item_id, 0, 0, 1, powerUpId, v.extraPos)

                    local cloneParent = UnityEngine.GameObject.New()
                    local root = this.cardView:GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.PuEffectContainer)
                    fun.set_parent(cloneParent, root, true)
                    fun.set_same_position_with(cloneParent, this.cardView:GetPowerupView():GetOneCard())
                    local clone = fun.get_instance(iconObj, cloneParent)
                    fun.set_same_position_with(clone, iconObj)
                    fun.set_active(clone, true)
                    Event.Brocast(EventName.CardItem_Cell_Add_Item, obj, detail["icon"], clone, detail["item_type"], cardId, function()
                        local curModel = ModelList.BattleModel:GetCurrModel()
                        if not curModel or curModel:CanShowSkillCellWish() then
                            --单格bingo(4叶草)
                            Event.Brocast(EventName.CardBingoEffect_ShowWish, cardId, index, true)
                            CalculateBingoMachine.CalculateWishByCard(cardId)
                        end
                    end)
                    table.insert(temp, posList[i])
                end
            end
            extra_info[cardId] = temp
        end
    end)

    return extra_info
end

--PU使用结果
local PowerUpUseType = {
    ThrowItem = 1, --丢item或资源到卡片上
    SignToCard = 2, --随机涂抹号码
    DoubleNum = 3, --随机将n个格子变为双数字 
}

--使用powerup卡牌
function CardPower:UsePowerUpCard(powerupId, index)
    local info = Csv.GetData("new_powerup", powerupId)
    local result = info["result"]
    --local effectid = info["effectid"]
    local powerUpUseType = result[1]
    local extra_info = {}
    if RecorderMachine.powerIndex then
        RecorderMachine.powerIndex = index
    end
    log.b("UsePowerUpCard  " .. powerupId .. "   index " .. index)
    local powerUpList = this.powerUpData.powerUpList
    local targetPuData, puIndex = table.find(powerUpList, function(k, v)
        return powerupId == v.powerUpId and not v.isUsed
    end)
    if targetPuData then
        if powerUpUseType == PowerUpUseType.SignToCard then
            log.b("SignToCard  " .. powerupId .. "   index " .. index)
            extra_info = SignToCard(targetPuData.cardEffect, powerupId)
        elseif powerUpUseType == PowerUpUseType.ThrowItem then
            _throwItem:CreateItemsToCards(info["item_id"], targetPuData, puIndex, this)
            this:ChangeCellsState(extra_info, this.CellState.AddItem)
            UISound.play("powerup_item")
        elseif powerUpUseType == PowerUpUseType.DoubleNum then
            extra_info = _doubleNum:DoubleNumToCards(targetPuData.cardEffect, puIndex, info["icon"], powerupId)
            ModelList.BattleModel:GetCurrModel():AddDoubleNum(targetPuData.cardEffect)
            this:ChangeCellsState(extra_info, this.CellState.DoubleNum)
            UISound.play("powerup_item")
        elseif powerUpUseType == 6 then
            extra_info = CellBecomeBingo(info["itemid"], targetPuData.cardEffect, puIndex, targetPuData.powerUpId)
            this:ChangeCellsState(extra_info, this.CellState.AddItem)
            UISound.play("powerup_item")
            --elseif powerUpUseType == 7 then
            --    this:PetSkill(result[2])
        end
        targetPuData.isUsed = true
    end

    UISound.play("powerup_use")

    --发送请求
    --this.model.ReqUsePowerUp(puIndex or index, powerupId, extra_info)
    --if not ModelList.BattleModel:IsHangUp() and extra_info then
    --    if #extra_info > 2 then
    --        --this.view:GetParentView().switchView:RefreshCurrSwitch()
    --        Event.Brocast(EventName.Switch_View_Refresh,extra_info)
    --    end
    --end
    Event.Brocast(EventName.Recorder_Data, 5004, { index = index, powerupId = powerupId, effectid = 0, extra_info = extra_info })
end

function CardPower:ChangeCellState(cardId, index, state)
    cardId = tonumber(cardId)
    local data = this.cardAllHitPos[cardId]
    if data then
        for i = 1, #data do
            if data[i].index == index then
                if data[i].state < state then
                    data[i].state = state
                end
                break
            end
        end
    end
    local data2 = this.unhitPosList[cardId]
    if data2 then
        for i = 1, #data2 do
            if data2[i].index == index then
                if data2[i].state < state then
                    data2[i].state = state
                end
                break
            end
        end
    end
end

function CardPower:ChangeCellsState(posList, state)
    for k, v in pairs(posList) do
        for i = 1, #v do
            this:ChangeCellState(k, v[i], state)
        end
    end
end

function CardPower:SignCell(card_id, index)
    this:ChangeCellState(card_id, index, this.CellState.Signed)
end

function CardPower:ChangeFindMissPosState()
    this.findMissPos = true
    log.r("powerup 开始丢到不会命中的位置")
end

function CardPower:GetFindMissPosState()
    return this.findMissPos
end

function CardPower:GetCardAllHitPosData(cardId)
    return this.cardAllHitPos[cardId]
end

function CardPower:GetCardNoHitPosData(cardId)
    return this.unhitPosList[cardId]
end

function CardPower.Register()
    Event.AddListener(EventName.CardPower_Use_Power_Card, this.UsePowerUpCard)
    Event.AddListener(EventName.CardPower_Sign_Cell, this.SignCell)
    Event.AddListener(EventName.CardPower_Pet_Skill, this.PetSkill)
    Event.AddListener(EventName.CardPower_FindMissPos, this.ChangeFindMissPosState)
end

function CardPower.UnRegister()
    Event.RemoveListener(EventName.CardPower_Use_Power_Card, this.UsePowerUpCard)
    Event.RemoveListener(EventName.CardPower_Sign_Cell, this.SignCell)
    Event.RemoveListener(EventName.CardPower_Pet_Skill, this.PetSkill)
    Event.RemoveListener(EventName.CardPower_FindMissPos, this.ChangeFindMissPosState)
end

return this
