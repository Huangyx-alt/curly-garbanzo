require("Combat/Machine/BingoLeftTickMachine")

local WinZoneBingoLeftView = BaseView:New('WinZoneBingoLeftView')
local this = WinZoneBingoLeftView

this.auto_bind_ui_items = {
    "itemTemp",
    "left_num",
    "NumRed",
    "Content",
    "contentItem",
    "WinzoneJackpotTips",
    "remain_count",
}
this.curCount = 0
this.itemTempPool = {}
this.usingItem = {}
this.contentItemList = {}
this.gamePlayingTime = 0
this.isTriggeredGuide = false

function WinZoneBingoLeftView:New()
    local o = {}
    o.__index = self
    setmetatable(o, this)
    return o
end

function WinZoneBingoLeftView.Awake()
    Facade.RegisterView(this)
end

function WinZoneBingoLeftView.OnEnable()
    this.isTriggeredGuide = false
    this.model = ModelList.BattleModel:GetCurrModel()
    this.loadData = this.model:LoadGameData()
    
    --this.curCount = #this.loadData.userBingoTick
    this.curCount = #this.loadData.jackpotLeftTick + #this.loadData.bingoLeftTick
    
    this.targetNum = this.curCount
    this.SetBingoLeftNum(this.curCount)
    
    this.update_x_enabled = true
    this:start_x_update()
    this.gamePlayingTime = 0
    fun.set_active(this.WinzoneJackpotTips, false)
    
    --初始化机器人达成bingo的tick数据
    this.userBingoTick = {}
    table.each(this.loadData.userBingoTick, function(v)
        local key = tostring(v.tick)
        --可能一个tick对应多个数据
        this.userBingoTick[key] = this.userBingoTick[key] or {}
        table.insert(this.userBingoTick[key], v)
    end)
end

function WinZoneBingoLeftView.OnDestroy()
    Facade.RemoveView(this)
    this:Close()
    this.coroutine = nil
    this.contentItemList = {}
end

function WinZoneBingoLeftView:CoroutineEnable()
    if this.coroutine ~= nil then
        coroutine.stop(this.coroutine)
    end
    this.coroutine = nil
    this.coroutine = coroutine.start(function()
        coroutine.wait(1)
        if self and fun.is_not_null(self.go) then
            this.oriPos = fun.get_localposition(self.go)
            fun.set_gameobject_pos(self.go, 10000, 10000, 0, true)
            fun.set_active(self.go, true)
        end
        coroutine.wait(1)
        if self and fun.is_not_null(self.go) and this.oriPos then
            fun.set_active(self.go, false)
            fun.set_gameobject_pos(self.go, this.oriPos.x, this.oriPos.y, this.oriPos.z, true)
        end
        coroutine.wait(1)
        self.InitItemPool()
        this.coroutine = nil
    end)
end

function WinZoneBingoLeftView:on_x_update()
    if not BingoLeftTickMachine.update_x_enabled then
        return
    end

    local timeScale, acceleration = BingoLeftTickMachine.timeScale, BingoLeftTickMachine.acceleration
    this.gamePlayingTime = this.gamePlayingTime + UnityEngine.Time.deltaTime * timeScale * acceleration

    local target
    for i = 1, #this.loadData.oneAwayTick do
        local v = this.loadData.oneAwayTick[i]
        local tick = v.tick * 0.01
        if this.gamePlayingTime > tick then
            target = table.remove(this.loadData.oneAwayTick, i)
            break
        end
    end
    if target then
        fun.set_active(this.WinzoneJackpotTips, true)
        self.remain_count.text = target.count
        
        if not this.isTriggeredGuide then
            this.isTriggeredGuide = true
            if not ModelList.GuideModel:IsGuideComplete(68) then
                ModelList.GuideModel:TriggerWinZoneBattleGuide(328)
            end
        end
    end
end

function WinZoneBingoLeftView.InitItemPool()
    this.itemTempPool = {}
    this.usingItem = {}
    this.contentItemList = {}

    for i = 1, 10 do
        local itemClone = fun.get_instance(this.itemTemp, this.itemTemp.transform.parent)
        table.insert(this.itemTempPool, itemClone)
    end
end

--从对象池取Item
function WinZoneBingoLeftView.GetItemFromPool(parent)
    local ctrl
    if #this.itemTempPool > 0 then
        ctrl = table.remove(this.itemTempPool, 1)
    else
        ctrl = fun.get_instance(this.itemTemp, this.itemTemp.transform.parent)
    end
    if parent then
        fun.set_parent(ctrl, parent, true)
        fun.set_rect_anchored_position(ctrl, 0, 0)
    end
    table.insert(this.usingItem, ctrl)
    return ctrl
end

function WinZoneBingoLeftView.ShowBingoLeft()
    local leftData = this.model:LoadBingoLeftData()
    if leftData.bingo then
        local idList = {}
        for i = 1, #leftData.bingo do
            if not fun.is_include(leftData.bingo[i].cardId, idList) then
                table.insert(idList, leftData.bingo[i].cardId)
            end
        end
        for k = 1, #idList do
            local bingoNumber = {}
            local jackpotNumber = {}
            local bingoOrJack = 0
            for i = 1, #leftData.bingo do
                if leftData.bingo[i].cardId == idList[k] then
                    fun.add_table(bingoNumber, leftData.bingo[i].numbers)
                    if leftData.bingo[i].type > bingoOrJack then
                        bingoOrJack = leftData.bingo[i].type
                    end
                    if leftData.bingo[i].type == 2 then
                        fun.add_table(jackpotNumber, leftData.bingo[i].numbers)
                    end
                end
            end
            local table2 = {}
            for k, v in pairs(bingoNumber) do
                table2[v] = true        --将表1的值作为表2的键，键是唯一的
            end
            local table3 = {}
            for k, v in pairs(table2) do
                table.insert(table3, k) --将表2的键导出，放置到表3中
            end
            bingoNumber = table3
            if bingoOrJack == 1 then
                Event.Brocast(EventName.Trigger_Bingo, idList[k], bingoNumber)
            else
                Event.Brocast(EventName.Trigger_Jackpot, idList[k], bingoNumber, jackpotNumber)
            end
        end
    end

    if this.curCount == 0 then
        return
    end

    local realBingoCount = 0
    --自己达成的Bingo
    table.each(leftData.bingo, function(v)
        realBingoCount = realBingoCount + 1
        this.ShowBingoTip(v.type)
    end)

    --机器人达成的Bingo
    if this.userBingoTick then
        table.each(leftData.ticks, function(tick)
            tick = tostring(tick * 100)
            local data = this.userBingoTick[tick]
            table.each(data, function(tickData)
                realBingoCount = realBingoCount + 1
                this.ShowRobotBingoTip(tickData)
            end)
        end)
    end
    this.ShowBingoLeftNum(realBingoCount)
end

---展示玩家达成了bingo
---@param bingoType number bingo还是victoryBingo
function WinZoneBingoLeftView.ShowBingoTip(bingoType)
    local contentItemClone = fun.get_instance(this.contentItem, this.Content)
    fun.set_active(contentItemClone, true)
    local itemClone = this.GetItemFromPool(contentItemClone)

    --tip文字
    local refer = fun.get_component(itemClone, fun.REFER)
    fun.set_active(refer:Get("BingoTip"), bingoType == 1)
    if bingoType == 2 then
        fun.set_active(refer:Get("VictoryTip"), true)
    else
        fun.set_active(refer:Get("VictoryTip"), false)
    end

    --头像
    local selfIcon = fun.get_strNoEmpty(ModelList.PlayerInfoModel:GetHeadIcon(), "xxl_head016")
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(selfIcon, refer:Get("Head"))
    fun.set_active(itemClone, true)

    this.MoveContent(contentItemClone)

    this:PlayBingoLeftSound()
end

---展示机器人达成了bingo
---@param tickData table PB_UserBingoTick
function WinZoneBingoLeftView.ShowRobotBingoTip(tickData)
    local contentItemClone = fun.get_instance(this.contentItem, this.Content)
    fun.set_active(contentItemClone, true)
    local itemClone = this.GetItemFromPool(contentItemClone)

    --tip文字
    local refer = fun.get_component(itemClone, fun.REFER)
    fun.set_active(refer:Get("BingoTip"), tickData.content == "bingo")
    if tickData.content == "victory bingo" then
        fun.set_active(refer:Get("VictoryTip"), true)
    else
        fun.set_active(refer:Get("VictoryTip"), false)
    end

    --机器人头像
    local robotCfg = Csv.GetData("robot_name", tickData.uid)
    if robotCfg then
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(robotCfg.icon, refer:Get("Head"))
    end
    fun.set_active(itemClone, true)

    this.MoveContent(contentItemClone)
    this:PlayBingoLeftSound()
end

--移动tipContent
function WinZoneBingoLeftView.MoveContent(newCtrl)
    this.lastNewCrl = newCtrl

    LuaTimer:SetDelayFunction(0.1, function()
        local ctrlY = newCtrl.transform.anchoredPosition.y
        ctrlY = Mathf.Abs(ctrlY)
        local contentX, contentY = this.Content.sizeDelta.x, this.Content.sizeDelta.y

        if contentY < ctrlY then
            this.Content.transform.anchoredPosition = Vector2(this.Content.transform.anchoredPosition.x, 0)
            --是否正在做移动
            if this.animF then
                this.animF:Kill()
            end
            this.animF = Anim.do_smooth_float_update(contentY, ctrlY, 0.5, function(num)
                this.Content.sizeDelta = Vector2.New(contentX, num)
            end, function()
                --if fun.is_not_null(this.lastNewCrl) then
                --    local tempY = this.lastNewCrl.transform.anchoredPosition.y
                --    table.each(this.usingItem, function(ctrl, k)
                --        local y = ctrl.transform.parent.anchoredPosition.y
                --        local diff = y - tempY
                --        if diff > 420 then
                --            LuaTimer:SetDelayFunction(0.1, function()
                --                table.insert(this.itemTempPool, ctrl)
                --                fun.set_active(child, false)
                --            end, false, LuaTimer.TimerType.BattleUI)
                --            this.usingItem[k] = nil
                --        end
                --    end)
                --end
            end)
        end
    end, false, LuaTimer.TimerType.BattleUI)
end

--更新显示剩余的Bingo数量
function WinZoneBingoLeftView.ShowBingoLeftNum(num)
    num = num or 1
    this.curCount = this.curCount - num
    if this.curCount < 0 then
        this.curCount = 0
    end
    this.SetBingoLeftNum(this.curCount)
end

function WinZoneBingoLeftView.SetBingoLeftNum(count)
    if not this.left_num then
        return
    end

    if count <= 5 then
        this.left_num.spriteAsset = this.NumRed.spriteAsset
    end
    this.left_num.text = tostring(count)
end

--bingosileft涨至最大效果
function WinZoneBingoLeftView.StartNumberAddToMaxEffect()
    this.left_num.text = 0
    local start_num = 0.05   --20次
    LuaTimer:SetDelayLoopFunction(0, 0.15, 21, function()
        local p = math.pow(start_num, 2)
        local p2 = tonumber(p)
        if p2 >= 1 then
            p2 = 1
        end
        p2 = math.ceil(p2 * this.targetNum)
        start_num = start_num + 0.05
        this.left_num.text = tostring(p2)
    end, nil, nil, LuaTimer.TimerType.Battle)
end

local GetSoundOrder = function()
    if this.curCount > 50 then
        return 1
    elseif this.curCount > 30 then
        return 2
    elseif this.curCount > 30 then
        return 3
    elseif this.curCount > 15 then
        return 4
    elseif this.curCount > 10 then
        return 5
    elseif this.curCount > 8 then
        return 6
    elseif this.curCount > 6 then
        return 7
    elseif this.curCount > 4 then
        return 8
    elseif this.curCount == 4 then
        return 9
    else
        return 10
    end
end
function WinZoneBingoLeftView:PlayBingoLeftSound()
    local key = GetSoundOrder()
    UISound.play("bingosleft" .. key)
end

--跳转到小火箭界面时
function WinZoneBingoLeftView:HandleForSettle(jackpotView)
    if jackpotView and jackpotView.go then
        fun.set_parent(self.WinzoneJackpotTips, jackpotView.go)
        fun.set_rect_local_pos(self.WinzoneJackpotTips, 0, 170, 0)
    end
end

this.NotifyList = {
    { notifyName = NotifyName.Bingo.Sync_Bingos, func = this.ShowBingoLeft },
    { notifyName = NotifyName.Bingo.StartBingosleftIncrease, func = this.StartNumberAddToMaxEffect },
}

return this