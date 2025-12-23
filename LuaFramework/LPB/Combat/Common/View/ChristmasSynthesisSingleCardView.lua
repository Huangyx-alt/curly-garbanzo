local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local ChristmasSynthesisSingleCardView = BaseSingleCard:New()
local this = ChristmasSynthesisSingleCardView

this.auto_bind_ui_items = {
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "I1",
    "I2",
    "I3",
    "I4",
    "I5",
    "N1",
    "N2",
    "N3",
    "N4",
    "N5",
    "G1",
    "G2",
    "G3",
    "G4",
    "G5",
    "O1",
    "O2",
    "O3",
    "O4",
    "O5",
    "b_letter",
    "reward1",
    "reward2",
    "reward_icon1",
    "rewardPar",
    "PerfectDaub",
    "letter_b",
    "letter_i",
    "letter_n",
    "letter_g",
    "letter_o",
    "icon",
    "ChipsContainer",
    "fooddz",
    "forbidCollide",
    "autoFlag",
    "storehouse",
    "signcellJBroot",
    "flash_clone",
    "gift_clone",
    "BingoTypeIcon",
    "BingoTypeTxt",
    "BingoScoreTxt",
    "BingoTypeIconAnima",
}

function ChristmasSynthesisSingleCardView:OnEnable(params)
    self:BuildFsm()
end

function ChristmasSynthesisSingleCardView:OnDestroy()
    FsmCreator:DisposeFsm(self)
end

function ChristmasSynthesisSingleCardView:on_after_bind_ref()
    -- anim:Play("item5idle")
    -- mask:Play("7_0")
end

function ChristmasSynthesisSingleCardView:BuildFsm()
    FsmCreator:Create("ChristmasSynthesisSingleCardView", self, {
        require("View.Bingo.ChristmasSynthesis.Bingo.IdleState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.BoxSignState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.BoxAllExitState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.ShowNewGiftState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.CheckChangeState"):New(),
        --require("View.Bingo.ChristmasSynthesis.Bingo.ShowFirstBingoState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.ShowFrameState"):New(),
        require("View.Bingo.ChristmasSynthesis.Bingo.ShowTxtRollState"):New(),
    })
    self.state = {
        IdleState = "IdleState",
        BoxSignState = "BoxSignState",
        BoxAllExitState = "BoxAllExitState",
        ShowNewGiftState = "ShowNewGiftState",
        CheckChangeState = "CheckChangeState",
        --ShowFirstBingoState = "ShowFirstBingoState",
        ShowFrameState = "ShowFrameState",
        ShowTxtRollState = "ShowTxtRollState",
    }
    self._fsm:StartFsm(self.state.IdleState)
end

function ChristmasSynthesisSingleCardView:BindObj(obj, parentView)
    self:on_init(obj, parentView)
    --local playid = ModelList.CityModel.GetPlayIdByCity()
    --local curModel = ModelList.BattleModel:GetCurrModel()
    --local collectLevel = curModel:GetCurrentCollectLevel()
    self.hadExitCells = {}
    self:RefreshBingoPanelData(0, 0)
end

function ChristmasSynthesisSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

function ChristmasSynthesisSingleCardView:OnCollectItem(cardId, cellIdx)
    self.cardId = cardId
    CalculateBingoMachine.OnDataChange(cardId, cellIdx)
    CalculateBingoMachine.CalcuateBingo(cardId, cellIdx)
end

function ChristmasSynthesisSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function ChristmasSynthesisSingleCardView:CellSignChange(cardId, cellIndex)
    self.cardId = cardId
    log.r("CellSignChange   ", cardId, cellIndex)
    CalculateBingoMachine.OnDataChange(cardId, cellIndex)
    if CalculateBingoMachine.SeekInfo(1, cardId) then ---调用查询接口，查询是否有新形成的bingo
        local data = CalculateBingoMachine.SeekInfo(2, cardId)
        if data then
            self:RecordGetNewBingo(true)
            self:ChangeState(self.state.BoxSignState)
            --this:PlayNewBingoAnima(data, cellIndex)
            CalculateBingoMachine:SetInfo(1, cardId, data)
            if not self.BingoDataQueue then
                self.BingoDataQueue = {}
            else
                self.BingoDataQueue = {}
            end
            table.insert(self.BingoDataQueue, { data = data, cellIndex = cellIndex })
        end
    else
        --CalculateBingoMachine.CalcuateBingo(cardId, cellIndex)
    end
end

function ChristmasSynthesisSingleCardView:RecordGetNewBingo(isNewBingo)
    self.isNewBingo = isNewBingo
    log.r("RecordGetNewBingo   ", tostring(isNewBingo))
end

function ChristmasSynthesisSingleCardView:IsGetNewBingo()
    return self.isNewBingo and self.isNewBingo or false
end

function ChristmasSynthesisSingleCardView:GetNewBingoData()
    return self.BingoDataQueue and self.BingoDataQueue[1] or nil
end

function ChristmasSynthesisSingleCardView:RemoveNewBingoData()
    if self.BingoDataQueue then
        self:SetOldBingoData(table.remove(self.BingoDataQueue, 1))
    end
end

function ChristmasSynthesisSingleCardView:SetOldBingoData(data)
    self.BingoOldData = data
end

function ChristmasSynthesisSingleCardView:GetOldBingoData()
    return self.BingoOldData and self.BingoOldData or nil
end

function ChristmasSynthesisSingleCardView:ChangeState(nextStateName)
    self._fsm:ChangeState(nextStateName)
end

---影响的所有格子礼盒,播放退出动画
function ChristmasSynthesisSingleCardView:CellsPlayExitAnima(cellIndexs)
    if cellIndexs then
        ---礼物盒集体退出效果
        for i, v in pairs(cellIndexs) do
            if not fun.is_include(v, self.hadExitCells) then
                local cellBox = ViewList.ChristmasSynthesisBingoView:GetCardView():GetCellBgEffect(self.cardId, v)
                if cellBox then
                    local anima = fun.get_component(cellBox, fun.ANIMATOR)
                    if anima then
                        anima:Play("end")
                    end
                end
                table.insert(self.hadExitCells, v)
            end
        end
    end
end

function ChristmasSynthesisSingleCardView:PlayOldGiftPlayExitEffect()
    ---旧礼物退出效果
    if fun.is_not_null(self.BingoPrefab) then
        local anima = fun.get_component(self.BingoPrefab, fun.ANIMATOR)
        if anima then
            anima:Play("end" .. ((self.direction and self.direction == 0) and "heng" or "shu"))
        end
        log.r("DelayRecycle  name " .. self.BingoPrefab.name)
        local real_name = (string.gsub(self.BingoPrefab.name, "(Clone)", ""))
        real_name = (string.gsub(real_name, "[()]", ""))
        --log.e("DelayRecycle  real_name " .. real_name)
        BattleEffectPool:DelayRecycle(real_name, self.BingoPrefab, 1)
    end
end

---播放新Bingo背景动画
function ChristmasSynthesisSingleCardView:PlayNewBingoAnima()
    local data = self:GetNewBingoData().data
    local cellIndex = self:GetNewBingoData().cellIndex
    local effContainer = ViewList.ChristmasSynthesisBingoView:GetEffectObjContainer()
    local cell = ModelList.ChristmasSynthesisModel:GetRoundData(data.cardId, data.firstCellIndex):GetCellObj()
    self.BingoPrefab, self.direction = effContainer:GetItemShowObjEffect(1, data.cardId, data.width, data.height, nil,
        cell)
    if self.BingoPrefab then
        fun.set_active(self.BingoPrefab, true)
        local anima = fun.get_component(self.BingoPrefab, fun.ANIMATOR)
        if anima then
            anima:Play("enter" .. ((self.direction and self.direction == 0) and "heng" or "shu"))
        end
        self:RefreshBingoPanelData(data.width, data.height)
        self:SaveSignForBingoData(data.cardId, cellIndex)
        self:ChangeState("CheckChangeState")
        self:PlayBingoSound(data)
    end
    self:RemoveNewBingoData()
end

---卡面Bingo奖励刷新效果
function ChristmasSynthesisSingleCardView:PlayBingoRewardRefresh()
    local data = self:GetOldBingoData().data
    if data then
        self:RefreshBingoPanelData(data.width, data.height)
    end
end

function ChristmasSynthesisSingleCardView:PlayBingoSound(bingoInfo)
    local width = bingoInfo.width or 0
    local height = bingoInfo.height or 0
    local area = width * height
    local soundName1, soundName2
    if area == 25 then
        soundName1 = "santablessingjackpot"
        soundName2 = "santablessingbags"
    elseif area == 20 then
        soundName1 = "santablessingbingoRampage"
        soundName2 = "santablessingtrain"
    elseif area == 16 then
        soundName1 = "santablessingquadrabingo"
        soundName2 = "santablessingdrum"
    elseif area == 15 then
        soundName1 = "santablessingtriplebingo"
        soundName2 = "santablessingtrojan"
    elseif area == 12 then
        soundName1 = "santablessingdoublebingo"
        soundName2 = "santablessingairplane"
    else
        soundName1 = "santablessingbingo"
        soundName2 = "santablessingteddy"
    end
    UISound.play(soundName1)
    UISound.play(soundName2)
end

function ChristmasSynthesisSingleCardView:PlayFirstBingoEffect()
    local data = self:RemoveSignForBingoData()
    CalculateBingoMachine.CalcuateBingo(data.cardId, data.cellIndex)
end

---保存一个造成bingo的盖章数据
function ChristmasSynthesisSingleCardView:SaveSignForBingoData(cardId, cellIndex)
    if not self.BingoCalculateOrder then self.BingoCalculateOrder = {} end
    table.insert(self.BingoCalculateOrder, { cardId = cardId, cellIndex = cellIndex })
end

---移除一个造成bingo的盖章数据
function ChristmasSynthesisSingleCardView:RemoveSignForBingoData()
    if self.BingoCalculateOrder and #self.BingoCalculateOrder > 0 then
        return table.remove(self.BingoCalculateOrder, 1)
    end
end

--- 是否展示过bingo效果
function ChristmasSynthesisSingleCardView:IsShowBingoEffect()
    if not self.isShowBingoEffect then
        self.isShowBingoEffect = true
        return false
    end
    return true
end

--- 恢复未参与合成的格子礼盒动画
function ChristmasSynthesisSingleCardView:RecoverOldGiftAnima(cellIndexs)
    if cellIndexs then
        ---礼物盒集体入场效果
        for i, v in pairs(cellIndexs) do
            if fun.is_include(v, self.hadExitCells) then
                local cellBox = ViewList.ChristmasSynthesisBingoView:GetCardView():GetCellBgEffect(self.cardId, v)
                if cellBox then
                    local anima = fun.get_component(cellBox, fun.ANIMATOR)
                    if anima then
                        anima:Play("in")
                    end
                end
                fun.remove_table_item(self.hadExitCells, v)
            end
        end
    end
end

---获取已经退出动画的格子
function ChristmasSynthesisSingleCardView:GetHadExitCells()
    return self.hadExitCells
end

---获取合成图案占用格子索引的列表
function ChristmasSynthesisSingleCardView:GetSynthesisMapCellIndexs()
    local newData = self:GetNewBingoData()
    if newData and newData.data then
        local cellsIndex = {}
        for i = 0, newData.data.width - 1 do
            for j = 0, newData.data.height - 1 do
                table.insert(cellsIndex, newData.data.firstCellIndex + (j * 5) + (i))
            end
        end
        return cellsIndex
    end
end

--- 刷新卡片的底部Bingo面板数据
function ChristmasSynthesisSingleCardView:RefreshBingoPanelData(currWidth, currHeight)
    if fun.is_null(self.BingoScoreTxt) then return end
    self.BingoScoreTxt.text = "0"
    local nextInfoIcon, nextInfoName, nextInfoNum = self:GetNextBingoTypeInfo(currWidth * currHeight)
    self.BingoTypeIcon.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", nextInfoIcon)
    self.BingoTypeTxt.text = nextInfoName
    local curModel = ModelList.ChristmasSynthesisModel
    if curModel then
        local reward = curModel:GetBingoReward2(nextInfoNum)
        self.BingoScoreTxt:RollByTime(reward, 2, nil)
    end
    self.BingoTypeIconAnima:Play("enter")
end

--- 根据现有bingo类型展示下一个阶段的奖励
function ChristmasSynthesisSingleCardView:GetNextBingoTypeInfo(bingoType)
    if bingoType == 0 then
        return "SDLwSmall33", "3X3", 1
    elseif bingoType == 9 then
        return "SDLwSmall34", "3X4", 2
    elseif bingoType == 12 then
        return "SDLwSmall35", "3X5", 3
    elseif bingoType == 15 then
        return "SDLwSmall44", "4X4", 4
    elseif bingoType == 16 then
        return "SDLwSmall45", "4X5", 5
    elseif bingoType == 20 then
        return "SDLwSmall55", "5X5", 6
    elseif bingoType == 25 then
        return "SDLwSmall55", "5X5", 6
    else
        return "SDLwSmall33", "3X3", 1
    end
end

---如果是重合的格子,额外增加一套大的圣诞老人表现
function ChristmasSynthesisSingleCardView:ShowExtraChristmasManEffect(oldBingoData)
    local effContainer = ViewList.ChristmasSynthesisBingoView:GetEffectObjContainer()
    local cell = ModelList.ChristmasSynthesisModel:GetRoundData(oldBingoData.cardId, oldBingoData.firstCellIndex)
        :GetCellObj()
    self.ChristmasManPrefab, self.ChristmasMandirection = effContainer:GetItemShowObjEffect(2, oldBingoData.cardId,
        oldBingoData.width,
        oldBingoData.height, 2, cell)
    if self.ChristmasManPrefab then
        --fun.set_same_position_with(self.ChristmasManPrefab, cell)
        fun.set_active(self.ChristmasManPrefab, true)
        local anima = fun.get_component(self.ChristmasManPrefab, fun.ANIMATOR)
        if anima then
            anima:Play("enter" .. ((self.ChristmasMandirection and self.ChristmasMandirection == 0) and "heng" or "shu"))
        end
    end
end

---额外增加一套小的圣诞老人表现
function ChristmasSynthesisSingleCardView:ShowExtraSmallChristmasManEffect(cells, cardId)
    --local effContainer = ViewList.ChristmasSynthesisBingoView:GetEffectObjContainer()
    for i = 1, #cells do
        local cell = ModelList.ChristmasSynthesisModel:GetRoundData(cardId, cells[i]):GetCellObj()
        local obj = BattleEffectPool:GetAndBind("laotou_1", cell, cardId, 2)
        if obj then
            --local par = ViewList.ChristmasSynthesisBingoView:GetCardView():GetCardMap(cardId)
            --fun.set_parent(obj, par)
            local par = ViewList.ChristmasSynthesisBingoView:GetCardView():GetCardMap(cardId)
            local ref_temp = fun.get_component(par, fun.REFER)
            local ChipsContainer = ref_temp and ref_temp:Get("ChipsContainer")
            fun.set_parent(obj, ChipsContainer or par)
            fun.set_same_rotation_with(obj, ChipsContainer or par)
            fun.set_gameobject_scale(obj, 1, 1, 1)
            --fun.set_same_world_scale_with(obj,cell)
            --fun.SetAsLastSibling(obj)
        end
    end
    UISound.play("santablessingmerge")
end

local function CheckGiftType(cardId)
    local data = CalculateBingoMachine.SeekInfo(3, cardId)
    if data and data.width then ---调用查询接口，查询是否有新形成的bingo
        local bgName = "SDXkDI" .. data.height .. "x" .. data.width
        if data.width * data.height == 9 then
            return data.firstCellIndex, 6, 0, 0, bgName
        elseif data.width == 3 and data.height == 4 then
            return data.firstCellIndex, 6, 0.5, 0, bgName
        elseif data.width == 3 and data.height == 5 then
            return data.firstCellIndex, 11, 0, 0, bgName
        elseif data.width == 4 and data.height == 4 then
            return data.firstCellIndex, 6, 0.5, 0.5, bgName
        elseif data.width == 4 and data.height == 5 then
            return data.firstCellIndex, 12, 0, 0, bgName
        elseif data.width == 5 and data.height == 3 then
            return data.firstCellIndex, 7, 0, 0, bgName
        elseif data.width == 5 and data.height == 4 then
            return data.firstCellIndex, 7, 0.5, 0, bgName
        elseif data.width == 5 and data.height == 5 then
            return data.firstCellIndex, 12, 0, 0, nil
        end
    end
    return nil
end

---合成范围出现外框表现
function ChristmasSynthesisSingleCardView:ShowFrameEffect(newBingoData)
    local giftFirstIndex, addIndex, indexOffsetX, indexOffsetY, bgName = CheckGiftType(newBingoData.cardId)
    if giftFirstIndex and self.GiftBg then
        if not bgName then ---5*5的格子 不需要背景
            self.GiftBg.enabled = false
        else
            self.GiftBg.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", bgName)
            self.GiftBg:SetNativeSize()
        end
        local x = math.modf((giftFirstIndex + addIndex - 1) / 5)
        local y = math.modf((giftFirstIndex + addIndex - 1) % 5)
        fun.set_gameobject_pos(self.GiftBg.gameObject, 106.65 + 25.9 * (x + indexOffsetX),
            -108.6 - 26 * (y + indexOffsetY), 0, true)
        fun.set_active(self.GiftBg, true)
    else
        fun.set_active(self.GiftBg, false)
    end
end

function ChristmasSynthesisSingleCardView:GetCardId()
    return self.cardId
end

---检查卡片是否处于idle状态
function ChristmasSynthesisSingleCardView:IsIdle()
    if not self or not self._fsm then
        return true
    end
    return self._fsm:GetCurName() == self.state.IdleState or false
end

return this
