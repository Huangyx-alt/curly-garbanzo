SpecialGameplayEnter = BaseView:New("SpecialGameplayEnter", "SpecialGameplayEnterAtlas")
local this = SpecialGameplayEnter
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog

this.auto_bind_ui_items = {
    "btn_close", --关闭按钮
    "btn_claim",
    "root",
    "btn_Bg",
    "txt_btn"
}

function SpecialGameplayEnter:Awake()
    self:on_init()

end

function SpecialGameplayEnter:OnEnable(params)

    fun.set_active("btn_close", false)
    fun.set_active("btn_claim", false)
    fun.set_active("btn_Bg", false)
    if type(params) == "table" then
        self.dataid = params.pId
        self.isfromPopup = params.isfromPopup
    else
        self.dataid = params
    end

    --self.dataid = params
    UISound.play("feature_pop")
    this:upateData(self.dataid)
    local tmpData = Csv.GetData("feature_enter", self.dataid)
    local portal_data = MachinePortalManager.get_portal_data_by_machine_id(tmpData.modular_id)
    local version = MachineDownloadManager.read_machine_local_version(tmpData.modular_id)
    if portal_data and version and portal_data.version then
        if version >= portal_data.version then
            --已下载
            self.txt_btn.text = "PLAY NOW!"
        else
            self.txt_btn.text = "DOWNLOAD"
        end

    end
end

function SpecialGameplayEnter:OnDisable()

end

function SpecialGameplayEnter:on_btn_close_click()
    self:CheckPopup(false)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.SpecialGameplayEnter, nil, nil)
end

function SpecialGameplayEnter:on_btn_Bg_click()
    self:CheckPopup(false)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.SpecialGameplayEnter, nil, nil)
end

function SpecialGameplayEnter:upateData(id)
    local cfg = Csv.GetData("feature_enter", id)
    local abName, popPrefabName = AssetList[cfg.modular_pop]
    local moduleAtlasName = cfg.modular_atlas
    if not abName then
        local modularCfg = Csv.GetData("modular", cfg.modular_id)
        popPrefabName = string.format("%sPop", modularCfg.modular_name)
    else
        popPrefabName = cfg.modular_pop
    end
    if not moduleAtlasName or moduleAtlasName == "" then
        moduleAtlasName = "SpecialGameplayEnterAtlas"
    end
    
    if not AssetList[popPrefabName] then
        return
    end
    
    if fun.isValidCfgString(cfg.pop_sound) then
        UISound.play(cfg.pop_sound)
    end

    Cache.Load_Atlas(AssetList[moduleAtlasName],moduleAtlasName,function()
        Cache.load_prefabs(nil, popPrefabName, function(ret)
            fun.get_instance(ret, self.root)
            fun.set_active("btn_close", true)
            fun.set_active("btn_claim", true)
            fun.set_active("btn_Bg", true)
        end)
    end)


end

function SpecialGameplayEnter:on_btn_claim_click()
    ---
    local tmpData = Csv.GetData("feature_enter", self.dataid)
    local portal_data = MachinePortalManager.get_portal_data_by_machine_id(tmpData.modular_id)
    local version = MachineDownloadManager.read_machine_local_version(tmpData.modular_id)

    version = version or 0

    -- 2023/02/22 增加默认数据
    if portal_data and version and portal_data.version then
        if version >= portal_data.version then
            --已下载
            local tmpData = Csv.GetData("feature_enter", self.dataid)
            local PlayData = Csv.GetData("city_play", tmpData.city_play)
            if (portal_data.version and portal_data.version > 0) then
                local tmpmodData = Csv.GetData("modular", tmpData.modular_id)
                ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)
            end

            if (portal_data.name ~= nil) then
                --TODO by LwangZg 运行时热更部分
                if resMgr then
                    resMgr:RefreshModuleInfo(portal_data.name)
                end
            end
            self:CheckPopup(false)
            Facade.SendNotification(NotifyName.CloseUI, this)

            if (ViewList.ShopView and ViewList.ShopView.go and fun.get_active_self(ViewList.ShopView.go)) then
                return
            end
            --- 提前预加载模块数据
            for _, v in pairs(Csv.modular) do
                if (v.city_play_id == tmpData.city_play) then
                    ModelList.BattleModel.RequireModuleLua(v.modular_name)
                    SDK.extrapac_open(v.modular_name)
                end
            end
            --跳转到固定城市
            Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter, false, PlayData.city_id, tmpData.city_play)

        else
            self:CheckPopup(true)
            if MachineDownloadManager.is_machine_downloading(portal_data.machine_id) then
                Facade.SendNotification(NotifyName.CloseUI, this)
            else
                local tmpData = Csv.GetData("feature_enter", self.dataid)
                Facade.SendNotification(NotifyName.StartDownloadMachine, tmpData.modular_id)
                Facade.SendNotification(NotifyName.CloseUI, this)
            end
        end
    end
end

--- 检查当从Popup中打开时，触发继续弹窗或者终止弹窗
function SpecialGameplayEnter:CheckPopup(isClose)
    if self.isfromPopup then
        if isClose then
            Event.Brocast(EventName.Event_popup_new_play_type_open)
        else
            Event.Brocast(EventName.Event_popup_new_play_type_open, true)
        end
    else
        Event.Brocast(EventName.Event_popup_new_play_type_open)
    end
end

function SpecialGameplayEnter:HandleFrom(parm)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayEnter, nil, nil, parm)
end

function SpecialGameplayEnter:ShowPop(parm)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayEnter, nil, nil, parm)
end

this.NotifyList = {
    { notifyName = NotifyName.SpecialGameplay.ShowSpecialGameplayEnter, func = this.ShowPop },
}

return this
