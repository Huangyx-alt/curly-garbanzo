local BaseOrder = require "PopupOrder/BaseOrder"
local PopupBingoPassOrder = Clazz(BaseOrder, "PopupBingoPassOrder")
local this = PopupBingoPassOrder

function PopupBingoPassOrder.Execute(arg, orderData)
    Event.AddListener(EventName.Event_Popup_BingoPass_finish, this.Finish, this)
    Event.AddListener(EventName.Event_Popup_BingoPass_ClosePoster, this.AfterPosterClose, this)
    Event.AddListener(EventName.Event_Popup_BingoPass_EnterMain, this.ShowMainView, this)
    Event.AddListener(EventName.Event_Popup_BingoPass_ReceiveReward, this.OnReceiveReward, this)
    this.triggerMethod = arg
    this.isNeedResetRound = false
    local isSeasonValid = ModelList.BingopassModel:IsSeasonValid()
    if not isSeasonValid then
        this.Finish()
        return
    end
    local needPopup = this.IsNeedPopupPoster(orderData)
    --needPopup = true --wait del
    if needPopup then
        this.triggerMethod = PopupOrderOccasion.forcePopup
        Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassPosterView)
        this.UpdatePopupPosterTimes(orderData)
    elseif this.TryShowRecommend() then
    elseif this.TryShowPurchase() then
    else
        this.Finish()
    end
end

function PopupBingoPassOrder.IsNeedPopupPoster(orderData)
    return false
    ----local showedTimes = UnityEngine.PlayerPrefs.GetInt("BINGO_PASS_SHOWED_TIMES" .. ModelList.PlayerInfoModel:GetUid(), 0)
    --local isSeasonValid = ModelList.BingopassModel:IsSeasonValid()
    --if not isSeasonValid then
    --    return false
    --end
    --local seasonId = ModelList.BingopassModel:GetSeasonId()
    --if not this.IsAllowPop("BINGO_PASS_SHOWED_TIMES"..seasonId .. ModelList.PlayerInfoModel:GetUid(), orderData) then
    --    return false
    --end
    --local isSeasonValid = ModelList.BingopassModel:IsSeasonValid()
    --return isSeasonValid --and showedTimes < 1
end

function PopupBingoPassOrder.IsNeedPopupRecommend()
    return false
    --if not ModelList.BingopassModel:IsSeasonValid() then
    --    return false
    --end
    --
    --if this.IsOnCooldown() and this.triggerMethod == PopupOrderOccasion.login then
    --    return false
    --end
    --
    --if this.triggerMethod ~= PopupOrderOccasion.login and this.triggerMethod ~= PopupOrderOccasion.forcePopup then
    --    local round =  ModelList.BingopassModel:GetBettleRound()
    --    local targetRound = Csv.GetControlByName("season_pass_number")[1][1]
    --    if round < targetRound then
    --        return false
    --    else
    --        this.isNeedResetRound = true
    --    end
    --end
    --
    --local level = ModelList.BingopassModel:GetLevel()
    --local targetLevel = Csv.GetControlByName("season_pass_level")[1][1]
    --if level > targetLevel then
    --    return false
    --end
    --local isPay999 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay999)
    --local isPay500 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay500)
    --if isPay999 or isPay500 then
    --    return false
    --end
    --this.isNeedResetRound = true
    --return true
end

function PopupBingoPassOrder.IsNeedPoupupPurchase()
    if not ModelList.BingopassModel:IsSeasonValid() then
        return false
    end

    if this.IsOnCooldown() and this.triggerMethod == PopupOrderOccasion.login then
        return false
    end

    if this.triggerMethod ~= PopupOrderOccasion.login and this.triggerMethod ~= PopupOrderOccasion.forcePopup then
        local round =  ModelList.BingopassModel:GetBettleRound()
        local targetRound =  Csv.GetControlByName("season_pass_number")[1][1]
        if round < targetRound then
            return false
        else
            this.isNeedResetRound = true
        end
    end

    local level = 1
    local targetLevel = Csv.GetControlByName("season_pass_level")[1][1]
    if level <= targetLevel then
        return false
    end
    local isPay499 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.isPay499)
    if isPay499 then
        return false
    end
    this.isNeedResetRound = true
    return true
end

function PopupBingoPassOrder.TryShowRecommend()
    if this.IsNeedPopupRecommend() then
        this.ShowRecommend()
        return true
    end
    return false
end

function PopupBingoPassOrder.TryShowPurchase()
    if this.IsNeedPoupupPurchase() then
        this.ShowPurchase()
        return true
    end
    return false
end

function PopupBingoPassOrder.AfterPosterClose()
    if this.TryShowRecommend() then
    elseif this.TryShowPurchase() then
    else
        this.Finish()
    end
end

function PopupBingoPassOrder.AfterRecommendClose(closeMethod)
    if closeMethod == ViewList.BingoPassRecommendView.CloseMethod.normal then
        this.ShowPurchase()
    elseif closeMethod == ViewList.BingoPassRecommendView.CloseMethod.paySucceed then
        --购买成功后一定会弹BingoPassReceivedView，待此弹窗结束后，才能结束此流程
    else
        this.ShowPurchase()
    end
end

function PopupBingoPassOrder.AfterPurchaseClose(closeMethod)
    if closeMethod == ViewList.BingoPassPurchaseView.CloseMethod.normal then
        this.Finish()
    elseif closeMethod == ViewList.BingoPassPurchaseView.CloseMethod.paySucceed then
        --购买成功后一定会弹BingoPassReceivedView，待此弹窗结束后，才能结束此流程
    else
        this.Finish()
    end
end

function PopupBingoPassOrder.AfterMainClose()
    this.Finish()
end

function PopupBingoPassOrder.ShowPoster()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassPosterView)
end

function PopupBingoPassOrder.ShowRecommend()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassRecommendView)
    ViewList.BingoPassRecommendView:SetCloseCallback(this.AfterRecommendClose)
    fun.save_value("BINGOPASS_POP_CD_RECORD" .. ModelList.PlayerInfoModel:GetUid(), os.time())
end

function PopupBingoPassOrder.ShowPurchase()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassPurchaseView)
    ViewList.BingoPassPurchaseView:SetCloseCallback(this.AfterPurchaseClose)
    fun.save_value("BINGOPASS_POP_CD_RECORD" .. ModelList.PlayerInfoModel:GetUid(), os.time())
end

function PopupBingoPassOrder.ShowMainView()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassView)
    ViewList.BingoPassView:SetCloseCallback(this.AfterMainClose)
    ViewList.BingoPassView:SetSkipReopenHallCityView(true)
end

function PopupBingoPassOrder:IsOnCooldown()
    local dateStr = os.time()
    local recordDateStr = fun.read_value("BINGOPASS_POP_CD_RECORD" .. ModelList.PlayerInfoModel:GetUid(), 0)
    recordDateStr = tonumber(recordDateStr) or 0
    local popupCd = Csv.GetControlByName("bingopass_pop_cd")[1][1] or 86400
    if dateStr < recordDateStr + popupCd then
        log.log("PopupBingoPassOrder:IsOnCooldown true")
        return true
    end
end

--购买成功收到奖励后
function PopupBingoPassOrder.OnReceiveReward()
    this.Finish()
end

function PopupBingoPassOrder.UpdatePopupPosterTimes(orderData)
    local seasonId = ModelList.BingopassModel:GetSeasonId()
    this.RefreshPopTime("BINGO_PASS_SHOWED_TIMES"..seasonId .. ModelList.PlayerInfoModel:GetUid(),orderData)
    --local showedTimes = UnityEngine.PlayerPrefs.GetInt("BINGO_PASS_SHOWED_TIMES" .. ModelList.PlayerInfoModel:GetUid(), 0)
    --UnityEngine.PlayerPrefs.SetInt("BINGO_PASS_SHOWED_TIMES" .. ModelList.PlayerInfoModel:GetUid(), showedTimes + 1)
end

function PopupBingoPassOrder.Finish()
    log.g("brocast EventName.Event_Popup_BingoPass_finish ")
    Event.RemoveListener(EventName.Event_Popup_BingoPass_finish, this.Finish, this)
    Event.RemoveListener(EventName.Event_Popup_BingoPass_ClosePoster, this.AfterPosterClose, this)
    Event.RemoveListener(EventName.Event_Popup_BingoPass_EnterMain, this.ShowMainView, this)
    Event.RemoveListener(EventName.Event_Popup_BingoPass_ReceiveReward, this.OnReceiveReward, this)
    Event.Brocast(EventName.Event_popup_order_finish, true)
    if this.isNeedResetRound then
        ModelList.BingopassModel:ResetBettleRound()
    end
end

return PopupBingoPassOrder