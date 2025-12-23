local GemQueenJackpotView = BaseChildView:New()
local this = GemQueenJackpotView

this.auto_bind_ui_items = {
    "JackpotCard1",
    "JackpotBingo1",
    "JackpotCard2",
    "JackpotBingo2",
    "JackpotCard3",
    "JackpotBingo3",
    "JackpotCard4",
    "JackpotBingo4"
}

function GemQueenJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotRoot = nil

function GemQueenJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef, jackPar)
    this.jackpotRoot = jackPar
    Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
end

function GemQueenJackpotView:EnableView()
    fun.set_active(this.go, true)
    this:Show()
end

function GemQueenJackpotView:OnEnable()
    this:Show()
    Event.AddListener(EventName.Event_SwitchCard_BingoEffect, self.OnObtainBingo, self)
end

function GemQueenJackpotView:OnObtainBingo(mapindex)
    local smallCard1 = self[string.format("JackpotCard%s", mapindex or 1)]
    local smallCard2 = self[string.format("JackpotBingo%s", mapindex or 1)]
    if smallCard1 then
        Cache.SetImageSprite("LeetoleManBattleAtlas", "LTRJackpotCard2", smallCard1)
    end
    if smallCard2 then
        Cache.SetImageSprite("LeetoleManBattleAtlas", "LTRJackpotBingo", smallCard2)
    end
end

function GemQueenJackpotView:Show()
    fun.set_active(this.jackpotRoot, true)
end

function GemQueenJackpotView:OnDisable()
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    Event.RemoveListener(EventName.Event_SwitchCard_BingoEffect, self.OnObtainBingo, self)
    this:Close()
end

return this
