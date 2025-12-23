

local PowerUpHintView = BaseView:New("PowerUpHintView","PowerUpHintAtlas")
local this = PowerUpHintView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_drawpowerup",
    "btn_thansk",
    "text_tip",
    "btn_warchAd"
}

function PowerUpHintView:OpenView(callback,active)
    Facade.SendNotification(NotifyName.ShowUI,self,function()
        if callback then
            callback()
        end
    end,active)
end

function PowerUpHintView:CloseView(callback)
    Facade.SendNotification(NotifyName.HideUI,self)
end

function PowerUpHintView:Awake(obj)
    self:on_init()
    self._watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_PU_POWER_UP)
end

function PowerUpHintView:OnEnable()
    if self._watchADUtility:IsAbleWatchAd() then
        fun.set_active(self.btn_drawpowerup,false)
        fun.set_active(self.btn_warchAd,true)
    else 
        fun.set_active(self.btn_drawpowerup,true)
        fun.set_active(self.btn_warchAd,false)
    end
end

function PowerUpHintView:OnDisable()

end

function PowerUpHintView:on_close()

end

function PowerUpHintView:OnDestroy()
    this:Close()
end

function PowerUpHintView:on_btn_drawpowerup_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
    Facade.SendNotification(NotifyName.PowerUps.Powerup_hint_goback)
end

function PowerUpHintView:on_btn_warchAd_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
    Facade.SendNotification(NotifyName.PowerUps.Powerup_hint_goback,true)

end 

function PowerUpHintView:on_btn_thansk_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
    Facade.SendNotification(NotifyName.PowerUps.Powerup_hint_nothansk)
end

this.NotifyList = 
{

}

return this