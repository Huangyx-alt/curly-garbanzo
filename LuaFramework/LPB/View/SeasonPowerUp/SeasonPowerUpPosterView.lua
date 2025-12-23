local SeasonPowerUpPosterView = BaseView:New('SeasonPowerUpPosterView')
local this = SeasonPowerUpPosterView
this.ViewName = "SeasonPowerUpPosterView"

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "anima",
    "btn_close",
    "btn_go",
    "Text3",
    "Text4",
    "Text5",
    "PUsmBuyIcon"
}

function SeasonPowerUpPosterView:Awake()
    self:on_init()
end

function SeasonPowerUpPosterView:OnEnable()
    UISound.play("powerupseasonpop")
    
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()

    self.Text3.text = Csv.GetDescription(8075)
    self.Text4.text = ""--Csv.GetDescription(8076)
    --self.Text5.text = Csv.GetDescription(8077)

    local puID = ModelList.CityModel:GetPuBuffCardId()
    if puID then
        local iconName = Csv.GetData("new_powerup", puID, "icon")
        Cache.SetImageSprite("ItemAtlas", iconName, self.PUsmBuyIcon)
    end
end

function SeasonPowerUpPosterView:on_after_bind_ref()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, { "in", "SeasonPowerUpPosterViewenter" }, false, function()
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
end

function SeasonPowerUpPosterView:CloseView(callBack)
    AnimatorPlayHelper.Play(self.anima, { "end", "SeasonPowerUpPosterViewend" }, false, function()
        if callBack then
            callBack()
        end
    end)
end

function SeasonPowerUpPosterView:on_btn_close_click()
    self:CloseView(function()
        Facade.SendNotification(NotifyName.CloseUI, self)
    end)
end

function SeasonPowerUpPosterView:on_btn_go_click()
    self:CloseView(function()
        local go = self:GetOpenedPowerUpView()
        if fun.is_not_null(go) then
            self:ShowPowerItemFly(go)
        else
            Facade.SendNotification(NotifyName.HallMainView.PlayCardsClick, 4, true, function(viewGo)
                self:ShowPowerItemFly(viewGo)
            end)
        end
    end)
end

function SeasonPowerUpPosterView:GetOpenedPowerUpView()
    if ViewList.PowerUpView.isShow then
        return ViewList.PowerUpView.go
    end
    if ViewList.PowerUpViewSilver.isShow then
        return ViewList.PowerUpViewSilver.go
    end
    if ViewList.PowerUpViewGoldNova.isShow then
        return ViewList.PowerUpViewGoldNova.go
    end
    if ViewList.PowerUpViewMaster.isShow then
        return ViewList.PowerUpViewMaster.go
    end
end

function SeasonPowerUpPosterView:ShowPowerItemFly(viewGo)
    if fun.is_not_null(viewGo) then
        local refer = fun.get_component(viewGo, fun.REFER)
        if not refer then
            Facade.SendNotification(NotifyName.CloseUI, self)
            return
        end

        local target = refer:Get("img_icon")
        if not target then
            Facade.SendNotification(NotifyName.CloseUI, self)
            return
        end
        fun.enable_component(target, false)

        coroutine.start(function()
            --等pu机台入场动画
            coroutine.wait(1.2)

            fun.enable_component(self.anima, false)
            local effect = fun.find_child(target.transform.parent, "Effect")

            --飞道具tt
            local animTime = 0.5
            local targetPos = target.transform.position
            Anim.move_ease(self.PUsmBuyIcon.gameObject, targetPos.x, targetPos.y, targetPos.z,
                    animTime, false, DG.Tweening.Ease.InOutSine, function()
                        fun.enable_component(target, true)
                        if fun.is_not_null(effect) then
                            fun.set_active(effect, true)
                        end
                        Facade.SendNotification(NotifyName.CloseUI, self)
                        self:SavePlayPrefs()
                        ModelList.GuideModel:OpenUI("PowerUpView")
                    end)

            local targetScale = target.transform.localScale
            Anim.scale(self.PUsmBuyIcon.gameObject, targetScale.x,  targetScale.y, targetScale.z,
                    animTime, true, function()

                    end)
        end)
    else
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function SeasonPowerUpPosterView:SavePlayPrefs()
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    local endTime = ModelList.CityModel:GetPuBuffSeasonEndTime()
    local popKey = "SeasonPowerUpPosterView_FlyPower" .. endTime .. userID
    fun.save_value(popKey, 1)
end

return this



