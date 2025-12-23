SpecialGameplayTip = BaseView:New("SpecialGameplayTip")
local this = SpecialGameplayTip
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog

this.auto_bind_ui_items = {
    "Personalized",
    "anim"
}

this.Prefabsd={
    [1] = "Jweijiuicon",
    [2] = "Shengdanicon",
    [3] = "LeetouManIcon",
    [4] = "SingleWolf",
    [5] = "LuckJourney",
    [6] = "CityDisney",
    [7] = "CityAiji",
    [8] = "CityAiji",
    [9] = "GemQueemIcon",
    [10] = "CandyIcon",
    [11] = "CityMexico",
    [12] = "CityChina",
    [13] = "NewChristmasIcon",
    [14] = "WinzonIcon",
    [15] = "GoldenPigIcon",
    [16] = "DragonFortuneIcon",
    [17] = "NewLeetoleManIcon",
    [18] = "VolcanoIcon",
    [22] = "CityGreece",
    [23] = "MoleMinerIcon",
    [24] = "BisonIcon",
    [25] = "HorseRacingIcon",
    [26] = "ScratchWinnerIcon",
    [27] = "GoldenTrainIcon",
    [28] = "ChristmasSynthesisIcon",
    [29] = "GotYouIcon",
    [30] = "LetemRollIcon",
    [31] = "PiggyBankIcon",
    [32] = "SolitaireIcon",
}


function SpecialGameplayTip:Awake()
    self:on_init()
end

function SpecialGameplayTip:OnEnable(id)
    self.dataid = id
    AnimatorPlayHelper.SetAnimationEvent(self.anim,"SpecialGameplayTip_start",function()
        Facade.SendNotification(NotifyName.CloseUI,ViewList.SpecialGameplayTip)
        ModelList.CityModel.SetDownloadList(id,false)
    end)

    local cfg = table.find(Csv["feature_enter"], function(k, v)
        return v.modular_id == self.dataid
    end)
    local iconPrefabName = nil
    if cfg then
        local abName = AssetList[cfg.modular_icon]
        if not abName then
            local modularCfg = Csv.GetData("modular", cfg.modular_id)
            iconPrefabName = string.format("%sIcon", modularCfg.modular_name)
        else
            iconPrefabName = cfg.modular_icon
        end
        if not AssetList[iconPrefabName] then
            iconPrefabName = this.Prefabsd[self.dataid]
        end
    else
        iconPrefabName = this.Prefabsd[self.dataid]
    end

    if iconPrefabName then
        --log.e(iconPrefabName)
        Cache.load_prefabs(AssetList[iconPrefabName], iconPrefabName, function(ret)
            local tt = fun.get_instance(ret,self.Personalized)
            log.e(tt.name)
            local child = fun.find_child(tt,"root/long/new")
            if child then
                local img = fun.get_component(child, fun.IMAGE)
                if img then
                    this:ShowLogo(img)
                end
            end
        end)
    end
end

---新增需求 https://www.tapd.cn/65500448/prong/stories/view/1165500448001013665
---副玩法入口增加气泡提示，气泡内显示EVENTS，主要用于提示对应副玩法中，存在活动任务
function SpecialGameplayTip:ShowLogo(img)
    if self then
        local tmpData = Csv.GetData("feature_enter",self.dataid)
        log.e(self.dataid)
        if tmpData and ModelList.GameActivityPassModel.HasDataByCityData(tmpData.city_play) and img then
            img.sprite =  AtlasManager:GetSpriteByName("CommonAtlas", "TsrkEvent")
        end

    end

end


function SpecialGameplayTip:OnDisable()

end

return this
