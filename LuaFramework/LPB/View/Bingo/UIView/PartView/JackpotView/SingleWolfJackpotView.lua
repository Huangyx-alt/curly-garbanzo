local SingleWolfJackpotView = BaseChildView:New()
local this = SingleWolfJackpotView

function SingleWolfJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotList = nil
this.jackpotRoot = nil
this.itemList = {}
this.jackpotType = 0

function SingleWolfJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef,jackPar)
    if #jackpotRuleId <= 0 then
        --fun.set_active(jackpotRef, false)
    else
        this.jackpotList = jackpotRef
        this.jackpotType = jackpotRuleId
        this.jackpotRoot = jackPar
        Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
    end
end

function SingleWolfJackpotView:EnableView()
    fun.set_active(this.go, true)
    this:Show()
end

function SingleWolfJackpotView:OnEnable()
    this:Show()
end


function SingleWolfJackpotView:Show()
    --if #this.jackpotType > 0 then
        --local coordinate = Csv.GetData("jackpot", this.jackpotType[1], "coordinate")
        fun.set_active(this.jackpotRoot, true)
    --else
    --    fun.set_active(this.jackpotRoot, false)
    --end
end

function SingleWolfJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    this:Close()
end

return this
