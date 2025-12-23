local WinZoneJackpotView = BaseChildView:New()
local this = WinZoneJackpotView
this.viewName = "WinZoneJackpotView"

this.auto_bind_ui_items = {
    "JackpotList",
    "Jackpot",
    "imgVictoryCell",
    "remainCount",
    "PassState",
}

function WinZoneJackpotView:New()
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
this.selfRank = 0

function WinZoneJackpotView.Awake()
    Facade.RegisterView(this)
end

function WinZoneJackpotView:OnDisable()
    this.jackpotList = nil
    this.itemList = {}
    this.jackpotType = nil
    this.isShowned = false
    Event.RemoveListener(EventName.Enable_Jackpot_View, this.EnableView)
    this:Close()
end

function WinZoneJackpotView.OnDestroy()
    Facade.RemoveView(this)
end

function WinZoneJackpotView:Init(jackpotRef, jackpotRuleId, jackPar)
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

    this.model = ModelList.BattleModel:GetCurrModel()
    local loadData = this.model:LoadGameData()
    this.totalCount = loadData.jackpotLeft
    --this.totalCount = #loadData.jackpotLeftTick
    this.curCount = 0
    this.selfRank = 0
    this.jackpotLeftTick = {}
    table.each(loadData.jackpotLeftTick, function(tick)
        local key = tostring(tick)
        this.jackpotLeftTick[key] = this.jackpotLeftTick[key] or 0
        this.jackpotLeftTick[key] = this.jackpotLeftTick[key] + 1
    end)
    this.SetBingoLeftNum()
end

--- 屏幕外显示，避免和Pu等界面，集中打开时候卡顿
function WinZoneJackpotView:OutScreenOpen()
    this.originPos = fun.get_localposition(this.jackpotRoot)
    fun.set_rect_local_pos(this.jackpotRoot, 10000, 10000, 0)
    fun.set_active(this.jackpotRoot, true)
end

function WinZoneJackpotView:EnableView()
    fun.set_rect_local_pos(this.jackpotRoot, this.originPos.x, this.originPos.y, this.originPos.z)
    fun.set_active(this.jackpotRoot, true)
    this:Show()
end

function WinZoneJackpotView:CollectItem()
    for i = 1, 25, 1 do
        local item = fun.find_child(this.jackpotList, tostring(i - 1))
        --item.gameObject:SetActive(false)
        table.insert(this.itemList, item)
    end
end

function WinZoneJackpotView:Show()
    fun.set_active(this.PassState, false)
    if not self.imgVictoryCell or this.isShowned then
        return
    end
    
    this.isShowned = true
    if #this.jackpotType > 0 then
        local type = tonumber(this.jackpotType[1])
        local coordinate = Csv.GetData("jackpot", type, "coordinate")
        for k, v in pairs(coordinate) do
            fun.set_ctrl_sprite(this.itemList[v], self.imgVictoryCell.sprite)
        end
        fun.set_active(this.jackpotRoot, true)
    else
        fun.set_active(this.jackpotRoot, false)
    end
end

function WinZoneJackpotView.SetBingoLeftNum(count)
    if not this.remainCount then
        return
    end
                                                                                                          
    if this.curCount > this.totalCount then
        this.curCount = this.totalCount
    end
    this.remainCount.text = string.format("%s/%s", this.curCount, this.totalCount)
end

function WinZoneJackpotView:ShowBingoLeft()
    local leftData = this.model:LoadBingoLeftData()
    --自己达成的Bingo
    table.each(leftData.bingo, function(v)
        if v.type == 2 then
            if this.curCount < this.totalCount then
                if this.selfRank == 0 then
                    this.selfRank = this.curCount + 1
                    --即时上传排名
                    ModelList.WinZoneModel:C2S_VictoryBeatsRankSync(this.selfRank)
                    this:PlayLastRoundSound()
                end
                fun.set_active(this.PassState, true)
            end
            this.curCount = this.curCount + 1
            this:PlayFirstVictorySound()
            this:PlaySeatSound()
        end
    end)

    --机器人达成的Bingo
    if this.jackpotLeftTick then
        table.each(leftData.ticks, function(tick)
            tick = tostring(tick * 100)
            local addCount = this.jackpotLeftTick[tick] or 0
            if addCount > 0 then
                this.curCount = this.curCount + addCount
                this:PlayFirstVictorySound()
                this:PlaySeatSound()
            end
        end)
    end
    
    this.SetBingoLeftNum()
end

--跳转到小火箭界面时
function WinZoneJackpotView:HandleForSettle(parent_obj)
    fun.set_active(self.go, true)
    fun.set_parent(self.go, parent_obj)
    fun.set_rect_local_pos_x(self.go, 360)
    fun.set_rect_local_pos_y(self.go, -410)
end

function WinZoneJackpotView:PlayFirstVictorySound()
    if this.curCount == 1 then
        local random = Mathf.Random(1, 2)
        UISound.play(random == 1 and "winzoneFirstwinner" or "winzoneFirstwinner2")
    end
end

function WinZoneJackpotView:PlayLastRoundSound()
    if not ModelList.WinZoneModel:IsInLastRound() then
        return
    end
    
    if this.selfRank == 1 then
        local random = Mathf.Random(1, 2)
        UISound.play(random == 1 and "winzoneAmazing" or "winzoneChampion")
    end
end

function WinZoneJackpotView:PlaySeatSound()
    if this.totalCount <= 3 then
        return
    end

    if this.totalCount - this.curCount == 3 then
        UISound.play("winzoneThreeseats")
    end
end

this.NotifyList = {
    { notifyName = NotifyName.Bingo.Sync_Bingos, func = this.ShowBingoLeft },
}

return this
