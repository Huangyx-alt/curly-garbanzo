local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(args)
    local minigame = ModelList.MiniGameModel:CheckMiniGameAvailable()
    if minigame then
        Event.AddListener(EventName.Event_popup_order_step_finish,this.Finish)
        require(string.format("MiniGame/MiniGame%02d/MiniGameEntrance",minigame.id))
        MiniGameEntrance:EnterGameSartMiniGame()
    else
        this.Finish()
        if MiniGameEntrance then
            MiniGameEntrance:ClearMiniGameLua()
        end
    end
end

function PopupOrder.Finish()
    log.g("mini game finish Event_popup_order_step_finish")
    Event.RemoveListener(EventName.Event_popup_order_step_finish,this.Finish)
    this.NotifyCurrentOrderFinish()
end

return this