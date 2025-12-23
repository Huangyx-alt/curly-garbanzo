local BravoHelpGuideView = BaseDialogView:New("BravoHelpGuideView","BravoHelpGuideAtlas")
local this = BravoHelpGuideView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_close",
    "btn_fb_connect",
    "main_anim",
    "HdtcBravoBg",
}

function BravoHelpGuideView:Awake()
    this:on_init()
    self:LoadFromUrl()
end

function BravoHelpGuideView:OnEnable()
    Facade.RegisterView(this)
end

function BravoHelpGuideView:OnDisable()
    Facade.RemoveView(this)
    Event.Brocast(EventName.Event_previous_enter_homescene,true)
    
end

function BravoHelpGuideView:LoadFromUrl()
local deeplinkdata = ModelList.PlayerInfoModel.GetDeepLink()
    if deeplinkdata then
        local url = deeplinkdata.GetPromoteShowImgLocalPath()
        if url then 
            local loader = WWWSpriteLoader.create()
            loader:run(url, function(sprite)
                if not sprite then 
                    log.e("load png faild")
                    return nil
                end
                self.HdtcBravoBg.sprite = sprite
                self.backSprite = sprite
                self.HdtcBravoBg:SetNativeSize()
                deeplinkdata:SendBiImpressionEvent()
            end)
        end
    end
end

function BravoHelpGuideView:on_close()
    if(not fun.is_null(self.backSprite))then 
        UnityEngine.Object.Destroy(self.backSprite) --销毁生成的sprite，有内存泄露
        self.backSprite =nil 
    end
   
    ModelList.PlayerInfoModel.GetDeepLink():ResetPromoteData()
end

function BravoHelpGuideView:OnDestroy()
    LuaTimer:ClearTaskList(this.delay_action)
    this.delay_action = nil
    this.close_action = nil
    this.bind_action = nil
   
    this:Close()
end

function BravoHelpGuideView:ToClose()
    if this.close_action then
        this.close_action()
        this.close_action = nil
    end

    this.main_anim:Play("end")
    this.delay_action = this.delay_action or {}
    this.delay_action[#this.delay_action + 1] = LuaTimer:SetDelayFunction(0.31, function()
        --fun.set_active(this.go,false)
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function BravoHelpGuideView:on_btn_close_click() 
      Event.Brocast(EventName.Event_Bravo_Help_Guide_finish)--结束此order状态
      this:ToClose() 
      --增加打点
 
end

function BravoHelpGuideView:on_btn_fb_connect_click()
    --增加打点 
    local url = ModelList.PlayerInfoModel.GetDeepLink().GetDeepLinkUrl()
    ModelList.PlayerInfoModel.GetDeepLink():SetClickPromoteView()   
    ModelList.PlayerInfoModel.C2SBravoHelpSuccess()
    fun.OpenURL(url)
end


function BravoHelpGuideView.OnBravoHelpGuideActivityEnd(data) 
   if data ~= nil then  
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,data,function()
            Event.Brocast(EventName.Event_Bravo_Help_Guide_finish)      --结束此order状态
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
        end)
   else
        Event.Brocast(EventName.Event_Bravo_Help_Guide_finish)      --结束此order状态
   end  
   this:ToClose()
end

this.NotifyList = {
    {notifyName = NotifyName.BravoGuideHelp.DeepLinkHit, func = this.OnBravoHelpGuideActivityEnd},
}

return this

