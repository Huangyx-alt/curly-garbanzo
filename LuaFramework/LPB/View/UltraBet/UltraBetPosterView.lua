local UltraBetPosterView = BaseDialogView:New('UltraBetPosterView')
local this = UltraBetPosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_play",
    "anima",
    "spine",
}

function UltraBetPosterView:Awake()
end

function UltraBetPosterView:OnEnable()
    Facade.RegisterView(self)
    self:ClearMutualTask()
    UISound.play("ultrabet_open")
end

function UltraBetPosterView:on_after_bind_ref()
    local expireTime = ModelList.UltraBetModel:GetActivityExpireTime()
    self:SetLeftTime(expireTime)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "UltraBetPosterView_start"}, false, function() 
            self:MutualTaskFinish()
        end)

        self.spine:SetAnimation("start", nil, false, 0)
        self.spine:AddAnimation("idle", nil, true, 0)
    end
    self:DoMutualTask(task)
end

function UltraBetPosterView:SetLeftTime(endTime)
    local currentTime = ModelList.UltraBetModel:GetCurrentTime()
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
                self:on_btn_play_click()
            end
        end
    end,nil,nil,LuaTimer.TimerType.UI)
end

function UltraBetPosterView:OnDisable()
    Facade.RemoveView(self)
end

function UltraBetPosterView:OnDestroy()
    self:Destroy()
end

function UltraBetPosterView:CloseSelf()   
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "UltraBetPosterView_end"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
            Event.Brocast(EventName.Event_Popup_UltraBetPoster_Finish)
        end)
    end

    self:DoMutualTask(task)
end

function UltraBetPosterView:on_btn_play_click()
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
    self:CloseSelf()
end

return this