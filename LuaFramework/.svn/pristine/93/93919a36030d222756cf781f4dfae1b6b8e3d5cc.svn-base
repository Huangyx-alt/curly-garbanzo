local DiamondPromotionPosterView = BaseDialogView:New('DiamondPromotionPosterView')
local this = DiamondPromotionPosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_try",
    "anima",
    "spine",
    "left_time",
    "btn_close",
    "txt_description1",
    "txt_description2",    
}

function DiamondPromotionPosterView:Awake()
end

function DiamondPromotionPosterView:OnEnable()
    Facade.RegisterView(self)
    self:ClearMutualTask()
    UISound.play("diamondsalenotice")
end

function DiamondPromotionPosterView:on_after_bind_ref()
    local expireTime = ModelList.GiftPackModel:GetPackExpireTimeByIcon("cEntdiamondsale")
    self:SetLeftTime(expireTime)
    --fun.set_active(self.left_time, false)
    self.txt_description1.text = Csv.GetDescription(30105)
    self.txt_description2.text = Csv.GetDescription(30104)

    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "DiamondPromotionPosterView_start"}, false, function() 
            self:MutualTaskFinish()
        end)

        --self.spine:SetAnimation("start", nil, false, 0)
        --self.spine:AddAnimation("idle", nil, true, 0)
    end
    self:DoMutualTask(task)
end

function DiamondPromotionPosterView:SetLeftTime(endTime)
    local currentTime = ModelList.PlayerInfoModel.get_cur_server_time()
    self.endTime = endTime - currentTime
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
    self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        if self.left_time_txt then
            self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
            self.endTime = self.endTime - 1
            if self.endTime <= 0 then
                --self:on_btn_close_click()
            end
        end
    end,nil,nil,LuaTimer.TimerType.UI)
end

function DiamondPromotionPosterView:OnDisable()
    Facade.RemoveView(self)
end

function DiamondPromotionPosterView:OnDestroy()
    self:Destroy()
end

function DiamondPromotionPosterView:CloseSelf() 
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "DiamondPromotionPosterView_end"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
            Event.Brocast(EventName.Event_Popup_DiamondPromotionPoster_Finish)
        end)
    end

    self:DoMutualTask(task)
end

function DiamondPromotionPosterView:on_btn_try_click()
    self:CloseSelf()
end

function DiamondPromotionPosterView:on_btn_close_click()
    self:CloseSelf()
end

return this