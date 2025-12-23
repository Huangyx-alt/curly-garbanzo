local GameJackpotView = BaseChildView:New()
local this = GameJackpotView

this.auto_bind_ui_items = {
    "JackpotList",
    "Jackpot",
}

function GameJackpotView:New()
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

function GameJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef, jackPar)
    this.isShowned = false
    if #jackpotRuleId <= 0 then
        fun.set_active(self.go, false)
    else
        this.jackpotList = this.JackpotList
        this.jackpotType = jackpotRuleId
        this.jackpotRoot = jackpotRef
        this:CollectItem()
        Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
        SetJokerSkin(self.Jackpot, "JokerBattleAtlas", "ClownBjackpotDi")
        this:OutScreenOpen()
    end
end

--- 屏幕外显示，避免和Pu等界面，集中打开时候卡顿
function GameJackpotView:OutScreenOpen()
    this.originPos = fun.get_localposition(this.jackpotRoot)
    fun.set_rect_local_pos(this.jackpotRoot, 10000, 10000, 0)
    fun.set_active(this.jackpotRoot, true)
end

function GameJackpotView:EnableView()
    fun.set_rect_local_pos(this.jackpotRoot, this.originPos.x, this.originPos.y, this.originPos.z)
    fun.set_active(this.jackpotRoot, true)
    this:Show()
end

--function GameJackpotView:OnEnable()
--    --this:Show()
--end

function GameJackpotView:CollectItem()
    if fun.is_not_null(this.jackpotList) then
        for i = 1, 25, 1 do
            local item = fun.find_child(this.jackpotList, tostring(i - 1))
            if item then
                item.gameObject:SetActive(false)
                table.insert(this.itemList, item)
            end
        end
    end
end

function GameJackpotView:Show()
    if this.isShowned then return end
    this.isShowned = true
    if #this.jackpotType > 0 then
        local coordinate = Csv.GetData("jackpot", this.jackpotType[1], "coordinate")
        for k, v in pairs(coordinate) do
            fun.set_active(this.itemList[v], true)
        end
        fun.set_active(this.jackpotRoot, true)
    else
        fun.set_active(this.jackpotRoot, false)
    end
end

function GameJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    this.isShowned = false
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    this:Close()
end

return this
