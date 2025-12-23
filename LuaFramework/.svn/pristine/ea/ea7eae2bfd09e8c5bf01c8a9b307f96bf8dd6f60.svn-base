require "View/CommonView/RemainTimeCountDown"

local VolcanoMissionStartView = BaseDialogView:New('VolcanoMissionStartView', "VolcanoMissionPosterAtlasInMain")
local this = VolcanoMissionStartView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "RemainTime",
    "Description",
    "RewardItem",
    "btn_play",
    "anima"
}

function VolcanoMissionStartView:Awake(obj)
    self:on_init()
end

function VolcanoMissionStartView:on_after_bind_ref()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, { "start", "VolcanoMissionStartView_start" }, false, function()
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
    end
end

function VolcanoMissionStartView:OnEnable()
    self.Description.text = Csv.GetData("description", 8062, "description")
    self:ClearMutualTask()
    self:StartRemainTime()
    self:ShowFinalReward()
end

function VolcanoMissionStartView:OnDisable()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function VolcanoMissionStartView:StartRemainTime()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    else
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end

    local remainTime = ModelList.VolcanoMissionModel:GetRemainTime() + 1
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt7, remainTime, self.RemainTime, function()
        local isAvailable = ModelList.VolcanoMissionModel:IsOpenActivity()
        if not isAvailable then
            self:CloseSelf()
        end
    end)
end

function VolcanoMissionStartView:ShowFinalReward()
    local finalReward, mapTemp
    table.each(Csv["volcano_round"], function(cfg)
        if cfg.reward_final[1][1] ~= 0 then
            if not finalReward then
                finalReward = cfg.reward_final
                mapTemp = cfg.map
            else
                if cfg.map >= mapTemp then
                    finalReward = cfg.reward_final
                    mapTemp = cfg.map
                end
            end
        end
    end)

    fun.eachChild(self.RewardItem.parent, function(child)
        fun.set_active(child, false)
    end)

    table.each(finalReward, function(reward)
        local itemCtrl = fun.get_instance(self.RewardItem, self.RewardItem.parent)
        fun.set_active(itemCtrl, true)

        local refer = fun.get_component(itemCtrl, fun.REFER)
        local icon, count = refer:Get("Icon"), refer:Get("Count")

        local itemIcon = Csv.GetItemOrResource(reward[1], "big_icon")
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIcon)
        count.text = fun.format_number(reward[2])
    end)
end

function VolcanoMissionStartView:CloseSelf(cb)
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, { "end", "VolcanoMissionStartView_end" }, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.HideDialog, self)
                if cb then
                    cb()
                end
            end)
        end
        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.HideDialog, self)
        if cb then
            cb()
        end
    end
end

function VolcanoMissionStartView:on_btn_play_click()
    if not ModelList.VolcanoMissionModel:IsOpenActivity() then
        UIUtil.show_common_popup(8038, true, function()
            self:CloseSelf()
        end)
        log.log("VolcanoMissionStartView:on_btn_play_click() 等级不足")
    else
        self:CloseSelf(function()
            --开启活动逻辑
            ModelList.VolcanoMissionModel:C2S_PlayeMatch(function()
                Facade.SendNotification(NotifyName.VolcanoMission.StartActivity)
            end)
        end)
    end
end

return this


