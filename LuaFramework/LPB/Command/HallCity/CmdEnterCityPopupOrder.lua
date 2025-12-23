local Command = {}
local this = Command

local orderList = nil
local index = nil
local occasion = nil
local extra = nil
local Input = UnityEngine.Input
local KeyCode = UnityEngine.KeyCode

local isFinish = nil
local isNeedForce = nil
--- 上一个popup order
local preOrder = nil

PopupOrderOccasion = { none = 0, login = 1, enterMainCity = 2, enterNormalHall = 3, enterAutoHall = 4, changeCity = 5, enterHallFromBattle = 6, forcePopup = 100 }

local POPUPINDEXSTR = "popup_local_index"

function Command.CheckBreakIndex()
    local breakIdx = fun.get_int(POPUPINDEXSTR, -1)


    if (breakIdx > 0) then
        local index = breakIdx % 1000
        if (orderList and orderList[index]) then
            local execute = orderList[index].execute
            SDK.BI_Event_Tracker("break_popup_index",{breakIdx= breakIdx,step = index,popup = execute})
            Command.CleanPopupLocalTag()
        end
    end
end

function Command.Execute(notifyName, ...)
    if isFinish == false then
        return
    end
    if ModelList.GuideModel:IsGuiding() then
        this.FireFinish()
        return
    end
    if ModelList.GMModel:IsGMAutoBattle() then
        this.FireFinish()
        return
    end
    -- 模拟新手引导 by LwangZg
    -- if BingoBangEntry.simulateNewbieFlag then
    --     this.FireFinish()
    --     return
    -- end


    if CityHomeScene and CityHomeScene:IsCityOrLobby() then
        --Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.buyHeadDgbA)商店、设置已经加入限制打开不需要这个了
        isFinish = false
        occasion = select(1, ...)
        extra = select(2, ...)

        if orderList and #orderList > 0 and occasion == PopupOrderOccasion.forcePopup then
            isNeedForce = true
            return
        end
        --log.r("==============================>>occasion  " .. tostring(occasion))
        orderList = {}
        preOrder = nil
        index = 0
        for key, value in pairs(Csv.window) do
            for key2, value2 in pairs(value.occasion) do
                if value2 == occasion then
                    table.insert(orderList, value)
                    break
                end
            end
        end
        table.sort(orderList, function(a, b)
            return a.priority < b.priority
        end)
        Command.start_x_update()
        Event.AddListener(EventName.Event_popup_order_finish, Command.OnPopupOrderFinish)

        Command.CheckBreakIndex()

        Command.OnPopupOrderFinish(false)
    end
end

function Command.OnPopupOrderFinish(succeed)
    index = index + 1
    if preOrder and preOrder.IsPreOrderFinish() then
        isFinish = true
        Command.FireFinish()
        log.r("OnPopupOrderFinish  IsPreOrderFinish")
        return
    end

    if orderList[index] then
        log.y("OnPopupOrderFinish   " ..
        index .. " lua " .. orderList[index].execute .. " total " .. #orderList .. "occasion" .. occasion)
        local step = tonumber(occasion) * 1000 + index
        fun.save_int(POPUPINDEXSTR, step)
        local execute = require("PopupOrder/" .. orderList[index].execute)
        if index == 27 and execute then
            log.r("orderList[index].execute =============")
        end
        if execute then
            preOrder = execute
            ----最后一个弹出jeckpot不需要等待全部播完
            if execute.IsOrderFinish and execute.IsOrderFinish() then
                isFinish = true
                log.r("执行完毕 ", orderList[index], "Command.FireFinish")
                Command.FireFinish()
            else
                log.r("执行完毕 ", orderList[index], "Command.FireFinish")
                execute.Execute(occasion, orderList[index], extra)
            end
        end
    elseif not isFinish then
        Command.FireFinish()
    end
end

function Command.FireFinish()
    log.r("没有每日登录，也 FireFinish isFinish = nil")
    occasion = nil
    index = nil
    orderList = nil
    isFinish = nil
    preOrder = nil
    Command.CleanPopupLocalTag()
    Command.ClearPopClickCount()
    Event.RemoveListener(EventName.Event_popup_order_finish, Command.OnPopupOrderFinish)

    if isNeedForce then
        isNeedForce = nil
        Command.Execute(nil, PopupOrderOccasion.forcePopup)
        return
    end
    isNeedForce = nil

    log.l(" LwangZg 执行到 EnterCityPopupOrder FireFinish 完成 城市状态机 ")
    Event.Brocast(EventName.Event_enterhome_previous_finish, occasion)

    --Event.Brocast(EventName.Event_topbar_change,true,TopBarChange.buy)商店、设置已经加入限制打开不需要这个了
    if ModelList.PlayerInfoModel:GetupLevelState(upLevelType.betTip) then
        ModelList.PlayerInfoModel:SetupLevelState(upLevelType.betTip)
        --Event.Brocast(EventName.Event_BetRate_UpLevel_Tip)
    end

    --等其他所有弹窗结束，再打开后端推送弹窗
    ModelList.ServerNotifyModel:ShowServerNotify()
end

function Command.CleanPopupLocalTag()
    fun.save_int(POPUPINDEXSTR, -1)
end

function Command.IsFinish()
    return isFinish == nil
end

----------------------------- region 检测屏幕点击相关 -----------------------------

function Command.start_x_update()
    this:stop_x_update()
    this.start_time = fun.get_real_time_since_startup()
    this.update = xp_call(function()
        this:on_x_update()
    end)

    this.update_x_handler = UpdateBeat:CreateListener(this.update)
    UpdateBeat:AddListener(this.update_x_handler)
end

function Command.stop_x_update()
    if this.update_x_handler then
        UpdateBeat:RemoveListener(this.update_x_handler)
        this.update_x_handler = nil
    end
end

function Command.on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        this.AddPopClickCount()
    end
end

--[[
    @desc: 统计当前弹窗屏幕点击的次数， 用于检测弹窗是否有效
    author:nuts
    time: 2024-06-11 18:46
    @return:
]]
function Command.AddPopClickCount()
    if not this then
        return
    end
    if not this.clickCount then
        this.clickCount = 0
    else
        this.clickCount = this.clickCount + 1
        if this.clickCount >= 10 then
            this.clickCount = 0
            log.y("popup_window_click   " ..
            index .. " lua " .. orderList[index].execute .. " total " .. #orderList .. "occasion" .. occasion)
            SDK.BI_Event_Tracker("popup_window_click",{step= index,total = #orderList,occasion = occasion,execute = orderList[index].execute})
        end
    end
end

--- 清除弹窗点击次数
function Command.ClearPopClickCount()
    if not this then
        return
    end
    this.stop_x_update()
    this.clickCount = 0
end

----------------------- endregion 检测屏幕点击相关 -----------------------

return Command
