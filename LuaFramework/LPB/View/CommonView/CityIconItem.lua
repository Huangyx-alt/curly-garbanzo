
local CityIconItem = BaseView:New("CityIconItem")
local this = CityIconItem

this.auto_bind_ui_items = {
    "cityIcon",
    "cityPuzzleProgress",
    "textPuzzleProgress",
    "lock",
    "btn_city",
    "scrollBackground",
    "scrollFill",
    "Anim",
    "shou",
    "cityItemjiaose",
    "cityItemjiaose_spine",
    "textName",
    "btnSprite"
}


function CityIconItem:New(owner,config)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.owner = owner
    o.config = config
    o.cityId = config.scene_id
    return o
end

function CityIconItem:Awake()
    self:on_init()
end

function CityIconItem:OnEnable()
    self:InitIcon(self.cityId)
    fun.set_active(self.shou, false)
    fun.set_active(self.cityItemjiaose, false)
    self:InitProgress()
    self.textName.text = self.config.scene_name
    local curCityIndex = ModelList.NewPuzzleModel:GetNewUnlockScene()
    if self.cityId == curCityIndex then
        fun.play_animator(self.btnSprite, "enter", true)
    else
        fun.play_animator(self.btnSprite, "end", true)
    end
end

function CityIconItem:RefreshIcon(isUnlock,sprite)
    self.cityIcon.sprite = sprite
    if isUnlock then
        fun.set_active(self.lock , false)
        Util.SetUIImageGray(self.scrollBackground, false)
        Util.SetUIImageGray(self.scrollFill, false)
        fun.play_animator(self.Anim, "idle", true)
    else
        fun.set_active(self.lock , true)
        Util.SetUIImageGray(self.scrollBackground, true)
        Util.SetUIImageGray(self.scrollFill, true)
        fun.play_animator(self.Anim, "idlelock", true)
    end
end

function CityIconItem:OnDestroy()
    self:Close()
end

function CityIconItem:GetIconSprite(cityId,isUnlock)
    --每4个机台素材是1个图集
    local atlasIndex = 1
    local atlasName = "CityIcon" .. atlasIndex
    local cityName = cityId
    if cityId < 10 then
        cityName = "0" .. cityId
    end
    local spriteName = ""
    if isUnlock then
        spriteName = self.config.scene_icon_unlcok
    else
        spriteName = self.config.scene_icon_lock
    end
    return AtlasManager:GetSpriteByName(atlasName,spriteName)
end

function CityIconItem:AnimCityItemScale(startScale,finishScale,lastTargetIndex,targetIndex)
    self.go.transform.localScale = startScale
    local curCityIndex = ModelList.NewPuzzleModel:GetNewUnlockScene()
    Anim.scale_to_xy(self.go,finishScale.x,finishScale.y,1, function()
    end)
    if self.cityId > curCityIndex then
        log.log("城市未解锁 ")
        return
    end
    if self.cityId == lastTargetIndex then
        --上次中心点是这个
        fun.play_animator(self.btnSprite, "end", true)
    end

    if self.cityId == targetIndex then
        --这次中心点是这个
        fun.play_animator(self.btnSprite, "enter", true)
    end
end

function CityIconItem:InitIcon(cityId)
    local mayOpen = ModelList.NewPuzzleModel:IsScenePuzzleUnlock(cityId)
    local sprite = self:GetIconSprite(cityId,mayOpen)
    self:RefreshIcon(mayOpen,sprite)
    
    --下载判断todo
    --local loadDefault,MachineItemData = CityHomeScene:CheckNeedDownload(cityId)
    --if loadDefault == 0  then
    --    --下载状态 todo
    --    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    --    --推荐玩法得也一定是开放得  --false 才是开启
    --    --local mayOpen = Csv.GetCityLevelOpen2(cityId,playerLevel)
    --    local mayOpen = ModelList.NewPuzzleModel:IsScenePuzzleUnlock(cityId)
    --    local sprite = self:GetIconSprite(cityId,mayOpen)
    --    self:RefreshIcon(mayOpen,sprite)
    --elseif loadDefault ==1 then
    --    --下载中
    --else
    --    --下载完
    --    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    --    --local mayOpen = Csv.GetCityLevelOpen2(cityId,playerLevel)
    --    local mayOpen = ModelList.NewPuzzleModel:IsScenePuzzleUnlock(cityId)
    --    local sprite = self:GetIconSprite(cityId,mayOpen)
    --    self:RefreshIcon(mayOpen,sprite)
    --end
end

function CityIconItem:on_btn_city_click()
    if not self.owner:CheckMove(self.cityId) then
        return
    end
    self:HideGuideTip()
    local mayOpen = ModelList.NewPuzzleModel:IsScenePuzzleUnlock(self.cityId)
    if not mayOpen then
        log.log("机台未解锁")
        UIUtil.show_common_popup(191297,true)
        return
    end
    ModelList.CityModel.C2S_ChangeCity(self.cityId)
    Facade.SendNotification(NotifyName.HallCity.Click_City_Enter,false, 1)
    
    --下载判断todo
    --local loadDefault,MachineItemData = CityHomeScene:CheckNeedDownload(self.cityId)
    --log.log("进入机台点击 " , self.cityId)
    --if loadDefault ==0  then
    --    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    --    --推荐玩法得也一定是开放得  --false 才是开启
    --    local mayopen = Csv.GetCityLevelOpen2(self.cityId,playerLevel)
    --    if mayopen then
    --        CityHomeScene:EntityViewDownload(self.go,MachineItemData,loadDefault)
    --    end
    --elseif loadDefault ==1 then
    --
    --else
    --    if CityHomeScene:CanClickCity() then
    --        if self:Check_WinZone_Need_Open() then
    --            ModelList.BattleModel.RequireModuleLua("WinZone")
    --            local winzoneView = require("View/WinZone/WinZoneInPropgressView")
    --            Facade.SendNotification(NotifyName.ShowUI,winzoneView:New())
    --            return
    --        end
    --        if ModelList.WinZoneModel.CheckHasRewardAndCannotRelive() then
    --            return
    --        end
    --        
    --        ModelList.CityModel.C2S_ChangeCity(self.cityId)
    --        --主玩法cityplayid 固定是1,对应new_city_play表ID
    --        --Facade.SendNotification(NotifyName.HallCity.Click_City_Enter,false,self.cityId)
    --        Facade.SendNotification(NotifyName.HallCity.Click_City_Enter,false, 1)
    --    end
    --end
end

function CityIconItem:Check_WinZone_Need_Open()
    if ModelList.WinZoneModel:IsActivityValid() and ModelList.WinZoneModel:ShouldGotoGameHall() then
        return true
    end
    return false
end

function CityIconItem:InitProgress()
    local now, total = ModelList.NewPuzzleModel:GetPuzzleCollectData(self.cityId)
    log.r(string.format("[CityIconItem] InitProgress now:%s, total:%s", now, total))
    if not now then
        self.cityPuzzleProgress.value = 0
        self.textPuzzleProgress.text = string.format("%s/%s", 0, 0)
        return
    end
    if now >= total then
        self.cityPuzzleProgress.value = 1
        self:ShowComplete()
    else
        self.cityPuzzleProgress.value = now / total
        self.textPuzzleProgress.text = string.format("%s/%s", now, total)        
    end
end

function CityIconItem:ShowProgressUpdate()
    local now, total = ModelList.NewPuzzleModel:GetPuzzleCollectData(self.cityId)
    log.r(string.format("[CityIconItem] ShowProgressUpdate now:%s, total:%s", now, total))
    if not now then
        return
    end
    
    local cur = self.cityPuzzleProgress.value
    local target = now / total
    target = Mathf.Clamp(target, 0, 1)
    
    if cur < target then
        Anim.do_smooth_float_update(cur, target, 0.3, function(v)
            self.cityPuzzleProgress.value = v
        end, function()
            self.cityPuzzleProgress.value = target
            self.textPuzzleProgress.text = string.format("%s/%s", now, total)
        end)
    else
        self.textPuzzleProgress.text = string.format("%s/%s", now, total)
    end
end

function CityIconItem:ShowComplete()
    self.cityPuzzleProgress.value = 1
    fun.play_animator(self.Anim, "full", true)
    fun.set_active(self.cityItemjiaose, false)
    fun.set_active(self.lock , false)
    Util.SetUIImageGray(self.scrollBackground, false)
    Util.SetUIImageGray(self.scrollFill, false)
    
end

function CityIconItem:ShowLastCityFinish()
    fun.play_animator(self.btnSprite, "end", true)

end

function CityIconItem:ShowUnLock()
    --local curCityIndex = ModelList.NewPuzzleModel:GetNewUnlockScene()
    --local mayOpen = ModelList.NewPuzzleModel:IsScenePuzzleUnlock(self.cityId)
    --local mayOpen = curCityIndex >= self.cityId
    --解锁判定有问题 直接用true todo
    local sprite = self:GetIconSprite(self.cityId, true)
    self:RefreshIcon(mayOpen,sprite)
    fun.play_animator(self.btnSprite, "enter", true)
    fun.play_animator(self.Anim, "cityItemiunlock", true)
end

function CityIconItem:PlayGuideTip()
    fun.set_active(self.cityItemjiaose, true)
    self.cityItemjiaose_spine:PlayByName("enter", false)
    coroutine.wait(1)
    self.cityItemjiaose_spine:PlayByName("idle", true)
    fun.set_active(self.shou, true)
end

function CityIconItem:HideGuideTip()
    fun.set_active(self.cityItemjiaose, false)
    fun.set_active(self.shou, false)
end

function CityIconItem:CityFocusShow()
    fun.play_animator(self.btnSprite, "enter", true)
    fun.set_active(self.cityItemjiaose, true)
    self.cityItemjiaose_spine:PlayByName("idle", true)
end

function CityIconItem:CityLeaveShow()
    fun.set_active(self.cityItemjiaose, false)
end

return CityIconItem