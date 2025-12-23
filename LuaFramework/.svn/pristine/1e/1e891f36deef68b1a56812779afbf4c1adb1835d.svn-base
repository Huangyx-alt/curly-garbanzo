---@class ChristmasSynthesisExtraBallEffectItem : BaseChildView
local ChristmasSynthesisExtraBallEffectItem = BaseChildView:New()
local this = ChristmasSynthesisExtraBallEffectItem
this.__index = this

this.auto_bind_ui_items = {
    "Anima",
    "number1",
    "number2",
    "Text",
}

function ChristmasSynthesisExtraBallEffectItem:New()
    local o = {}
    setmetatable(o, { __index = this })
    return o
end

--@param cardId 卡牌ID
--@param cellIndex 格子位置索引
--@param effectIndex 效果类型
--@param num 格子数字
function ChristmasSynthesisExtraBallEffectItem:SetType(cardId, cellIndex, area, num, isBigIdle, frameInfo)
    self:SetFrameInfo(frameInfo)
    local newBingoType = ModelList.ChristmasSynthesisModel:Area2BingoIdx(area)
    local currentBingoType = 0
    local curBingoInfo = ModelList.ChristmasSynthesisModel:GetCurrentBingoType(cardId)
    if curBingoInfo and curBingoInfo.weight then
        currentBingoType = ModelList.ChristmasSynthesisModel:Area2BingoIdx(curBingoInfo.weight)
    end

    if currentBingoType < 1 then
        self.Text.text = "+" .. ModelList.ChristmasSynthesisModel:GetBingoReward(newBingoType, true)
    else
        local x1, x2 = ModelList.ChristmasSynthesisModel:GetBingoReward(newBingoType, false)
        local y1, y2 = ModelList.ChristmasSynthesisModel:GetBingoReward(currentBingoType, false)
        local delta = x2 - y2
        if delta >= 100000 then
            local newValue = fun.formatNum(delta / 1000) .. "K"
            self.Text.text = "+" .. newValue
        else
            local newValue = fun.formatNum(delta)
            self.Text.text = "+" .. newValue
        end
    end

    if num <= 9 then
        self.number1.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. num)
        fun.set_rect_local_pos(self.number1, 0, 0, 0)
        fun.set_active(self.number2, false)
    else
        fun.set_active(self.number2, true)
        fun.set_rect_local_pos(self.number1, -24, 0, 0)
        self.number1.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. math.floor(num / 10))
        self.number2.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. math.fmod(num, 10))
    end
    self:PlayIdle(isBigIdle)
end

function ChristmasSynthesisExtraBallEffectItem:SetFrameInfo(frameInfo)
    if not frameInfo then
        log.log("ChristmasSynthesisExtraBallEffectItem:SetFrameInfo 参数错误")
        return
    end

    if self.frameInfo then
        log.log("ChristmasSynthesisExtraBallEffectItem:SetFrameInfo 更新", self.frameInfo, frameInfo)
        self.frameInfo.startCellIdx = frameInfo.startCellIdx
        self.frameInfo.endCellIdx = frameInfo.endCellIdx
        self.frameInfo.animName = frameInfo.animName
        self.frameInfo.eigenvalue = frameInfo.eigenvalue
    else
        log.log("ChristmasSynthesisExtraBallEffectItem:SetFrameInfo 设置", frameInfo)
        self.frameInfo = frameInfo
    end
end

function ChristmasSynthesisExtraBallEffectItem:GetFrameInfo()
    return self.frameInfo 
end

function ChristmasSynthesisExtraBallEffectItem:GetFrameObj()
    if not self.frameInfo then
        return
    end

    return self.frameInfo.frameObj
end

function ChristmasSynthesisExtraBallEffectItem:GetEigenValue()
    if not self.frameInfo then
        return
    end

    return self.frameInfo.eigenvalue
end

--- 是否是大的idle动画
function ChristmasSynthesisExtraBallEffectItem:IsBigIdle()
    return self.isBigIdle
end

--- 是否是大的idle动画
function ChristmasSynthesisExtraBallEffectItem:PlayIdle(isBig)
    if isBig then
        self.Anima:Play("idleda",0,0)
        self.isBigIdle =true
        if fun.is_not_null(self.go) then
            fun.SetAsLastSibling(self.go)
        end
    else
        self.Anima:Play("idlexiao",0,0)
        self.isBigIdle =false
    end
    self:PlayFrameIdle(isBig)
end

--- 是否是大的idle动画
function ChristmasSynthesisExtraBallEffectItem:PlayFrameIdle(isBig)
    if fun.is_not_null(self.frameInfo) then
        if fun.is_not_null(self.frameInfo.frameObj) then
            fun.set_active(self.frameInfo.frameObj, isBig)
            if isBig then
                fun.SetAsLastSibling(self.frameInfo.frameObj)
                if fun.is_not_null(self.frameInfo.anima) then
                    self.frameInfo.anima:Play(self.frameInfo.animName)
                end
            end
        end
    end
end

--- 隐藏
function ChristmasSynthesisExtraBallEffectItem:Abandon()
    if self then
        fun.set_active(self.go, false)
    end

    if fun.is_not_null(self.frameInfo.frameObj) then
        fun.set_active(self.frameInfo.frameObj, false)
    end
end

--播放命中动画
function ChristmasSynthesisExtraBallEffectItem:PlayHit()
    if self then
        self.Anima:Play("zhong")
    end
end

return this