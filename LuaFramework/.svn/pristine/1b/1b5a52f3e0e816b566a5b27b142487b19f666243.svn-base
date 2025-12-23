local HorseRacingJackpotView = BaseChildView:New()
local this = HorseRacingJackpotView

this.auto_bind_ui_items = {
    "JackpotList",
    "Jackpot",
}

function HorseRacingJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotList = nil
this.jackpotRoot = nil
this.itemList = {}
this.jackpotType = 0
this.isShowned = false
this.originPos = nil

function HorseRacingJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef,jackPar)
    this.isShowned = false

    this.jackpotList = this.JackpotList
    this.jackpotType = jackpotRuleId
    this.jackpotRoot = jackpotRef
    this:CollectItem()
    Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
    SetJokerSkin(self.Jackpot,"JokerBattleAtlas", "ClownBjackpotDi" )
    this:OutScreenOpen()
end

function HorseRacingJackpotView:OutScreenOpen()
    this.originPos = fun.get_localposition(this.jackpotRoot)
    fun.set_rect_local_pos(this.jackpotRoot, 10000, 10000, 0)
    fun.set_active(this.jackpotRoot,true)
end

function HorseRacingJackpotView:EnableView()
    fun.set_rect_local_pos(this.jackpotRoot, this.originPos.x, this.originPos.y, this.originPos.z)
    fun.set_active(this.jackpotRoot, true)
    this:Show()
end

function HorseRacingJackpotView:CollectItem()
    for i = 1, 25, 1 do
        local item = fun.find_child(this.jackpotList, tostring(i - 1))
        item.gameObject:SetActive(false)
        table.insert(this.itemList, item)
    end
end

function HorseRacingJackpotView:Show()
    if this.isShowned then   return   end
    this.isShowned = true
    fun.set_active(this.jackpotRoot, true)
end

function HorseRacingJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    this.isShowned = false
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    this:Close()
end

return this