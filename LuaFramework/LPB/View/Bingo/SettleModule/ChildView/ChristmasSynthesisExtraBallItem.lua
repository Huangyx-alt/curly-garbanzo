---@class ChristmasSynthesisExtraBallItem : BaseChildView
local ChristmasSynthesisExtraBallItem = BaseChildView:New()
local this = ChristmasSynthesisExtraBallItem
this.__index = this

this.auto_bind_ui_items = {
    "ball",
    "number1",
    "number2",
    "ballType",
    "grayMask",
}

function ChristmasSynthesisExtraBallItem:New()
    local o = {}
    setmetatable(o, { __index = this })
    return o
end


local function GetExtraBallTpye(num)
    if num <= 15 then
        return "CallB", "b_ball_red"
    elseif num <= 30 then
        return "CallI", "b_ball_yellow"
    elseif num <= 45 then
        return "CallN", "b_ball_green"
    elseif num <= 60 then
        return "CallG", "b_ball_blue"
    else
        return "CallO", "b_ball_purple"
    end
end

--@param cardId 卡牌ID
--@param cellIndex 格子位置索引
--@param effectIndex 效果类型 1:星星 2:铃铛 3:熊娃娃 4:美元 5:钻石
--@param num 格子数字
function ChristmasSynthesisExtraBallItem:SetType(num, isEffect)
    if num == 99 then
        self.ball.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisExtraBallAtlas", "ScratchJSPerson2")
        fun.set_active(self.ballType, false)
        fun.set_active(self.number1, false)
        fun.set_active(self.number2, false)
        fun.set_active(self.grayMask, false)
    else
        fun.set_active(self.ballType, true)
        fun.set_active(self.number1, true)
        if num <= 9 then
            self.number1.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. num)
            fun.set_rect_local_pos(self.number1, 0, -14.1, 0)
            fun.set_active(self.number2, false)
        else
            self.number1.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. math.floor(num / 10))
            self.number2.sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. math.fmod(num, 10))
        end
        local type, color = GetExtraBallTpye(num)
        self["ball"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", color)
        self["ballType"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", type)
        fun.set_active(self.grayMask, not isEffect)
    end
end

--- 隐藏
function ChristmasSynthesisExtraBallItem:SetActive(isActive)
    if self then
        fun.set_active(self.go, isActive)
    end
end

return this