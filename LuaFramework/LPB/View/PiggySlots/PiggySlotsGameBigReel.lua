
local PiggySlotsGameBigReel = BaseView:New("PiggySlotsGameBigReel")
local this = PiggySlotsGameBigReel
this.viewType = CanvasSortingOrderManager.LayerType.none
this.auto_bind_ui_items = {
   "element1", 
   "element2", 
}

local itemHeight = 630 --每个格子高度
local itemHeightOffset = 0 --每个格子竖向间距
local rollCellSpeed = 400
local stopFinishAnimTime = 0.5

local rollSpeed = 4
local elementNum = 2 --每竖列元素数量
-- local bottomItemPosY = -1050 --最底部的格子位置 --(200 + 10) * 5    --需要回弹 用这个
local bottomItemPosY = -1270 --最底部的格子位置 --(600 + 10) * 2 --不用回弹用这个

local reelRollState = 
{
    StateIdle = "StateIdle",        --静止状态
    StateRolling = "StateRolling",   --循环滚动
    StateStop = "StateStop",          --停止等待替换
    StateStopFinish = "StateStopFinish",  --替换后到完全停下
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
    Piggy2x3Over = "over4",

}

local reelRollState = 
{
    StateIdle = "StateIdle",        --静止状态
    StateRolling = "StateRolling",   --循环滚动
    StateStop = "StateStop",          --停止等待替换
    StateStopFinish = "StateStopFinish",  --替换后到完全停下
}

function PiggySlotsGameBigReel:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PiggySlotsGameBigReel:Awake()
end

function PiggySlotsGameBigReel:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.rollState = reelRollState.StateIdle
    self:SetReelData(self.reelIndex , self.mainCode, self.effectNormal, self.effectParent)
end

function PiggySlotsGameBigReel:on_after_bind_ref()
    self:InitItem()
end

function PiggySlotsGameBigReel:OnDisable()
    self:ClearHideEffectDelay()
    Facade.RemoveViewEnhance(self)
end

function PiggySlotsGameBigReel:SetReelData(index, mainCode , effectNormal, effectParent)
    self.reelIndex = index or self.reelIndex
    self.mainCode = mainCode or self.mainCode
    self.effectNormal = effectNormal or self.effectNormal
    self.effectParent = effectParent or self.effectParent
end

function PiggySlotsGameBigReel:StartRoll(isInitSpin)
    self.rollState = reelRollState.StateRolling
    self.isInitSpin = isInitSpin or false
    log.log("设置初始化滚动数据" , isInitSpin , self.isInitSpin)
    log.log("转轴状态修改", self.reelIndex , self.rollState)
end

function PiggySlotsGameBigReel:StopRoll()
    self.cellReplaceList = {} --每个格子都需要换次图
    self.rollState = reelRollState.StateStop
    log.log("转轴状态修改", self.reelIndex , self.rollState)
    self:CalShowResultCell()
end

function PiggySlotsGameBigReel:StopRollToFinish()
    self.rollState = reelRollState.StateStopFinish
    log.log("转轴状态修改", self.reelIndex , self.rollState)
    self:AnimMoveStopFinish()
end


function PiggySlotsGameBigReel:InitItem()
    self.rollState = reelRollState.StateIdle
    -- self:SetFuel(self.endFuel)
    -- self:ShowFuleBubble()
    -- self:CalculatePosInScreen()
    -- self:SetLocalPosY(self.startPosInScreen)
end

function PiggySlotsGameBigReel:ReelRoll(deltaTime)
    if self.rollState == reelRollState.StateIdle then
        --静止状态
        return
    end

    if self.rollState == reelRollState.StateRolling then
        -- log.log("转轴状态 A" , self.reelIndex , self.rollState)
        self:ReelRolling(deltaTime)
    elseif self.rollState == reelRollState.StateStop then
        -- log.log("转轴状态 B" , self.reelIndex , self.rollState)
        self:ReelRollStop(deltaTime)
    elseif self.rollState == reelRollState.StateStopFinish then
        --替换后到完全停止
        self:ReelRollStopFinish(deltaTime)
    else
        log.log('错误未知的状态')
    end
end

function PiggySlotsGameBigReel:ReelRolling(deltaTime)
    local offset = deltaTime * rollCellSpeed * rollSpeed
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local pos  = fun.get_rect_anchored_position(item)
            --正常滚动
            if pos.y < bottomItemPosY then
                log.log("测试位置修改 up" , i  , pos.y + math.abs(bottomItemPosY)- offset)
                fun.set_rect_anchored_position_y(item, pos.y + math.abs(bottomItemPosY)- offset)
                self:ReplaceCellElementRandom(item)
            else
                log.log("测试位置修改 down" , i  , pos.y - offset)
                fun.set_rect_anchored_position_y(item, pos.y - offset)
            end 
        end 
    end
end

--不马上停止转动，等3个展示结果元素每个都替换一次
function PiggySlotsGameBigReel:ReelRollStop(deltaTime)
    local offset = deltaTime * rollCellSpeed * rollSpeed
    for i = 1, elementNum do
        local item = self["element" .. i]
        if fun.is_not_null(item) then
            local pos  = fun.get_rect_anchored_position(item)
            --正常滚动
            log.log("滚动效果检查 ReelRollStop" , i , pos  , bottomItemPosY)
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

function PiggySlotsGameBigReel:ReplaceCellElementRandom(item)
    local spriteTestIndex = math.random(PiggySlotsElementId.PiggyBank,PiggySlotsElementId.Gold)
    log.log("随机序号检查 " ,  self.reelIndex, self.rollState,  spriteTestIndex)
    local spriteName = elementList[spriteTestIndex]
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end

function PiggySlotsGameBigReel:ReplaceCellElementStop(item)
    local spriteTestIndex = math.random(PiggySlotsElementId.BlueSafeBox,PiggySlotsElementId.Gold) --停轴时不随机转出小猪
    log.log("随机序号检查 " ,  self.reelIndex   ,  self.rollState,spriteTestIndex)
    local spriteName = elementList[spriteTestIndex]
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end

function PiggySlotsGameBigReel:ReplaceCellElementResult(cellIndex,item)
    local reelResult = self:GetResultElement()
    log.log("测试结果数据 a" , self.reelIndex , cellIndex , reelResult)
    if not reelResult then
        log.log("错误 缺少配置 reelResult")
        return
    end

    local cellTableIndex = self.cellReplaceList[cellIndex].tableIndex
    local resultIndex = self:GetShowElementCellIndex(cellTableIndex)
    log.log("检查spin停止结果 a" , self.reelIndex , cellIndex ,  reelResult  , "    " ,  self.cellReplaceList)
    if not resultIndex or not  reelResult[resultIndex] then
        log.log("错误 缺少配置b cellTableIndex" , cellTableIndex)
        log.log("错误 缺少配置c reelResult" ,reelResult)
        log.log("错误 缺少配置c reelResult" ,self.cellReplaceList[cellIndex])
        return
    end
    local cellResult = reelResult[resultIndex].elementId
    local spriteName = elementList[cellResult]
    log.log("测试结果数据 b" , self.reelIndex , cellIndex , reelResult)
    log.log("替换图片 Xresult " , cellIndex , cellResult)
    local sprite = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", spriteName)
    fun.set_ctrl_sprite(item, sprite)
end

function PiggySlotsGameBigReel:ReplaceResultElement(cellIndex,item)
    log.log("小猪slots 转轴滚动分类 ReplaceResultElement" , self.reelIndex, cellIndex , self.cellReplaceList)
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
    log.log("点击后替换的" ,cellIndex ,  isFinishReplace, self.cellReplaceList)
    return isFinishReplace
end

function PiggySlotsGameBigReel:GetCellResultIndex(bottomCellIndex , offsetNum)
    if bottomCellIndex - offsetNum < 1 then
        return bottomCellIndex - offsetNum + elementNum        
    end
    return bottomCellIndex - offsetNum
end

function PiggySlotsGameBigReel:GetCellTopIndex(index)
    if index == 1 then
        return elementNum
    end

    return index - 1
end

--cellindex : element1 - 5
--tabliendex :牌面上 从上到下  1-5
function PiggySlotsGameBigReel:InsertResultCellList(cellIndex ,tableIndex , isNeedReplace , isReplace, isResult)
    log.log("滚动效果 展示结果的3个元素序号 插入" , cellIndex , tableIndex , isNeedReplace , isReplace)
    self.cellReplaceList[cellIndex] = {tableIndex = tableIndex ,isNeedReplace = isNeedReplace , isReplace = isReplace , isResult = isResult}
end

--获取展示3个牌面结果的元素序号
function PiggySlotsGameBigReel:CalShowResultCell()
    if self.reelIndex == 3 then
        log.log("123123")
    end
    local reslutBottomIndex = self:GetBottomCell()
    local cellIndex1 = self:GetCellResultIndex(reslutBottomIndex , 2)
    local cellIndex2 = self:GetCellResultIndex(reslutBottomIndex , 1)

    local topCellIndex = self:GetCellTopIndex(cellIndex1)
    log.log("滚动效果 插入数据检查" , topCellIndex , cellIndex1 , cellIndex2  ,reslutBottomIndex )
  
    self.cellReplaceList = {}
    self:InsertResultCellList(cellIndex1 , 1 , false , false , false)
    self:InsertResultCellList(cellIndex2 , 2 , true , false , true)

    log.log("滚动效果 展示结果的3个元素序号" , self.reelIndex, reslutBottomIndex  , self.cellReplaceList)
end

--获取最底部的格子id
function PiggySlotsGameBigReel:GetBottomCell() 
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

function PiggySlotsGameBigReel:GetCellTargetPosY(tableIndex)
    return  -(tableIndex - 1) * (itemHeight + itemHeightOffset)
end

function PiggySlotsGameBigReel:ReelRollStopFinish(deltaTime)
end

function PiggySlotsGameBigReel:AnimMoveStopFinish()
    log.log("计算最后的目标位置" ,self.reelIndex ,  self.cellReplaceList)
    for  i = 1 , elementNum do
        if self.cellReplaceList[i].isNeedReplace then
            --中间格子结果
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

function PiggySlotsGameBigReel:AnimResultItemStopFinish(index)
    local tableIndex = self.cellReplaceList[index].tableIndex
    local curIndex = self:GetShowElementCellIndex(tableIndex)
    local targetPos = self:GetCellTargetPosY(tableIndex)
    local item = self["element" .. index]
    -- local curve = DG.Tweening.Ease.OutBack
    local curve = DG.Tweening.Ease.Unset
    -- local curve = DG.Tweening.Ease.OutFlash
    -- local curve = DG.Tweening.Ease.Linear
    -- local curve = DG.Tweening.Ease.InFlash
    -- local curve = DG.Tweening.Ease.InBack

    Anim.move_ease(item,0,targetPos,0,stopFinishAnimTime,true,curve,function()
        -- local result = self:GetResultElement()
        -- if self.reelIndex == 3 and curIndex == 1 then
        --     log.log(12231231231)
        -- end
        -- if result[curIndex] and result[curIndex].elementId == PiggySlotsElementId.PiggyBank and self:CheckCreatTypeEffect(curIndex,PiggySlotsEffectType.Piggy1x1) then
        --     local effectPos = fun.get_gameobject_pos(item, false)
        --     local parent = self:GetEffectParent(curIndex)
        --     local effect = fun.get_instance(self.effectNormal, parent)
        --     effect.transform.position = effectPos
        --     effect.name = string.format("%s%s%s%s","cellEffect:1x1:" , self.reelIndex,"_" , curIndex)
        --     self:AddEffect(curIndex,effect, PiggySlotsEffectType.Piggy1x1)
        --     self:SignReelEffectData(curIndex , PiggySlotsEffectType.Piggy1x1)
        -- end
    end)
end

function PiggySlotsGameBigReel:AnimBottomItemStopFinish(index)
    local targetPos = self:GetCellTargetPosY(self.cellReplaceList[index].tableIndex)
    local item = self["element" .. index]
    local curve = DG.Tweening.Ease.Unset
    -- local curve = DG.Tweening.Ease.OutFlash
    -- local curve = DG.Tweening.Ease.OutBack  --有回弹
    -- local curve = DG.Tweening.Ease.Linear
    -- local curve = DG.Tweening.Ease.InFlash
    -- local curve = DG.Tweening.Ease.InBack

    Anim.move_ease(item,0,targetPos,0,stopFinishAnimTime,true,curve,function()
        log.log("格子滚动效果 到达位置检查" , item.name)
    end)
end

function PiggySlotsGameBigReel:AnimTopItemStopFinish(index)
    local item = self["element" .. index]
    local pos  = fun.get_rect_anchored_position(item)
    if pos.y > bottomItemPosY then
        -- local curve = DG.Tweening.Ease.OutBack
        local curve = DG.Tweening.Ease.Unset
        Anim.move_ease(item,0,bottomItemPosY,0,stopFinishAnimTime,true,curve,function()
            fun.set_rect_anchored_position_y(item, 0) --修改后的
        end)
    else
        -- fun.set_rect_anchored_position_y(item, itemHeight) --这里修改了 正常的
        fun.set_rect_anchored_position_y(item, 0) --修改后的
    end
end

function PiggySlotsGameBigReel:GetResultElement()
    local result = nil
    if self.isInitSpin then
        result = ModelList.PiggySloltsGameModel.GetInitSpinResult(self.reelIndex)
    else
        result = ModelList.PiggySloltsGameModel.GetResultElementData(self.reelIndex)
    end
    result = 
    {
        [1] = {
             elementId = 38002},
        [2] = {
             elementId = 38001}
    }
    log.log("结算数据检查" , result)
    return result
end

function PiggySlotsGameBigReel:GetTargetRow(row)
    local order = 
    {
        [1] = 4,
        [2] = 3,
        [3] = 2
    }
    return order[row]
end

function PiggySlotsGameBigReel:GetShowElementCellIndex(cellIndex)
    local order = 
    {
        [2] = 3,
        [3] = 2,
        [4] = 1
    }
    return order[cellIndex]
end


-- function PiggySlotsGameBigReel:AddEffect(row,effect,effectType)
--     log.log("小猪机台 特效添加 start " , self.reelIndex, row , effectType ,  self.effectList)
--     self.effectList = self.effectList or {}
--     self.effectList[row] = self.effectList[row] or {}
--     self.effectList[row][effectType] = {effectType = effectType , effect = effect, isFake = false}
--     log.log("小猪机台 特效添加 end " ,  self.reelIndex ,row , effectType ,  self.effectList)
-- end

-- function PiggySlotsGameBigReel:DestroyEffect(row,effectType)
--     -- if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType]) then
--     if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
--         log.log("小猪机台 删除特效 col:", self.reelIndex  ,  "  row:" , row ,  "  effectType: " , effectType)
--         Destroy(self.effectList[row][effectType].effect)
--         self.effectList[row][effectType] = nil
--     end
-- end

-- function PiggySlotsGameBigReel:ShowAllLowLevelEffectHide(checkLevel)
--     for row = 1, 3 do
--         -- if self:CheckCreatTypeEffect(row , checkLevel) then
--             --存在特效
--             self:ShowLowLevelEffectHide(row,checkLevel)
--         -- end
--     end
-- end

-- function PiggySlotsGameBigReel:ShowLowLevelEffectHide(row, checkLevel)
--     if checkLevel == PiggySlotsEffectType.Piggy1x1 then
--     elseif checkLevel == PiggySlotsEffectType.Piggy1X2 then  
--         self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
--     elseif checkLevel == PiggySlotsEffectType.Piggy1X3 then
--         self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
--         self:ShowEffect1X2Hide(row, PiggySlotsEffectType.Piggy1X2)
--     elseif checkLevel == PiggySlotsEffectType.Piggy2x3 then
--         self:ShowEffect1X1Hide(row, PiggySlotsEffectType.Piggy1x1)
--         self:ShowEffect1X2Hide(row, PiggySlotsEffectType.Piggy1X2)
--         self:ShowEffect1X3Hide(row, PiggySlotsEffectType.Piggy1X3)
--     end
-- end

-- function PiggySlotsGameBigReel:ShowEffect1X1Hide(row,effectType)
--     if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
--         fun.play_animator(self.effectList[row][effectType].effect,piggyAnimName.Piggy1x1End,true)
--         local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
--             self:DestroyEffect(row , effectType)
--         end)
--         self:AddHideEffectDelay(delayFunc)
--     end
-- end

-- function PiggySlotsGameBigReel:ShowEffect1X2Hide(row,effectType)
--     if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
--         fun.play_animator(self.effectList[row][effectType].effect,piggyAnimName.Piggy1x2End,true)
--         local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
--             self:DestroyEffect(row , effectType)
--         end)
--         self:AddHideEffectDelay(delayFunc)
--     end
-- end

-- function PiggySlotsGameBigReel:ShowEffect1X3Hide(row,effectType)
--     if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
--         fun.play_animator(self.effectList[row][effectType].effect,piggyAnimName.Piggy1x3End,true)
--         local delayFunc = LuaTimer:SetDelayFunction(piggyAnimTime.Hide1X1, function()
--             self:DestroyEffect(row , effectType)
--         end)
--         self:AddHideEffectDelay(delayFunc)
--     end
-- end


-- function PiggySlotsGameBigReel:GetEffectPos(row,effectType)
--     if self.effectList and self.effectList[row] and self.effectList[row][effectType] and fun.is_not_null(self.effectList[row][effectType].effect) then
--         return self.effectList[row][effectType].effect.transform.position
--     end
--     return nil
-- end

-- function PiggySlotsGameBigReel:Creat2X3Effect(row, pos)
--     local effectParent = self:GetEffectParent(row)
--     local effect = fun.get_instance(self.effectNormal, effectParent)
--     effect.name = string.format("%s%s%s%s","cellEffect:2x3:" , self.reelIndex,"_" , row)
--     effect.transform.position = pos
--     fun.play_animator(effect,piggyAnimName.Piggy2x3Enter,true)
--     self:AddEffect(row,effect,PiggySlotsEffectType.Piggy2x3)
-- end

-- function PiggySlotsGameBigReel:Creat1X3Effect(row)
--     local effectParent = self:GetEffectParent(row)
--     local effect = fun.get_instance(self.effectNormal, effectParent)
--     effect.transform.localPosition = Vector3.zero
--     effect.name = string.format("%s%s%s%s","cellEffect:1x3:" , self.reelIndex,"_" , row)
--     fun.play_animator(effect,piggyAnimName.Piggy1x3Enter,true)
--     self:AddEffect(row,effect,PiggySlotsEffectType.Piggy1X3)
--     self:SignReelEffectData(1 , PiggySlotsEffectType.Piggy1X3)
--     self:SignReelEffectData(3 , PiggySlotsEffectType.Piggy1X3)
-- end

-- function PiggySlotsGameBigReel:Creat1X2Effect(startRow,finishRow, pos)
--     local effectParent = self:GetEffectParent(startRow)
--     local effect = fun.get_instance(self.effectNormal, effectParent)
--     effect.transform.position = pos
--     effect.name = string.format("%s%s%s%s","cellEffect:1x2:" , self.reelIndex,"_" , startRow)
--     fun.play_animator(effect,piggyAnimName.Piggy1x2Enter,true)
--     self:AddEffect(startRow,effect,PiggySlotsEffectType.Piggy1X2)
--     self:SignReelEffectData(finishRow , PiggySlotsEffectType.Piggy1X2)
-- end

-- function PiggySlotsGameBigReel:GetEffectParent(row)
--     return self.mainCode:GetEffectParent(self.reelIndex , row)
-- end

-- function PiggySlotsGameBigReel:SignReelEffectData(row , effectType)
--     self.effectList = self.effectList or {}
--     self.effectList[row] = self.effectList[row] or {}
--     log.log("小猪机台 特效添加 sign start" , self.reelIndex , row , effectType ,  self.effectList)
--     self.effectList[row][effectType] = self.effectList[row][effectType] or {}
--     if self.effectList[row][effectType] then
--         if self.effectList[row][effectType].effect then
--             local effect = self.effectList[row][effectType].effect
--             self.effectList[row][effectType] = {effectType = effectType , effect = effect, isFake = false}
--         else
--             self.effectList[row][effectType] = {effectType = effectType , effect = nil, isFake = true}
--         end
--     end
--     log.log("小猪机台 特效添加 sign end" , self.reelIndex, row , effectType ,  self.effectList)

-- end
-- row = 1  effectType = 3
-- function PiggySlotsGameBigReel:CheckCreatTypeEffect(row , effectType)
--     if self.effectList and self.effectList[row]  then
--         for k , v in pairs(self.effectList[row]) do
--             if v.effectType >= effectType then
--                 return false
--             end
--         end
--     end
--     return true
-- end

-- function PiggySlotsGameBigReel:AddHideEffectDelay(delayFunc)
--     self.delayHideFunc = self.delayHideFunc or {}
--     table.insert(self.delayHideFunc , delayFunc)
-- end

-- function PiggySlotsGameBigReel:ClearHideEffectDelay()
--     self.delayHideFunc = self.delayHideFunc or {}
--     for k ,v in pairs(self.delayHideFunc) do
--         if v then
--             LuaTimer:Remove(v)
--         end
--     end
--     self.delayHideFunc = nil
-- end

function PiggySlotsGameBigReel:ShowOpenReward(row,piggyType , winCoin)
    -- -- self.effectList
    -- log.log("特效开启数据" ,  self.reelIndex , row, self.effectList)
    --  if self.effectList[row] and self.effectList[row][piggyType] and fun.is_not_null(self.effectList[row][piggyType].effect) then
    --     local ref = fun.get_component(self.effectList[row][piggyType].effect,fun.REFER)
    --     local textCoinName = "text" .. piggyType
    --     local textCoin = ref:Get(textCoinName)
    --     textCoin.text = fun.format_money(winCoin)
        
    --     if piggyType == PiggySlotsEffectType.Piggy1x1 then
    --         fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x1Over,true)
    --     elseif piggyType == PiggySlotsEffectType.Piggy1X2 then
    --         fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x2Over,true)
    --     elseif piggyType == PiggySlotsEffectType.Piggy1X3 then
    --         fun.play_animator(self.effectList[row][piggyType].effect,piggyAnimName.Piggy1x3Over,true)
    --     elseif piggyType == PiggySlotsEffectType.Piggy2x3 then
    --     end

    -- end
end

return this