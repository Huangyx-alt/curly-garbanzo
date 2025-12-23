
local PiggySlotsGameReel = BaseView:New("PiggySlotsGameReel")
local this = PiggySlotsGameReel
this.viewType = CanvasSortingOrderManager.LayerType.none
this.auto_bind_ui_items = {
   "element1", 
   "element2", 
   "element3", 
   "element4", 
}


local itemHeight = 200.5 --每个格子高度
local itemHeightOffset = 0 --每个格子竖向间距
local rollCellSpeed = 400
local stopFinishAnimTime = 0.2

local rollSpeed = 4
local elementNum = 4 --每竖列元素数量
-- local bottomItemPosY = -840 --最底部的格子位置 --(200 + 10) * 4 --不用回弹用这个
local bottomItemPosY = -800 --最底部的格子位置 --(200 + 10) * 4 --不用回弹用这个

local topItemPosY = 10

local piggyAnimTime =
{
    Hide1X1 = 1.5,
    Hide1X2 = 1.5,
    Hide1X3 = 1.5,
    Hide2X3 = 1.5,
    BreakTime = 2,
}

local elementList = 
{
    [38001] = "GoldenPigPinkSGameIcon11", --小猪图标 其他4个是普通图标
    [38002] = "GoldenPigPinkSGameIcon01",
    [38003] = "GoldenPigPinkSGameIcon03",
    [38004] = "GoldenPigPinkSGameIcon05",
    [38005] = "GoldenPigPinkSGameIcon04",
}

local piggyAnimName =
{
    Piggy1x1Idle = "idle1",
    Piggy1x1End = "end1",
    Piggy1x1Over = "over1",

    Piggy1x2Enter = "enter2",
    Piggy1x2Idle = "idle2",
    Piggy1x2End = "end2",
    Piggy1x2Over = "over2",

    Piggy1x3Enter = "enter3",
    Piggy1x3Idle = "idle3",
    Piggy1x3End = "end3",
    Piggy1x3Over = "over3",

    Piggy2x3Enter = "enter4",
    Piggy2x3Idle = "idle4",
    Piggy2x3End = "end4",
    Piggy2x3Over = "over4",

}

local reelRollState = 
{
    StateIdle = "StateIdle",        --静止状态
    StateRolling = "StateRolling",   --循环滚动
    StateStop = "StateStop",          --停止等待替换
    StateStopFinish = "StateStopFinish",  --替换后到完全停下
}

function PiggySlotsGameReel:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PiggySlotsGameReel:Awake()
end

function PiggySlotsGameReel:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.rollState = reelRollState.StateIdle
    self:SetReelData(self.reelIndex , self.mainCode, self.effectNormal, self.effectParent, self.initElementData)
end

function PiggySlotsGameReel:on_after_bind_ref()
    self:InitItem()
end

function PiggySlotsGameReel:OnDisable()
    self:ClearHideEffectDelay()
    self:ClearPiggyBreakDelay()
    Facade.RemoveViewEnhance(self)
end

function PiggySlotsGameReel:SetReelData(index, mainCode , effectNormal, effectParent,initElementData)
    self.reelIndex = index or self.reelIndex
    self.mainCode = mainCode or self.mainCode
    self.effectNormal = effectNormal or self.effectNormal
    self.effectParent = effectParent or self.effectParent
    self.initElementData = initElementData or self.initElementData
    if self.isInit then
        self:InitElement()
    end
end

function PiggySlotsGameReel:NewCardInitElement(initElement)
    self:InitElement()
end

function PiggySlotsGameReel:InitElement()
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local spriteName = elementList[self.initElementData[i].elementId]
            local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
            fun.set_ctrl_sprite(item, sprite)
        end 
    end
end

function PiggySlotsGameReel:StartRoll(isInitSpin)
    self.rollState = reelRollState.StateRolling
    self.isInitSpin = isInitSpin or false
    self.playPiggyShowAudio = false
end

function PiggySlotsGameReel:StopRoll()
    self.cellReplaceList = {} --每个格子都需要换次图
    self.rollState = reelRollState.StateStop
    self:CalShowResultCell()
end

function PiggySlotsGameReel:StopRollToFinish()
    self.rollState = reelRollState.StateStopFinish
    self:AnimMoveStopFinish()
end


function PiggySlotsGameReel:InitItem()
    self.rollState = reelRollState.StateIdle
end

function PiggySlotsGameReel:ReelRoll(deltaTime)
    if self.rollState == reelRollState.StateIdle then
        --静止状态
        return
    end

    if self.rollState == reelRollState.StateRolling then
        self:ReelRolling(deltaTime)
    elseif self.rollState == reelRollState.StateStop then
        self:ReelRollStop(deltaTime)
    elseif self.rollState == reelRollState.StateStopFinish then
        --替换后到完全停止
        self:ReelRollStopFinish(deltaTime)
    else
        log.log('错误未知的状态')
    end
end

function PiggySlotsGameReel:ReelRolling(deltaTime)
    local offset = deltaTime * rollCellSpeed * rollSpeed
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local pos  = fun.get_rect_anchored_position(item)
            --正常滚动
            if pos.y < bottomItemPosY then
                fun.set_rect_anchored_position_y(item, pos.y + math.abs(bottomItemPosY)- offset)
                self:ReplaceCellElementRandom(item)
            else
                fun.set_rect_anchored_position_y(item, pos.y - offset)
            end 
        end 
    end
end

--不马上停止转动，等3个展示结果元素每个都替换一次
function PiggySlotsGameReel:ReelRollStop(deltaTime)
    local offset = deltaTime * rollCellSpeed * rollSpeed
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local pos  = fun.get_rect_anchored_position(item)
            --正常滚动
            if pos.y < bottomItemPosY then
                fun.set_rect_anchored_position_y(item, pos.y + math.abs(bottomItemPosY)- offset)
                local finishReplace =  self:ReplaceResultElement(i,item)
                if finishReplace then
                    self:StopRollToFinish()
                    break
                end
            else
                fun.set_rect_anchored_position_y(item, pos.y - offset)
            end
        end 
    end
end

function PiggySlotsGameReel:ReplaceCellElementRandom(item)
    local spriteTestIndex = math.random(PiggySlotsElementId.PiggyBank,PiggySlotsElementId.Gold)
    local spriteName = elementList[spriteTestIndex]
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end


function PiggySlotsGameReel:ReplaceCellElementStop(item)
    local spriteTestIndex = math.random(PiggySlotsElementId.BlueSafeBox,PiggySlotsElementId.Gold) --停轴时不随机转出小猪
    local spriteName = elementList[spriteTestIndex]
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end

function PiggySlotsGameReel:ReplaceCellElementResult(cellIndex,item)
    local reelResult = self:GetResultElement()
    if not reelResult then
        log.log("错误 缺少配置 reelResult")
        return
    end

    local cellTableIndex = self.cellReplaceList[cellIndex].tableIndex
    local resultIndex = self:GetShowElementCellIndex(cellTableIndex)
    -- log.log("检查spin停止结果 a" , self.reelIndex , cellIndex ,  reelResult  , "    " ,  self.cellReplaceList)
    -- if resultIndex < 1 or not  reelResult[resultIndex] then
    if not resultIndex or not  reelResult[resultIndex] then
        log.log("错误 缺少配置b cellTableIndex" , cellTableIndex)
        log.log("错误 缺少配置c reelResult" ,reelResult)
        log.log("错误 缺少配置c reelResult" ,self.cellReplaceList[cellIndex])
        return
    end
    local cellResult = reelResult[resultIndex].elementId
    local spriteName = elementList[cellResult]
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end

function PiggySlotsGameReel:ReplaceResultElement(cellIndex,item)
    -- log.log("小猪slots 转轴滚动分类 ReplaceResultElement" , self.reelIndex, cellIndex , self.cellReplaceList)
    if self.cellReplaceList[cellIndex].isNeedReplace then
        self:ReplaceCellElementResult(cellIndex,item)
        self.cellReplaceList[cellIndex].isReplace = true
    else
        self:ReplaceCellElementStop(item)
    end

    local isFinishReplace = true
    for i = 1 , elementNum do
        if self.cellReplaceList[i].isNeedReplace and not self.cellReplaceList[i].isReplace then
            isFinishReplace = false
        end
    end
    -- log.log("点击后替换的" ,cellIndex ,  isFinishReplace, self.cellReplaceList)
    return isFinishReplace
end

function PiggySlotsGameReel:GetCellResultIndex(bottomCellIndex , offsetNum)
    if bottomCellIndex - offsetNum < 1 then
        return bottomCellIndex - offsetNum + elementNum        
    end
    return bottomCellIndex - offsetNum
end

function PiggySlotsGameReel:GetCellTopIndex(index)
    if index == 1 then
        return elementNum
    end

    return index - 1
end

--cellindex : element1 - 5
--tabliendex :牌面上 从上到下  1-5
function PiggySlotsGameReel:InsertResultCellList(cellIndex ,tableIndex , isNeedReplace , isReplace, isResult)
    -- log.log("滚动效果 展示结果的3个元素序号 插入" , cellIndex , tableIndex , isNeedReplace , isReplace)
    self.cellReplaceList[cellIndex] = {tableIndex = tableIndex ,isNeedReplace = isNeedReplace , isReplace = isReplace , isResult = isResult}
end

--获取展示3个牌面结果的元素序号
function PiggySlotsGameReel:CalShowResultCell()
    local reslutBottomIndex = self:GetBottomCell()
    local cellIndex1 = self:GetCellResultIndex(reslutBottomIndex , 2)
    local cellIndex2 = self:GetCellResultIndex(reslutBottomIndex , 1)

    local topCellIndex = self:GetCellTopIndex(cellIndex1)
    -- log.log("滚动效果 插入数据检查" , topCellIndex , cellIndex1 , cellIndex2  ,reslutBottomIndex )
  
    self.cellReplaceList = {}
    self:InsertResultCellList(cellIndex1 , 2 , true , false , true)
    self:InsertResultCellList(cellIndex2 , 3 ,true , false , true)
    self:InsertResultCellList(reslutBottomIndex , 4 ,true , false , true)
    self:InsertResultCellList(topCellIndex , 1 ,false , false, false)

    -- log.log("滚动效果 展示结果的3个元素序号" , self.reelIndex, reslutBottomIndex  , self.cellReplaceList)
end

--获取最底部的格子id
function PiggySlotsGameReel:GetBottomCell()
    local cellList = {}
    local bottomCell = nil
    local compareCellPosY = nil
    local compareCellIndex = nil
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local pos  = fun.get_rect_anchored_position(item)
            if not compareCellIndex and not compareCellPosY then
                compareCellIndex = i
                compareCellPosY = pos.y
            else
                if pos.y < compareCellPosY then
                    compareCellIndex = i
                    compareCellPosY = pos.y
                end
            end
        end
    end
    return compareCellIndex 
end

function PiggySlotsGameReel:GetCellTargetPosY(tableIndex)

    return  topItemPosY -(tableIndex - 1) * (itemHeight + itemHeightOffset) -7
end

function PiggySlotsGameReel:ReelRollStopFinish(deltaTime)
end

function PiggySlotsGameReel:AnimMoveStopFinish()
    for  i = 1 , elementNum do
        if self.cellReplaceList[i].isNeedReplace then
            --中间3个格子结果
            self:AnimResultItemStopFinish(i)
        elseif self.cellReplaceList[i].tableIndex == 1 then
            --最顶端的
            self:AnimTopItemStopFinish(i)
        elseif self.cellReplaceList[i].tableIndex == elementNum then
            --最底部的
            self:AnimBottomItemStopFinish(i)
        end
    end
end

function PiggySlotsGameReel:AnimResultItemStopFinish(index)
    local tableIndex = self.cellReplaceList[index].tableIndex 
    local curIndex = self:GetShowElementCellIndex(tableIndex)
    local targetPos = self:GetCellTargetPosY(tableIndex)
    local item = self["element" .. index]
    local curve = DG.Tweening.Ease.OutBack
    Anim.move_ease(item,0,targetPos,0,stopFinishAnimTime,true,curve,function()
        local result = self:GetResultElement()
        if result[curIndex] and result[curIndex].elementId == PiggySlotsElementId.PiggyBank and self:CheckCreatTypeEffect(curIndex,PiggySlotsEffectType.Piggy1x1) then
            local parent = self:GetEffectParent(curIndex)
            local effectName = string.format("%s%s%s%s","cellEffect:1x1:" , self.reelIndex,"_" , curIndex)
            local effect = self.mainCode:GetPiggyEffect(parent , effectName)
            self:PlayAnimator(effect , piggyAnimName.Piggy1x1Idle)
            effect.transform.localPosition = Vector3.zero
            self:AddEffect(curIndex,effect, PiggySlotsEffectType.Piggy1x1)
            self:SignReelEffectData(curIndex , PiggySlotsEffectType.Piggy1x1)
            self:PlayPiggyShowAudio(index)
        end
    end)
end

function PiggySlotsGameReel:PlayPiggyShowAudio(index)
    if self.playPiggyShowAudio then
        return
    end
    self.playPiggyShowAudio = true
    UISound.play("piggypigshow")
end

function PiggySlotsGameReel:AnimBottomItemStopFinish(index)
    local targetPos = self:GetCellTargetPosY(self.cellReplaceList[index].tableIndex)
    local item = self["element" .. index]
    -- local curve = DG.Tweening.Ease.Unset
    -- local curve = DG.Tweening.Ease.OutFlash
    local curve = DG.Tweening.Ease.OutBack  --有回弹
    -- local curve = DG.Tweening.Ease.Linear
    -- local curve = DG.Tweening.Ease.InFlash
    -- local curve = DG.Tweening.Ease.InBack

    Anim.move_ease(item,0,targetPos,0,stopFinishAnimTime,true,curve,function()
        -- log.log("格子滚动效果 到达位置检查" , item.name)
    end)
end

function PiggySlotsGameReel:AnimTopItemStopFinish(index)
    local item = self["element" .. index]
    local pos  = fun.get_rect_anchored_position(item)
    if pos.y > bottomItemPosY then
        local curve = DG.Tweening.Ease.OutBack
        Anim.move_ease(item,0,bottomItemPosY,0,stopFinishAnimTime,true,curve,function()
            fun.set_rect_anchored_position_y(item, topItemPosY) --修改后的
            UISound.play("piggyslotstop")
        end)
    else
        fun.set_rect_anchored_position_y(item, topItemPosY) --修改后的
        UISound.play("piggyslotstop")
    end
end

function PiggySlotsGameReel:GetResultElement()
    local result = nil
    if self.isInitSpin then
        result = ModelList.PiggySloltsGameModel.GetInitSpinResult(self.reelIndex)
    else
        result = ModelList.PiggySloltsGameModel.GetResultElementData(self.reelIndex)
    end
    return result
end

function PiggySlotsGameReel:GetTargetRow(row)
    local order = 
    {
        [1] = 4,
        [2] = 3,
        [3] = 2
    }
    return order[row]
end

function PiggySlotsGameReel:GetShowElementCellIndex(cellIndex)
    local order = 
    {
        [2] = 3,
        [3] = 2,
        [4] = 1
    }
    return order[cellIndex]
end

function PiggySlotsGameReel:AddEffect(row,effect,effectType)
    self.effectList = self.effectList or {}
    self.effectList[row] = self.effectList[row] or {}
    self.effectList[row][effectType] = {effectType = effectType , effect = effect, isFake = false}
end

function PiggySlotsGameReel:RemoveFakeSig(row,effectType)
    if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
        log.log("小猪机台 删除特效 col:", self.reelIndex  ,  "  row:" , row ,  "  effectType: " , effectType)
        self.mainCode:BackPiggyEffect(self.effectList[row][effectType].effect)
        self.effectList[row][effectType] = nil
    end
end

function PiggySlotsGameReel:ShowResetPiggy(col)
    for row = 1, 3 do
        self:ShowEffect2X3Hide(row,PiggySlotsEffectType.Piggy2x3)
    end
end

function PiggySlotsGameReel:ShowAllLowLevelEffectHide(checkLevel)
    for row = 1, 3 do
        self:ShowLowLevelEffectHide(row,checkLevel)
    end
end

function PiggySlotsGameReel:ShowRowLowLevelEffectHide(row,checkLevel)
    self:ShowLowLevelEffectHide(row,checkLevel)
end


function PiggySlotsGameReel:ShowLowLevelEffectHide(row, checkLevel)
    if checkLevel == PiggySlotsEffectType.Piggy1x1 then
    elseif checkLevel == PiggySlotsEffectType.Piggy1X2 then  
        self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
    elseif checkLevel == PiggySlotsEffectType.Piggy1X3 then
        self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
        self:ShowEffect1X2Hide(row, PiggySlotsEffectType.Piggy1X2)
    elseif checkLevel == PiggySlotsEffectType.Piggy2x3 then
        self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
        self:ShowEffect1X2Hide(row, PiggySlotsEffectType.Piggy1X2)
        self:ShowEffect1X3Hide(row, PiggySlotsEffectType.Piggy1X3)
    end
end

function PiggySlotsGameReel:ShowEffect1X1Hide(row,effectType)
    if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
        self:PlayAnimator(self.effectList[row][effectType].effect , piggyAnimName.Piggy1x1End)
        -- self:RemoveFakeSig(row,effectType)
        local effect = self.effectList[row][effectType].effect
        local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
            -- self:DestroyEffect(row , effectType)
              self.mainCode:BackPiggyEffect(effect)
        end)
        self.effectList[row][effectType] = nil
        self:AddHideEffectDelay(delayFunc)
    end
end

function PiggySlotsGameReel:ShowEffect1X2Hide(row,effectType)
    if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
        self:PlayAnimator(self.effectList[row][effectType].effect , piggyAnimName.Piggy1x2End)
        local effect = self.effectList[row][effectType].effect
        local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
            --self:DestroyEffect(row , effectType)
            self.mainCode:BackPiggyEffect(effect)
        end)
        self.effectList[row][effectType] = nil
        self:AddHideEffectDelay(delayFunc)
    end
end

function PiggySlotsGameReel:ShowEffect1X3Hide(row,effectType)
    if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
        -- fun.play_animator(self.effectList[row][effectType].effect,piggyAnimName.Piggy1x3End,true)
        self:PlayAnimator(self.effectList[row][effectType].effect , piggyAnimName.Piggy1x3End)
        local effect = self.effectList[row][effectType].effect
        local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
            -- self:DestroyEffect(row , effectType)
            self.mainCode:BackPiggyEffect(effect)
        end)
        self.effectList[row][effectType] = nil
        self:AddHideEffectDelay(delayFunc)
    end
end

function PiggySlotsGameReel:ShowEffect2X3Hide(row,effectType)
    if self.effectList and self.effectList[row] and self.effectList[row][effectType] then
        if fun.is_not_null(self.effectList[row][effectType].effect) then
            self:PlayAnimator(self.effectList[row][effectType].effect , piggyAnimName.Piggy2x3End)
            local effect = self.effectList[row][effectType].effect
            local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide2X3, function()
                -- self:DestroyEffect(row , effectType)
                self.mainCode:BackPiggyEffect(effect)
            end)
            self.effectList[row][effectType] = nil
            self:AddHideEffectDelay(delayFunc)
        elseif self.effectList[row][effectType].isFake then
            self.effectList[row][effectType] = nil
        end
    end
end

function PiggySlotsGameReel:Creat2X3Effect(row, pos)
    local effectParent = self:GetEffectParent(row)
    local effectName = string.format("%s%s%s%s","cellEffect:2x3:" , self.reelIndex,"_" , row)

    local effect = self.mainCode:GetPiggyEffect(effectParent,effectName)
    effect.transform.position = pos
    self:PlayAnimator(effect , piggyAnimName.Piggy2x3Enter)
    self:AddEffect(row,effect,PiggySlotsEffectType.Piggy2x3)
end

function PiggySlotsGameReel:Creat1X3Effect()
    local posRow = 2
    local parentRow = 1
    local effectParent = self:GetEffectParent(posRow)
    local effectName = string.format("%s%s%s%s","cellEffect:1x3:" , self.reelIndex,"_" , posRow)
    local effect = self.mainCode:GetPiggyEffect(effectParent , effectName)
    effect.transform.localPosition = Vector3.zero
    self:PlayAnimator(effect , piggyAnimName.Piggy1x3Enter)
    self:AddEffect(parentRow,effect,PiggySlotsEffectType.Piggy1X3)
    self:SignReelEffectData(2 , PiggySlotsEffectType.Piggy1X3)
    self:SignReelEffectData(3 , PiggySlotsEffectType.Piggy1X3)
end

function PiggySlotsGameReel:Creat1X2Effect(startRow,finishRow, pos)
    local effectParent = self:GetEffectParent(startRow)
    local effectName = string.format("%s%s%s%s","cellEffect:1x2:" , self.reelIndex,"_" , startRow)
    local effect = self.mainCode:GetPiggyEffect(effectParent, effectName, self.reelIndex , startRow)
    effect.transform.position = pos
    self:PlayAnimator(effect , piggyAnimName.Piggy1x2Enter)
    self:AddEffect(startRow,effect,PiggySlotsEffectType.Piggy1X2)
    self:SignReelEffectData(finishRow , PiggySlotsEffectType.Piggy1X2)
end

function PiggySlotsGameReel:GetEffectParent(row)
    return self.mainCode:GetEffectParent(self.reelIndex , row)
end

function PiggySlotsGameReel:SignReelEffectData(row , effectType)
    self.effectList = self.effectList or {}
    self.effectList[row] = self.effectList[row] or {}
    self.effectList[row][effectType] = self.effectList[row][effectType] or {}
    if self.effectList[row][effectType] then
        if self.effectList[row][effectType].effect then
            local effect = self.effectList[row][effectType].effect
            self.effectList[row][effectType] = {effectType = effectType , effect = effect, isFake = false}
        else
            self.effectList[row][effectType] = {effectType = effectType , effect = nil, isFake = true}
        end
    end
end
-- row = 1  effectType = 3
function PiggySlotsGameReel:CheckCreatTypeEffect(row , effectType)
    if self.effectList and self.effectList[row]  then
        for k , v in pairs(self.effectList[row]) do
            if v.effectType >= effectType then
                return false
            end
        end
    end
    return true
end


function PiggySlotsGameReel:ShowOpenReward(row,piggyType , winCoin)
    -- log.log("特效开启数据" ,  self.reelIndex , row, self.effectList)
     if self.effectList[row] and self.effectList[row][piggyType] and fun.is_not_null(self.effectList[row][piggyType].effect) then
        local parent = self.effectList[row][piggyType].effect.transform.parent
        self:AddPiggyBreakDelay(self.effectList[row][piggyType].effect,parent)
        if piggyType == PiggySlotsEffectType.Piggy1x1 then
            self:SetOpenReward(row,piggyType , winCoin)
            -- fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x1Over,true)
            self:PlayAnimator(self.effectList[row][piggyType].effect , piggyAnimName.Piggy1x1Over)
        elseif piggyType == PiggySlotsEffectType.Piggy1X2 then
            self:SetOpenReward(row,piggyType , winCoin)
            self:PlayAnimator(self.effectList[row][piggyType].effect , piggyAnimName.Piggy1x2Over)
            -- fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x2Over,true)
        elseif piggyType == PiggySlotsEffectType.Piggy1X3 then
            self:SetOpenReward(row,piggyType , winCoin)
            self:PlayAnimator(self.effectList[row][piggyType].effect , piggyAnimName.Piggy1x3Over)
            -- fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x3Over,true)
        elseif piggyType == PiggySlotsEffectType.Piggy2x3 then
            self:PlayAnimator(self.effectList[row][piggyType].effect , piggyAnimName.Piggy2x3Over)
            -- fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy2x3Over,true)
        end
    end
end

function PiggySlotsGameReel:SetOpenReward(row ,piggyType , winCoin)
    local ref = fun.get_component(self.effectList[row][piggyType].effect,fun.REFER)
    local textCoinName = "text" .. piggyType
    local textCoin = ref:Get(textCoinName)
    textCoin.text = fun.format_money(winCoin)
end


function PiggySlotsGameReel:AddHideEffectDelay(delayFunc)
    self.delayHideFunc = self.delayHideFunc or {}
    table.insert(self.delayHideFunc , delayFunc)
end

function PiggySlotsGameReel:ClearHideEffectDelay()
    self.delayHideFunc = self.delayHideFunc or {}
    for k ,v in pairs(self.delayHideFunc) do
        if v then
            LuaTimer:Remove(v)
        end
    end
    self.delayHideFunc = nil
end

function PiggySlotsGameReel:AddPiggyBreakDelay(effect,parent)
    self.delayPiggyBreakFunc = self.delayPiggyBreakFunc or {}
    local topParent = self.mainCode:GetParentTop()
    fun.set_parent(effect, topParent)
    -- effect.transform:SetAsLastSibling()
    local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.BreakTime, function()
        fun.set_parent(effect, parent)
    end)

    table.insert(self.delayPiggyBreakFunc , delayFunc)
end

function PiggySlotsGameReel:ClearPiggyBreakDelay()
    self.delayPiggyBreakFunc = self.delayPiggyBreakFunc or {}
    for k ,v in pairs(self.delayPiggyBreakFunc) do
        if v then
            LuaTimer:Remove(v)
        end
    end
    self.delayPiggyBreakFunc = nil
end

function PiggySlotsGameReel:PlayAnimator(effect, playName)
    local anima = fun.get_component(effect,fun.ANIMATOR)
    if anima then
        anima:Play(playName,-1,0)
        anima:Update(0);
    end
end

function PiggySlotsGameReel:GetCollectCoinText(row,piggyType)
    log.log("检查金币丢失" , self.reelIndex , piggyType , self.effectList)
    if self.effectList[row] and self.effectList[row][piggyType] then
        local ref = fun.get_component(self.effectList[row][piggyType].effect,fun.REFER)
        local textCoin = ref:Get("text" .. piggyType)
        return textCoin
    else
        log.log("错误缺少特效" , self.reelIndex , row , piggyType)
        return nil
    end
end

function PiggySlotsGameReel:GetEffectList()
    return self.effectList or nil
end

function PiggySlotsGameReel:ClearAllEffect()
    if self.effectList then
        for k ,v in pairs(self.effectList) do
            for z ,w in pairs(v) do
                if w.effect then
                    self.mainCode:BackPiggyEffect(w.effect)
                end
            end
        end
    end
    self.effectList = {}
end


function PiggySlotsGameReel:DestroyAllEffect()
    self.effectList = {}
end


function PiggySlotsGameReel:SetTopElementActive(isShow)
    for k,v in pairs(self.cellReplaceList) do
        if v.tableIndex == 1 then
            fun.set_active(self["element"..k],isShow)
        end
    end
end

return this