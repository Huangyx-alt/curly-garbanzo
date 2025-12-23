
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

local isFinish = false
local delayTimerId = nil

function PopupOrder.Execute(args)
    --this.Finish()
    if not ModelList.RouletteModel:IsRouletteUnlock() then
        this.Finish()
    elseif this.IsRouletteAvailable() then
        this.PopupRoulette()
    else
        isFinish = false
        ModelList.RouletteModel.C2S_RequestRouletteInfo(function()
            if not isFinish then
                isFinish = true
                if this.IsRouletteAvailable() then
                    this.PopupRoulette()
                else
                    this.Finish()
                end
            end
        end)
        delayTimerId = LuaTimer:SetDelayFunction(3, function()
            --3秒没消息返回就结束了，要不可能会卡死主界面
            if not isFinish then
                this.Finish()
            end
        end,nil,LuaTimer.TimerType.UI)
    end
end

function PopupOrder.IsRouletteAvailable()
    return ModelList.RouletteModel:IsRouletteUnlock() and (ModelList.RouletteModel:IsRouletteRewardAvailable() or 
    ModelList.RouletteModel:IsRouletteFreeAvailable())
end

function PopupOrder.PopupRoulette()
    Event.AddListener(EventName.Event_popup_roulette_finish,this.Finish)
    Facade.SendNotification(NotifyName.ShowUI,ViewList.RouletteView)
end

function PopupOrder.Finish()
    isFinish = true
    if delayTimerId then
        LuaTimer:Remove(delayTimerId)
        delayTimerId = nil
    end
    log.g("EventName.Event_popup_roulette_finish,this.Finish")
    Event.RemoveListener(EventName.Event_popup_roulette_finish,this.Finish)
    this.NotifyCurrentOrderFinish()
end

return this