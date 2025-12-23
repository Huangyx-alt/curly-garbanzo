local HawaiiJackpotView = BaseChildView:New()
local this = HawaiiJackpotView
--[[
this.auto_bind_ui_items = {
    "B1",
    "I1"
}
--]]
function HawaiiJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotList = nil
this.jackpotRoot = nil
this.itemList = {}
this.jackpotType = 0

function HawaiiJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef,jackPar)
    if #jackpotRuleId <= 0 then
        --fun.set_active(jackpotRef, false)
    else
        this.jackpotList = jackpotRef
        this.jackpotType = jackpotRuleId
        this.jackpotRoot = jackPar
        this:CollectItem()
        Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
    end
end

function HawaiiJackpotView:EnableView()
    fun.set_active(this.go, true)
    this:Show()
end

function HawaiiJackpotView:OnEnable()
    this:Show()
end

function HawaiiJackpotView:CollectItem()
    --for i = 1, 4, 1 do
    --    local item = fun.find_child(this.jackpotList, tostring(i - 1))
    --    item.gameObject:SetActive(false)
    --    table.insert(this.itemList, item)
    --end
end

function HawaiiJackpotView:Show()
    --if #this.jackpotType > 0 then
        --city表获取jackpot
        --local city = Csv.GetData("city", ModelList.CityModel:GetCity(), "jackpot")
        --读jackpot表
        --local coordinate = Csv.GetData("jackpot", this.jackpotType[1], "coordinate")
        --local coordinate = {0,4,6,8,12,16,18,20,24}

        --for k, v in pairs(coordinate) do
        --    --this.itemList[v].gameObject:SetActive(true)
        --end
        fun.set_active(this.jackpotRoot, true)
    --else
    --    fun.set_active(this.jackpotRoot, false)
    --end
end

function HawaiiJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    this:Close()
end

return this
