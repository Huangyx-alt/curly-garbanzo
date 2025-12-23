SpecialGameplayTip2 = BaseView:New("SpecialGameplayTip2")
local this = SpecialGameplayTip2
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog

this.auto_bind_ui_items = {
    "btn_close",
    "btn_claim",
    "btn_cancel",
    "Personalized"
}

this.Prefabsd={
    [1] = "Shengdanicon",
    [2] = "Jweijiuicon",
    [3] = "LeetouManIcon",
    [4] = "EasterEgg",
    [5] = "LuckJourney",
}



function SpecialGameplayTip2:Awake()
    self:on_init()
end

function SpecialGameplayTip2:OnEnable(params)
    self.dataid  = nil 
    this:UpdataUiData(params.id)
end 

function SpecialGameplayTip2:UpdataUiData(id) --配置表的id
    self.dataid = id 

    if this.Prefabsd[self.dataid] ~= nil then 
        Cache.load_prefabs(AssetList[this.Prefabsd[self.dataid]],this.Prefabsd[self.dataid],function(ret)
            fun.get_instance(ret,self.Personalized)
        end)
    end 
   
end

function SpecialGameplayTip2:OnDisable()
 
end

function SpecialGameplayTip2:on_btn_claim_click()
    --跳转游戏接口
   if self.dataid then 
        -- local tmpData = Csv.GetData("feature_enter",self.dataid)
        -- local PlayData =  Csv.GetData("city_play",tmpData.city_play)

        -- Facade.SendNotification(NotifyName.CloseUI,ViewList.ShowSpecialGameplayTip2)
        -- --设置玩法id 
        -- --ModelList.CityModel.SetPlayId(tmpData.city_play)
        -- --跳转到固定城市
        -- Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,nil,PlayData.city_id,tmpData.city_play)
   end 
end 

function SpecialGameplayTip2:on_btn_cancel_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.ShowSpecialGameplayTip2,nil,nil,parm)
end 

function SpecialGameplayTip2:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.ShowSpecialGameplayTip2,nil,nil,parm)
end 

function SpecialGameplayTip2:ShowPop(parm)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ShowSpecialGameplayTip2,nil,nil,parm)
end 

this.NotifyList = {
    {notifyName = NotifyName.SpecialGameplay.ShowSpecialGameplayTip2, func = this.ShowPop},
}


return this