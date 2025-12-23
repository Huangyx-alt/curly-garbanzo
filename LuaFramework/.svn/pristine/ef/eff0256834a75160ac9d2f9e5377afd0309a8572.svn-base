local SeasonCardPosterView = BaseDialogView:New('SeasonCardPosterView', "SeasonCardPoster")
local this = SeasonCardPosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
this.CloseMethod = {
    normal = 1,
    enterMain = 2,
}

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_play",
    "btn_close",
    "toggle",
    "anima",
}

function SeasonCardPosterView:Awake()
end

function SeasonCardPosterView:OnEnable()
    self:ClearMutualTask()
    UISound.play("card_pop")
end

function SeasonCardPosterView:on_after_bind_ref()
    self.luabehaviour:AddToggleChange(self.toggle.gameObject, function(target, check)
        self:OnToggleChange(target, check)
    end)

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 1)
    self.toggle.isOn = value == 1
    self:SetLeftTime()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "SeasonCardPosterView_start"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
end

function SeasonCardPosterView:SetLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetActivityExpireTime()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.endTime = expireTime - currentTime
    if self.endTime > 0 then
        if self.loopTime  then
            LuaTimer:Remove(self.loopTime)
            self.loopTime = nil
        end
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                    self:on_btn_close_click()
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function SeasonCardPosterView:OnToggleChange(target, check)
    log.log("SeasonCardPosterView:OnToggleChange ", check)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then
        fun.save_value(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 1)
    else
        fun.save_value(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 0)
    end
end

function SeasonCardPosterView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle.gameObject)
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function SeasonCardPosterView:CloseSelf(closeMethod)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardPosterView_end"}, false, function()
            if closeMethod == self.CloseMethod.normal then
                Event.Brocast(NotifyName.SeasonCard.PopupActivityPosterFinish)
            elseif closeMethod == self.CloseMethod.enterMain then
                local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
                if ModelList.SeasonCardModel:IsNeedDownloadRes(curSeasonId) then
                    Facade.SendNotification(NotifyName.SeasonCard.ClickPosterToDownloadRes)
                    Event.Brocast(NotifyName.SeasonCard.PopupActivityPosterFinish)
                else
                    ModelList.SeasonCardModel:EnterSystem()
                end
                --Event.Brocast(NotifyName.SeasonCard.PopupActivityPosterFinish)
            end
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function SeasonCardPosterView:on_btn_close_click()
    self:CloseSelf(self.CloseMethod.normal)
end

function SeasonCardPosterView:on_btn_play_click()
    self:CloseSelf(self.CloseMethod.enterMain)
end

return this