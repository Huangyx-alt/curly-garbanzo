local VolcanoMissionTipsView = BaseDialogView:New('VolcanoMissionTipsView')
local this = VolcanoMissionTipsView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "text_tipsinfo",
    "btn_close",
    "btn_buy",
    
}

function VolcanoMissionTipsView:Awake() end

function VolcanoMissionTipsView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
 
end

 
function VolcanoMissionTipsView:InitView()
 
end

function VolcanoMissionTipsView:OnDisable()
    Facade.RemoveViewEnhance(self)
 
end

 

function VolcanoMissionTipsView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,self)
    Facade.SendNotification(NotifyName.VolcanoMission.RewardEnd)
end
function VolcanoMissionTipsView:on_btn_buy_click()
    Facade.SendNotification(NotifyName.CloseUI,self)
    local isSuccess = ModelList.GiftPackModel:ShowVolcanoMissionPack()
    -- Facade.SendNotification(NotifyName.ShowDialog,ViewList.VolcanoMissionGiftPackView)

    if(isSuccess == false)then 
        --礼包不存在时候保证不卡流程
        Facade.SendNotification(NotifyName.VolcanoMission.RewardEnd)
    end

    
end





return this
