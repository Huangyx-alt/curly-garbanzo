
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupSeasonCardOpenPackageOrder = Clazz(BaseOrder, "PopupSeasonCardOpenPackageOrder")
local this = PopupSeasonCardOpenPackageOrder

function PopupSeasonCardOpenPackageOrder.Execute(args)
    local isNeedPopup = this.IsNeedPopup()
    --isNeedPopup = false
    if isNeedPopup then
        local params = {}
        params.bagIds = {0}
        params.succCallback = function(bags) log.log("PopupSeasonCardOpenPackageOrder：成功打卡卡包", bags) end
        params.failCallback = function(code) this.Finish() end
        params.finishCallback = function() this.Finish() end
        ModelList.SeasonCardModel:OpenCardPackage(params)
    else
        this.Finish()
    end
end

function PopupSeasonCardOpenPackageOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish  PopupSeasonCardOpenPackageOrder")
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupSeasonCardOpenPackageOrder.IsNeedPopup()
    return ModelList.SeasonCardModel:IsHasUnopenedPackage()
end

return this