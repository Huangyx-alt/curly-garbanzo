local GameBingosLeftView = BaseView:New('GameBingosLeftView')
local this = GameBingosLeftView
this.__index = this

this.auto_bind_ui_items = {
    "BingosiLeftBig",
    "BingosiAnima",
    "red_call_number",
    "Bingo1St",
    "Bingo2St",
    "Bingo3St",
    "Bingo4St",
    "Content",
    "BgContainer",
    "LastChance",
    "Clock",
    "ItemPool",
    "NumSet",
}

this.remainCount = 0
this.totalCount = 0
this.max_head = 1
this.headCtrlList = {}

local AC = {
    quick_reduce_bingoLeft = false,
    quick_reduce_bingoLeft_time = 0,
    quick_reduce_time2 = 0,
    quick_reduce_total_time = 0,
    quick_reduce_bingoLeft_time_interval = 0,
}

function GameBingosLeftView:New()
    local o = {}
    o.__index = self
    setmetatable(o, this)
    return o
end

function GameBingosLeftView.Awake()
    Facade.RegisterView(this)
end

local IsOpenRedBingoleft = true

function GameBingosLeftView.OnEnable()
    fun.set_active(this.BingosiLeftBig, false)
    this.headCtrlList = {}
    this.model = ModelList.BattleModel:GetCurrModel()
    this.remainCount = this.model:LoadGameData().bingoLeft
    this.totalCount = this.remainCount
    this.max_head = Csv.GetDataLength("robot_name")
    
    IsOpenRedBingoleft = (not ModelList.GuideModel:IsFirstBattle())
end

function GameBingosLeftView:on_after_bind_ref()
    this.contentSpace = this.Content.spacing
    this.contentItemSizeY = fun.get_rect_delta_size(this.Bingo4St).y
    this.viewPortSizeY = fun.get_rect_delta_size(this.Content.transform.parent.parent).y
end

function GameBingosLeftView.OnDestroy()
    Facade.RemoveView(this)
    this:Close()
    this.isInLastChange = false
    this.coroutine = nil
    this.headCtrlList = {}
end

function GameBingosLeftView.ShowBingosleft(leftData)
    leftData = leftData or this.model:LoadBingoLeftData()

    --自己触发的bingo
    local myBingoCount = 0
    table.walk(leftData.bingo, function(v)
        if v.type == 1 then
            myBingoCount = myBingoCount + 1
        end
    end)
    for i = 1, myBingoCount do
        this.ShowBingoLeftChange(true)
    end

    --机器人触发的Bingo
    local otherBingoCount = leftData.bingoChange - myBingoCount
    for i = 1, otherBingoCount do
        this.ShowBingoLeftChange(false)
    end
    Event.Brocast(EventName.Bingo_Refresh_Other_BingoCount, otherBingoCount, leftData.next)

    --剩余BingoLeft为0
    --if leftData.bingoLeft == 0 then
    --    this.StartQuickReduceBingosileft()
    --end
end

--更新剩余的BingoLeft数量
function GameBingosLeftView.ShowBingoLeftChange(isSelf)
    if this.remainCount <= 0 then
        return
    end
    
    this.AddBingoShow(isSelf)

    this.remainCount = this.remainCount - 1
    this.remainCount = this.remainCount < 0 and 0 or this.remainCount
    if IsOpenRedBingoleft and this.remainCount <= 15 then
        --this.BingosiLeftBig.fontMaterial = this.red_call_number.fontMaterial
        this.BgContainer:ShowSprite("ZdLeft2")
    end
    this.BingosiLeftBig.text = tostring(this.remainCount)

    Event.Brocast(EventName.Bingo_Refresh_BingoCount, this.remainCount)
end

---增加一个bingo滚动表现
---@param num number 展示几bingo（bingo、doubleBingo等）
function GameBingosLeftView.AddBingoShow(isSelf, num)
    local order = this.totalCount - this.remainCount + 1
    order = Mathf.Clamp(order, 1, this.totalCount)

    local ctrl = this.GetBingoShowItemFromPool(order)
    
    local refer = fun.get_component(ctrl, fun.REFER)
    local Order = refer:Get("Order")
    local headIcon = refer:Get("headIcon")
    local BingoText = refer:Get("headIcon")
    local headFrame = refer:Get("headFrame")
    local canvasGroup = refer:Get("canvasGroup")
    this.headCtrlList[order] = canvasGroup

    --头像
    local model = ModelList.PlayerInfoSysModel
    if isSelf then
        headIcon.sprite = AtlasManager:GetSpriteByName("HeadAtlas", ModelList.PlayerInfoModel:GetHeadIcon())
        model:LoadTargetFrameSprite(ModelList.PlayerInfoSysModel.GetUsingFrameIconID(), headFrame)
    else
        local ran_index = ModelList.BattleModel:GetCurrModel():GetBingoRobots()
        if ran_index == -1 then
            ran_index = math.random(1, this.max_head)
        end
        local data = Csv.GetData("robot_name", ran_index, "icon")
        model:LoadTargetHeadSprite(data, headIcon)
        model:LoadRobotTargetFrameSprite(ran_index, headFrame)
    end

    --排名
    --Order.text = string.format("%sst", order)

    this:PlayBingosLeftSound()

    --动画
    fun.set_parent(ctrl, this.Content)
    fun.set_active(ctrl, true)
    fun.play_animator(ctrl, "enter", true)
    
    local count = ModelList.BattleModel:GetCurrModel():GetCardCount()
    local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
    onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
    if count == 4 and not onlyShow2Card then
        this.MoveContentOnFourCard(order)
    else
        this.MoveContent(order)
    end
end

function GameBingosLeftView.MoveContent(order)
    local targetY = Mathf.Clamp(order - 3, 0, order) * (this.contentItemSizeY + this.contentSpace)
    if targetY > 0 then
        if this.contentMoveTween then
            this.contentMoveTween:Kill()
            this.contentMoveTween = nil
        end
        this.contentMoveTween = Anim.move_to_y(this.Content.gameObject, targetY, 0.3, function()
            this.contentMoveTween:Kill()
            this.contentMoveTween = nil
            
            --隐藏看不到的
            table.each(this.headCtrlList, function(canvasGroup, k)
                if order - k >= 3 then
                    canvasGroup.alpha = 0
                end
            end)
        end)
    else
        fun.set_rect_anchored_position_y(this.Content, 0)
    end
end

function GameBingosLeftView.MoveContentOnFourCard(order)
    --local targetY = Mathf.Clamp(order - 1, 0, order) * (this.contentItemSizeY + this.contentSpace) + this.contentItemSizeY / 2 - this.viewPortSizeY / 2
    local targetY = order * (this.contentItemSizeY + this.contentSpace) - this.viewPortSizeY
    if targetY > 0 then
        if this.contentMoveTween then
            this.contentMoveTween:Kill()
            this.contentMoveTween = nil
        end
        this.contentMoveTween = Anim.move_to_y(this.Content.gameObject, targetY, 0.3, function()
            this.contentMoveTween:Kill()
            this.contentMoveTween = nil
            --隐藏看不到的
            table.each(this.headCtrlList, function(canvasGroup, k)
                if order - k >= 2 then
                    canvasGroup.alpha = 0
                end
            end)
        end)
    else
        fun.set_rect_anchored_position_y(this.Content, 0)
    end
end

function GameBingosLeftView.GetBingoShowItemFromPool(order)
    if order == 1 then
        return this.Bingo1St
    elseif order == 2 then
        return this.Bingo2St
    elseif order == 3 then
        return this.Bingo3St
    end

    local ret
    fun.eachChild(this.ItemPool, function(childCtrl, i)
        if not fun.get_active_self(childCtrl) then
            ret = childCtrl
        end
    end)
    if not ret then
        ret = fun.get_instance(this.Bingo4St, this.ItemPool)
        fun.set_active(ret, false)
    end
    return ret
end

function GameBingosLeftView:PlayBingosLeftSound()
    local soundOrder
    if this.remainCount > 50 then
        soundOrder = 1
    elseif this.remainCount > 30 then
        soundOrder = 2
    elseif this.remainCount > 30 then
        soundOrder = 3
    elseif this.remainCount > 15 then
        soundOrder = 4
    elseif this.remainCount > 10 then
        soundOrder = 5
    elseif this.remainCount > 8 then
        soundOrder = 6
    elseif this.remainCount > 6 then
        soundOrder = 7
    elseif this.remainCount > 4 then
        soundOrder = 8
    elseif this.remainCount == 4 then
        soundOrder = 9
    else
        soundOrder = 10
    end
    UISound.play("bingosleft" .. soundOrder)
end

--快速减少逻辑
function GameBingosLeftView:on_x_update()
    if AC.quick_reduce_bingoLeft then
        --this:QuickReduceBingosileft()
    end
end
function GameBingosLeftView.StartQuickReduceBingosileft()
    if this.remainCount > 0 then
        AC.quick_reduce_bingoleft = true
        AC.quick_reduce_total_time = MCT.delay_to_show_settle - 0.1
        AC.quick_reduce_bingoleft_time = 0
        AC.quick_reduce_bingoleft_time_interval = AC.quick_reduce_total_time / this.remainCount
        AC.quick_reduce_time2 = AC.quick_reduce_bingoleft_time_interval
    end
end
function GameBingosLeftView:QuickReduceBingosileft()
    AC.quick_reduce_bingoleft_time = AC.quick_reduce_bingoleft_time + UnityEngine.Time.deltaTime
    if AC.quick_reduce_bingoleft_time < AC.quick_reduce_total_time then
        if AC.quick_reduce_bingoleft_time >= AC.quick_reduce_time2 then
            AC.quick_reduce_time2 = AC.quick_reduce_time2 + AC.quick_reduce_bingoleft_time_interval
            this.ShowBingoLeftChange(false)
        end
    else
        this.ShowBingoLeftChange(false, 100)
        AC.quick_reduce_bingoleft = false
    end
end

--战斗开始前，bingosileft涨至最大值
function GameBingosLeftView.StartNumberAddToMaxEffect(startDiff, countDownTime)
    fun.set_active(this.BingosiLeftBig, true)
    local startCount = this.remainCount - startDiff
    this.BingosiLeftBig.text = startCount
    
    if startDiff == 0 then
        return
    end
    
    local tempTime, timer = 0
    timer = LuaTimer:SetDelayLoopFunction(0, 0.5, -1, function()
        tempTime = tempTime + 0.5
        if tempTime >= countDownTime then
            tempTime = countDownTime
            LuaTimer:Remove(timer)
            timer = nil
        end

        local a = math.floor(tempTime / countDownTime * startDiff)
        local b = startCount + a
        this.BingosiLeftBig.text = b
    end, nil, nil, LuaTimer.TimerType.Battle)
end

function GameBingosLeftView.ShowLastChange(cb)
    if this.isInLastChange then
        return
    end
    this.isInLastChange = true
    
    coroutine.start(function()
        coroutine.wait(0.3)
        fun.set_active(this.NumSet, false)
        fun.set_gameobject_scale(this.LastChance, 0, 0, 0)
        fun.set_active(this.LastChance, true)
        Anim.scale(this.LastChance, 1, 1, 1, 0.5, true)
        
        coroutine.wait(1)
        fun.set_active(this.LastChance, false)
        fun.set_active(this.Clock, true)
        UISound.play("lastchance")
        
        coroutine.wait(4)
        fun.set_active(this.Clock, false)
        fun.set_active(this.NumSet, true)
        fun.SafeCall(cb)
    end)
end

this.NotifyList = {
    { notifyName = NotifyName.Bingo.Sync_Bingos, func = this.ShowBingosleft },
    { notifyName = NotifyName.Bingo.StartBingosleftIncrease, func = this.StartNumberAddToMaxEffect },
    { notifyName = NotifyName.Bingo.ShowLastChange, func = this.ShowLastChange },
}

return this