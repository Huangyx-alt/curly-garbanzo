local ApplicationGuideInfo = require("Guide.ApplicationGuide.ApplicationGuideInfo")
---@class  LetemRollHallViewGuide : ApplicationGuideInfo
local LetemRollHallViewGuide = ApplicationGuideInfo:New()
local this = LetemRollHallViewGuide

function LetemRollHallViewGuide:Init()
    this:Register()
    this:DelayCheck()
    log.r("LetemRollHallViewGuide:Init")
end

local function RemoveDelay()
    if this.delay_show then
        LuaTimer:Remove(this.delay_show)
        this.delay_show = nil
    end
end

function LetemRollHallViewGuide:Remove()
    --this:Register()
    RemoveDelay()
    this:PlayFingerEffect(nil, true, nil, true)
    log.r("LetemRollHallViewGuide:Remove")
    this:UnRegister()
end

function LetemRollHallViewGuide:DelayCheck()
    RemoveDelay()
    this.delay_show = LuaTimer:SetDelayFunction(this.data[1].delay_time, function()
        this.delay_show = nil
        this:Check()
    end)
end

function LetemRollHallViewGuide:Check()
    local showFinger = false
    --�ж������Ƿ��ѽ���bet
    local canStart, _temp = ModelList.CityModel:GetCanStartGame()

    if canStart == true then
        for i = 1, #this.data do
            if this:IsSatisfy(this.data[i].startcondition, this.data[i]) then
                local view = this:GetGuideView(this.data[i])
                this:PlayFingerEffect(view, false, this.data[i])
                showFinger = true
                return
            end
        end
    end

    if not showFinger then
        this:DelayCheck()
    end
end

function LetemRollHallViewGuide:DelayShowFinger(isStart)
    if isStart then
        if this.delay_show then
            LuaTimer:Remove(this.delay_show)
            this.delay_show = nil
        end
        this:PlayFingerEffect(nil, true)
        this.delay_show = LuaTimer:SetDelayFunction(this.data[1].delay_time, function()
            --local view = ViewList[this.data[1].view].go
            local view = this:GetGuideView(this.data[1])
            if view then
                for i = 1, #this.data[1].path do
                    local childPath = string.gsub(this.data[1].path[i], this.data[1].view .. "/", "")
                    local obj = fun.find_child(view, childPath)
                    if fun.get_active_self(obj) then
                        if not CanvasSortingOrderManager.IsViewBackGround(view.viewType, view.go) then
                            log.r("RoomNoAction  show finger")
                            this:PlayFingerEffect(obj, false, this.data[1])
                        else
                            this:PlayFingerEffect(nil, true)
                        end
                        break
                    end
                end
            end
            this.delay_show = nil
        end)
    else
        this:PlayFingerEffect(nil, true)
        if this.delay_show then
            LuaTimer:Remove(this.delay_show)
            this.delay_show = nil
        end
    end
end

function LetemRollHallViewGuide:Register()
    Event.AddListener(EventName.ApplicationGuide_ResetFinger, this.DelayShowFinger)
end

function LetemRollHallViewGuide:UnRegister()
    Event.RemoveListener(EventName.ApplicationGuide_ResetFinger, this.DelayShowFinger)
end

return this