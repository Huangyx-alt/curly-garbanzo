local ChristmasJackpotView = BaseChildView:New()
local this = ChristmasJackpotView

this.auto_bind_ui_items = {
    "ChristmasSmallJackpot",
}

function ChristmasJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotList = nil
this.jackpotRoot = nil
this.itemList = {}
this.jackpotType = 0

function ChristmasJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef,jackPar)
    if #jackpotRuleId <= 0 then
        fun.set_active(jackpotRef, false)
    else
        this.jackpotList = jackpotRef
        this.jackpotType = jackpotRuleId
        this.jackpotRoot = jackPar
        Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
        Event.AddListener(EventName.Event_Christmas_JackpotView_Bingo, this.ChristmasBingoSmile)
        Event.AddListener(EventName.Event_Christmas_JackpotView_Jackpot, this.ChristmasJackpotSmile)
    end
end

function ChristmasJackpotView:EnableView()
    fun.set_active(this.go, true)
    this:Show()
end

function ChristmasJackpotView:ChristmasBingoSmile()
    this.ChristmasSmallJackpot:Play("bingo", -1, 0)
end

function ChristmasJackpotView:ChristmasJackpotSmile()
    this.ChristmasSmallJackpot:Play("welcome_jackpot")
end

function ChristmasJackpotView:OnEnable()
    this:Show()
end


function ChristmasJackpotView:Show()
    if #this.jackpotType > 0 then
        fun.set_active(this.jackpotRoot, true)
    else
        fun.set_active(this.jackpotRoot, false)
    end
end

function ChristmasJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    Event.RemoveListener(EventName.Event_Christmas_JackpotView_Bingo, this.ChristmasBingoSmile)
    Event.RemoveListener(EventName.Event_Christmas_JackpotView_Jackpot, this.ChristmasJackpotSmile)
    this:Close()
end

return this
