local LeetoleManJackpotView = BaseChildView:New()
local this = LeetoleManJackpotView

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

function LeetoleManJackpotView:New()
    local o = {}
    this.__index = this
    setmetatable(o, this)
    return o
end

this.jackpotList = nil
this.jackpotRoot = nil
this.itemList = {}
this.jackpotType = 0

function LeetoleManJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
    self:on_init(jackpotRef,jackPar)
    if #jackpotRuleId <= 0 then
        fun.set_active(jackpotRef, false)
    else
        this.jackpotList = jackpotRef
        this.jackpotType = jackpotRuleId
        this.jackpotRoot = jackPar
        Event.AddListener(EventName.Enable_Jackpot_View, this.EnableView)
    end
end

function LeetoleManJackpotView:EnableView()
    fun.set_active(this.go, true)
    this:Show()
end

function LeetoleManJackpotView:OnEnable()
    this:Show()
    Event.AddListener(EventName.Event_SwitchCard_BingoEffect,self.OnObtainBingo,self)
end

function LeetoleManJackpotView:OnObtainBingo(mapindex)
    local smallCard1 = self[string.format("JackpotCard%s",mapindex or 1)]
    local smallCard2 = self[string.format("JackpotBingo%s",mapindex or 1)]
    if smallCard1 then
        Cache.SetImageSprite("LeetoleManBattleAtlas","LTRJackpotCard2",smallCard1)
    end
    if smallCard2 then
        Cache.SetImageSprite("LeetoleManBattleAtlas","LTRJackpotBingo",smallCard2)
    end
end

function LeetoleManJackpotView:Show()
    if #this.jackpotType > 0 then
        --city表获取jackpot
        --local city = Csv.GetData("city", ModelList.CityModel:GetCity(), "jackpot")
        --读jackpot表
        local coordinate = Csv.GetData("jackpot", this.jackpotType[1], "coordinate")
        --local coordinate = {0,4,6,8,12,16,18,20,24}

        --for k, v in pairs(coordinate) do
        --    --this.itemList[v].gameObject:SetActive(true)
        --end
        fun.set_active(this.jackpotRoot, true)
    else
        fun.set_active(this.jackpotRoot, false)
    end
end

function LeetoleManJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    Event.RemoveListener(EventName.Event_SwitchCard_BingoEffect,self.OnObtainBingo,self)
    this:Close()
end

return this
