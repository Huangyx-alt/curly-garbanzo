require "Scene/CityEntityView"
require "Scene/CityDownloadView"

require "Scene/LobbyEntityView"

require "Scene/BaseScene"
require "Scene/BaseHomeSceneEntity"
require "Scene/HomeSceneSelectCityView"
require "Scene/HomeSceneNormalLobbyView"
require "Scene/HomeSceneAutoLobbyView"

require "Scene/State/CityDragBaseState"
require "Scene/State/CityDragOriginalState"
require "Scene/State/CityDragLeftState"
require "Scene/State/CityDragRightState"
require "Scene/State/CityDragLeftLimitState"
require "Scene/State/CityDragRightLimitState"
require "Scene/State/CityDragLeftEndState"
require "Scene/State/CityDragRightEndState"
require "Scene/State/CityDragLimitEndState"
require "Scene/State/CityTurnPageRight"
require "Scene/State/CityTurnPageLeft"
require "Scene/State/CityDragStiffState"

LuaEasyTouchDragState = {startdrag = 0,dragging = 1,enddrag = 2}
CityHomeScene = BaseScene:New("SceneHome","CityHomeScene")
local this = CityHomeScene
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local currentCity = 1
local cityGross = 0
local cityList = nil

local cityEntityCach = {}

local evntsystem = UnityEngine.EventSystems.EventSystem

this.PER_DRAG_WIDTH = 1204

local homeSceneEntityView = nil

local dragMoveCity = nil

local lobbyEntity = nil
local hallView = nil

local drag_state = LuaEasyTouchDragState.enddrag

local AnimationCurve = UnityEngine.AnimationCurve
local Keyframe = UnityEngine.Keyframe
local Time = UnityEngine.Time
local isEnterHallFromBattle = false
local isEnterHallFromUI = false
this.auto_bind_ui_items = {
    "BgContainer",
    "hang_point",
    "city01",
    "city02",
    "drag_anima",
    "lobby_anchor",
    "downloadEntity",
    "cityScrollView",
    "cityItem",
}

function CityHomeScene:Awake(obj)
    self.update_x_enabled = true
    self:on_init()

    local view = require "View/CommonView/DownloadCityUtility"
    this._DownloadCityUtility = view:New()
    this._DownloadCityUtility:SkipLoadShow(self.downloadEntity)
end

function CityHomeScene:OnEnable()
    Facade.RegisterView(self)
    self:AddEvent()
    self:BuildFsm()

    self._fsm:GetCurState():EnterHallCity(self._fsm)

    --Util.SetLuaDrag(self.OnDragCity);
    self._deltaPosX = 0

    --self:SetCity()
    self:SetNormalLobby()
    self:SetAutoLobby()
    self:InitLobbyCityIcon()    
    if not self:BuildHomeSceneEntityView() then
        homeSceneEntityView:GetCurState():EnterHomeEntity(homeSceneEntityView)
    end
end

function CityHomeScene:OnEnterHomeScene(occasion)
    if occasion == PopupOrderOccasion.login then
        if cityEntityCach[currentCity] then
            cityEntityCach[currentCity]:PlayExitLobby()
        end
    elseif occasion == PopupOrderOccasion.enterMainCity then
        self._fsm:GetCurState():Finish(self._fsm)
    end
    self:SetEnterHallFromBattle(false)
    self:SetEnterHallFromUI(false)
end

function CityHomeScene:OnDisable()
    Facade.RemoveView(self)
    --if self.cityIconScrollView then
    --    self.cityIconScrollView:OnDisable()
    --end
    self:RemoveEvent()
end

function CityHomeScene:OnDestroy()
    if self.cityIconScrollView then
        self.cityIconScrollView:OnDestroy()
    end
    self.cityIconScrollView = nil
    self:Close()
    self:DisposeFsm()
    cityEntityCach = {}
    cityList = nil
    currentCity = 1
    cityGross = 0
    --AssetManager.unload_ab(self.cityEntity_Ab_List)
end

function CityHomeScene:on_x_update()
    if dragMoveCity then
        local time = Time.time - dragMoveCity.time
        if fun.is_not_null(self.hang_point) then
            self.hang_point.transform.localPosition = Vector3.New(dragMoveCity.acx:Evaluate(time),0,0)
            if time >= dragMoveCity.acx[dragMoveCity.acx.length - 1].time then
                dragMoveCity.callback()
                dragMoveCity = nil
            end
        end
    end
    ModelList.ApplicationGuideModel:CheckAnyInput()
end

function CityHomeScene:AddEvent()
    Event.AddListener(EventName.Event_enterhome_previous_finish,self.OnEnterCityScene,self)
    Event.AddListener(EventName.Event_enter_homescene,self.OnEnterHomeScene,self)
end

function CityHomeScene:RemoveEvent()
    Event.RemoveListener(EventName.Event_enterhome_previous_finish,self.OnEnterCityScene,self)
    Event.RemoveListener(EventName.Event_enter_homescene,self.OnEnterHomeScene,self)
end

function CityHomeScene:OnEnterCityScene()
    self._fsm:GetCurState():Finish(self._fsm)
end

function CityHomeScene:IsSelectCity()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():IsSelectCity()
    end
    return false
end

function CityHomeScene:IsLobby()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():IsLobby()
    end
    return false
end

function CityHomeScene:IsNormalLobby()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():IsNormalLobby()
    end
    return false
end

function CityHomeScene:IsAutoLobby()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():IsAutoLobby()
    end
    return false
end

function CityHomeScene:IsCityOrLobby()
    return this:IsSelectCity() or this:IsNormalLobby() or this:IsAutoLobby()
end

function CityHomeScene:IsFirstLogin()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():IsFirstLogin()
    end
    return true
end

function CityHomeScene:CanClickCity()
    if self._fsm then
        return self._fsm:GetCurState():CanClickCity()
    else
        return false    
    end
end

function CityHomeScene:GetSceneName()
    if homeSceneEntityView and self.go then
        return homeSceneEntityView:GetCurState():GetSceneName()
    end
    return ""
end

function CityHomeScene:BuildHomeSceneEntityView()
    if not homeSceneEntityView then
        homeSceneEntityView = Fsm.CreateFsm("HomeSceneEntityView",self,{
            HomeSceneSelectCityView,
            HomeSceneNormalLobbyView,
            HomeSceneAutoLobbyView
        })
        homeSceneEntityView:StartFsm("HomeSceneSelectCityView")
        return true
    end
    return false
end

function CityHomeScene:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("CityHomeScene",self,{
        CityDragOriginalState:New(),
        CityDragLeftState:New(),
        CityDragRightState:New(),
        CityDragLeftLimitState:New(),
        CityDragRightLimitState:New(),
        CityDragLeftEndState:New(),
        CityDragRightEndState:New(),
        CityDragLimitEndState:New(),
        CityDragStiffState:New(),
        CityTurnPageRight:New(),
        CityTurnPageLeft:New()
    })
    self._fsm:StartFsm("CityDragOriginalState")
end

function CityHomeScene:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function CityHomeScene.OnDragCity(state,go,startPos,pos,deltaTime)
    local bundle = {}
    bundle.state = state
    bundle.go = go
    bundle.startPos = startPos
    bundle.pos = pos
    bundle.deltaTime = deltaTime
    Facade.SendNotification(NotifyName.SceneCity.NotifyDragEvent, bundle)

    if homeSceneEntityView:GetCurState():CanDragCity() then
       
        local curSelectGo = evntsystem.current.currentSelectedGameObject
        if curSelectGo == nil then
            return
        end
        if curSelectGo.name ~= "btn_entry" and curSelectGo.name ~= "BgContainer" then
            return
        end
        drag_state = state
        if this._fsm then
            this._fsm:GetCurState():OnDragCity(state,go,startPos,pos,deltaTime)
        end
    end
end

function CityHomeScene:OnApplicationPause(pause)
    if pause == true then
        this.OnDragCity(2,nil,nil,nil ,0)
        
    end
    
end

function CityHomeScene:OnStartDrag(go,pos)
    if fun.is_not_null(self.hang_point) then
        self.deltaPosition = pos - self.hang_point.transform.localPosition
        self._dragPosX = self.hang_point.transform.localPosition.x
        if go == self.city01 then
            self.currenCity = self.city01
            self.nextCity = self.city02
        elseif go == self.city02 then
            self.currenCity = self.city02
            self.nextCity = self.city01
        end
        Facade.SendNotification(NotifyName.SceneCity.StartDragCity)
    end
end

function CityHomeScene:OnDragLeft()
    self:SetCityEntityDragLeft()
    self:ChangeCity(self.nextCity,cityList[currentCity - 1], cityList[currentCity + 1],nil,true)
end

function CityHomeScene:SetCityEntityDragLeft()
    if fun.is_not_null(self.currenCity) then
        local bgPos = self.currenCity.transform.localPosition
        fun.set_gameobject_pos(self.nextCity,bgPos.x + self.PER_DRAG_WIDTH,bgPos.y,0,true)
        self:SetColumnPos(bgPos)
    end
end

function CityHomeScene:OnDragRight()
    self:SetCityEntityDragRight()
    self:ChangeCity(self.nextCity,cityList[currentCity + 1], cityList[currentCity - 1],nil,true)
end

function CityHomeScene:SetCityEntityDragRight()
    if fun.is_not_null(self.currenCity) then
        local bgPos = self.currenCity.transform.localPosition
        fun.set_gameobject_pos(self.nextCity,bgPos.x - self.PER_DRAG_WIDTH,bgPos.y,0,true)
        self:SetColumnPos(bgPos)
    end
end

function CityHomeScene:GetDragLeftKeyFrame()
    if self and fun.is_not_null(self.hang_point) then
        local pos = self.hang_point.transform.localPosition
        local kf1 =  Keyframe.New(0,pos.x)
        kf1.outTangent = -200

        local kf2 =  Keyframe.New(0.25,-(currentCity * self.PER_DRAG_WIDTH))
        kf2.inTangent = -1000

        local ac_x = AnimationCurve.New(
                kf1,
                kf2
        )
        return ac_x
    end
    return nil
end

function CityHomeScene:OnDragLeftEnd()
    local ac_x = self:GetDragLeftKeyFrame()
    dragMoveCity = {acx = ac_x,time = Time.time,callback = function()
        cityEntityCach[currentCity]:Shutoff(false)
        cityEntityCach[currentCity]:SetActive(false)
        self:SetCurrentCityIndex(math.min(currentCity + 1,cityGross))
        ModelList.CityModel.C2S_ChangeCity(cityList[currentCity])
        Event.Brocast(EventName.Event_change_city,cityList[currentCity])
        self._fsm:GetCurState():OnDragComplete(self._fsm)
        Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
        UISound.play("city_switch")
    end}

    if cityEntityCach[currentCity + 1] then
        cityEntityCach[currentCity + 1]:PlayDragMoveLeft()
    end
end

function CityHomeScene:OnDragLeftCrossEnd()
    local maxCity = ModelList.CityModel:GetMaxCity()
    local ac_x = self:GetDragLeftKeyFrame()
    dragMoveCity = {acx = ac_x,time = Time.time,callback = function()
        cityEntityCach[currentCity]:Shutoff(false)
        self:SetCurrentCityIndex(math.min(maxCity,cityGross))
        ModelList.CityModel.C2S_ChangeCity(cityList[maxCity])
        self._fsm:GetCurState():OnDragComplete(self._fsm)
        Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
        UISound.play("city_switch")
    end}

    if cityEntityCach[maxCity] then
        cityEntityCach[maxCity]:PlayDragMoveLeft()
    end
end

function CityHomeScene:GetDragRightKeyFrame()
    if fun.is_not_null(self.hang_point) then
        local pos = self.hang_point.transform.localPosition
        local kf1 =  Keyframe.New(0,pos.x)
        kf1.outTangent = 200

        local kf2 = Keyframe.New(0.25,-((currentCity - 2) * self.PER_DRAG_WIDTH))
        kf2.inTangent = 1000

        local ac_x = AnimationCurve.New(
                kf1,
                kf2
        )
        return ac_x
    end
    return nil
end

function CityHomeScene:OnDragRightEnd()
    local ac_x = self:GetDragRightKeyFrame()
    dragMoveCity = {acx = ac_x,time = Time.time,callback = function()
        cityEntityCach[currentCity]:Shutoff(false)
        cityEntityCach[currentCity]:SetActive(false)
        self:SetCurrentCityIndex(math.max(currentCity - 1,1))
        ModelList.CityModel.C2S_ChangeCity(cityList[currentCity])
        Event.Brocast(EventName.Event_change_city,cityList[currentCity])
        self._fsm:GetCurState():OnDragComplete(self._fsm)
        Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
        UISound.play("city_switch")
    end}   

    if cityEntityCach[currentCity - 1] then
        cityEntityCach[currentCity - 1]:PlayDragMoveRight()
    end
end

function CityHomeScene:OnDragRightCrossEnd()
    local maxCity = ModelList.CityModel:GetMaxCity()
    local ac_x = self:GetDragRightKeyFrame()
    dragMoveCity = {acx = ac_x,time = Time.time,callback = function()
        cityEntityCach[currentCity]:Shutoff(false)
        self:SetCurrentCityIndex(math.max(maxCity,1))
        ModelList.CityModel.C2S_ChangeCity(cityList[maxCity])
        self._fsm:GetCurState():OnDragComplete(self._fsm)
        Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
        UISound.play("city_switch")
    end}   

    if cityEntityCach[maxCity] then
        cityEntityCach[maxCity]:PlayDragMoveRight()
    end
end

function CityHomeScene:OnDragLimitEnd(params)
    if params == 1 then
        cityEntityCach[currentCity]:PlayDragMoveLeft(0.15)
    else
        cityEntityCach[currentCity]:PlayDragMoveRight(0.15)
    end
    if fun.is_not_null( self.hang_point) then
        local pos_container = self.hang_point.transform.localPosition
        Anim.move_ease(self.hang_point,self._dragPosX ,pos_container.y,0,0.2,true,DG.Tweening.Ease.Flash,function()
            self._fsm:GetCurState():OnDragComplete(self._fsm)
            Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
        end)
    else
        self._fsm:GetCurState():OnDragComplete(self._fsm)
        Facade.SendNotification(NotifyName.SceneCity.EndDragCity)
    end
end

function CityHomeScene:IsDragLeftMax()
    return currentCity >= cityGross
end

function CityHomeScene:IsDragRightMax()
    return currentCity <= 1
end

function CityHomeScene:OnDragRightMove(pos,limit)
    local deltaPosition = pos - (this.deltaPosition or {x = 0,y = 0})
    if limit then
        deltaPosition.x = math.min(50,deltaPosition.x)
    else
        deltaPosition.x = math.min(-1 * self.PER_DRAG_WIDTH * (currentCity - 1) + 110,deltaPosition.x)
    end
    deltaPosition.x = math.min((this._dragPosX or 0) + this.PER_DRAG_WIDTH, deltaPosition.x)
    fun.set_gameobject_pos(this.hang_point,math.min(self:GetHangPointPosX() + 20,deltaPosition.x),0,0,true)
end

function CityHomeScene:OnDragLeftMove(pos,limit)
    local deltaPosition = pos - (this.deltaPosition or {x = 0,y = 0, z = 0})
    if limit then
        deltaPosition.x = math.max(-1 * self.PER_DRAG_WIDTH * (cityGross - 1) - 50,deltaPosition.x)
    else
        deltaPosition.x = math.max(-1 * self.PER_DRAG_WIDTH * (currentCity - 1) - 110,deltaPosition.x)    
    end
    deltaPosition.x = math.max((this._dragPosX or 0) - this.PER_DRAG_WIDTH, deltaPosition.x)
    fun.set_gameobject_pos(this.hang_point,math.max(self:GetHangPointPosX() - 20,deltaPosition.x),0,0,true)
end

function CityHomeScene:GetHangPointPosX()
    if fun.is_not_null(this.hang_point) then
        return this.hang_point.transform.localPosition.x
    end
    return 0
end

function CityHomeScene:SetCurrentCityIndex(index)
    if index then
        currentCity = index or 1
    end
end

function CityHomeScene:GetCurrentCity()
    return cityList[currentCity]
end

function CityHomeScene:SetCity(force)
    
    if cityList == nil or force then
        local citys = Csv.city
        local cityId = ModelList.CityModel.GetHomeCity() 
        if cityId == -1 then 
            cityId = ModelList.CityModel:GetCity()
        end 
        cityGross = 0
        cityList = {}
        local c0 = 0
        local c1 = 1
        local c2 = 2
        local totalCity = #citys
        for i, v in ipairs(citys) do
            if 1 == v.city_type then
                cityGross = cityGross + 1
                table.insert(cityList,v.id)
                if v.id == cityId then
                    c1 = i
                    c2 = math.min(i + 1,totalCity)
                    c0 = c1 - 1
                end
            end
        end
        for key, value in pairs(cityEntityCach) do
            if key ~= c1 and key ~= c2 then
                value:SetActive(false)
            end
        end

        self:SetCurrentCityIndex(c1)
        if c1 == c2 then
            self:ChangeCity(self.city01,-1,c1)
            self:ChangeCity(self.city02,-1,c1 - 1,function()
                self:InitCityComplete()
            end)
        else
            if c0 > 0 then
                self:ChangeCity(self.city02,-1,c0,nil,false)
            end
            self:ChangeCity(self.city01,-1,c1)
            self:ChangeCity(self.city02,-1,c2,function()
                self:InitCityComplete()
            end)
        end

        fun.set_gameobject_pos(self.hang_point,-(self.PER_DRAG_WIDTH * (c1 - 1)),0,0,true)
        fun.set_gameobject_pos(self.city01,self.PER_DRAG_WIDTH * (c1 - 1),0,0,true)
        fun.set_gameobject_pos(self.city02,self.PER_DRAG_WIDTH * c1,0,0,true)
        if fun.is_not_null(self.city01) then
            self:SetColumnPos(self.city01.transform.localPosition)
        end
    end
    Event.Brocast(EventName.Event_change_city,cityList[currentCity])
end

function CityHomeScene:SetColumnPos(pos)
end

function CityHomeScene:InitCityComplete()
    Facade.SendNotification(NotifyName.LoadScene.LoadSceneComplete)
    Event.Brocast(EventName.Event_loadcityscenefinish)
end

function CityHomeScene:ChangeCity(parent,oldCity,newCity,callback,active)
    self:InitCityComplete()
    --if cityEntityCach[newCity] and cityEntityCach[newCity].loadingSign then
    --    --防止异步加载资源发生重复加载
    --    return
    --end
    --if oldCity and cityEntityCach[oldCity] then
    --    cityEntityCach[oldCity]:SetActive(false)
    --end
    --
    --if newCity then
    --        
    --    if cityEntityCach[newCity] then
    --        cityEntityCach[newCity]:SetParent(parent)
    --        if newCity == currentCity or active then
    --            ModelList.CityModel.SetHomeCity(newCity) 
    --            ModelList.CityModel.C2S_ChangeCity(newCity)
    --            cityEntityCach[newCity]:SetActive(true)
    --        else
    --            cityEntityCach[newCity]:SetActive(false)    
    --        end
    --    else
    --        local pName = string.format("City%sEntity",newCity)
    --        local ab = AssetList[pName] --"luaprefab_prefabs_CityEntity" --string.format("luaprefab_prefabs_CityEntity",newCity)
    --        local pName_atlas = string.format("City%sEntityAtlas",newCity)
    --        if ab then
    --            if self.cityEntity_Ab_List == nil then
    --                self.cityEntity_Ab_List = {}
    --            end
    --            self.cityEntity_Ab_List[newCity] = ab
    --            cityEntityCach[newCity] = CityEntityView:New(newCity);
    --            cityEntityCach[newCity].loadingSign = true
    --            if newCity == 1 or newCity == 2 or newCity == 3 then
    --                --TODO 资源加载接口替换 by LwangZg
    --                Cache.Load_Atlas(AssetList[pName_atlas],pName_atlas,function(ret)
    --                    Cache.load_prefabs(ab,pName,function(ret)
    --                        cityEntityCach[newCity].loadingSign = nil
    --                        if ret then
    --                            --TODO 创建一个克隆 by LwangZg,图集和预制体时机没对上
    --                            local go = Cache.create(ab,pName)
    --                            if parent then
    --                                if (newCity == currentCity or active) and self:IsSelectCity() then
    --                                    ModelList.CityModel.SetHomeCity(newCity)
    --                                    ModelList.CityModel.C2S_ChangeCity(newCity)
    --                                    cityEntityCach[newCity]:SkipLoadShow(go,true)
    --                                else
    --                                    cityEntityCach[newCity]:SkipLoadShow(go,false)
    --                                end
    --                                cityEntityCach[newCity]:SetParent(parent)
    --
    --
    --                            end
    --                            if callback then
    --                                callback()
    --                            end
    --                        end
    --                    end)
    --                end)
    --            else
    --                log.log("dps 加载城市UI " , ab , pName)
    --                Cache.load_prefabs(ab,pName,function(ret)
    --                    cityEntityCach[newCity].loadingSign = nil
    --                    if ret then
    --                        local go = Cache.create(ab,pName)
    --                        if parent then
    --                            if (newCity == currentCity or active) and self:IsSelectCity() then
    --                                ModelList.CityModel.SetHomeCity(newCity)
    --                                ModelList.CityModel.C2S_ChangeCity(newCity)
    --                                cityEntityCach[newCity]:SkipLoadShow(go,true)
    --                            else
    --                                cityEntityCach[newCity]:SkipLoadShow(go,false)
    --                            end
    --                            cityEntityCach[newCity]:SetParent(parent)
    --
    --
    --                        end
    --                        if callback  --执行进入城市场景 self:InitCityComplete() 
    --                            callback()
    --                        end
    --                    end
    --                end)
    --            end
    --        end
    --    end
    --end
end

function CityHomeScene:CheckNeedDownload(newCity)
     --如果没有的话，去读取默认的模板
     local MachineItemData = nil 
     local Macheindata = deep_copy( MachinePortalManager.get_portal_data_by_machine())
   
     local loadDefault = 2  --已下载 
     --and fun.IsEditor() == false
     if Macheindata and type(Macheindata) == "table"  then 
         for _,v in pairs(Macheindata) do
             if  v.moduleType == modular_type.cityType and newCity == v.cityId then 
                 MachineItemData = deep_copy(v) 
                 break;
             end 
         end 

        if not MachineItemData then 
            log.r("MachineItemData ,not data "..newCity)
        
             --有bug 
         else 
             local version = MachineDownloadManager.read_machine_local_version(MachineItemData.machine_id)
             if version ~= nil  then --也有可能正在下载
                 if  version >= MachineItemData.version then --已下载 
                    --TODO by LwangZg 运行时热更部分
                    if resMgr then
                        resMgr:RefreshModuleInfo(MachineItemData.name)
                    end
                     loadDefault = 2 
                 else 
                     if MachineDownloadManager.is_machine_downloading(MachineItemData.machine_id) then 
                         loadDefault =1 --下载中
                     else 
                        loadDefault = 0 
                     end 
                 end 
             else 
                 log.r("  error   error  error  error  error  error status not Download ")
             end 
         end 
     end 

     return loadDefault ,MachineItemData
end

function CityHomeScene:isAddDowanload(go,MachineItemData,loadDefault)
    if not go or not MachineItemData or not loadDefault then 
        return 
    end 

    if this._DownloadCityUtility.isAlreayAdd(MachineItemData.machine_id) then 
        return 
    end 

    local downPname = "CityDownLoadEntity"
    local tmpab = AssetList[downPname]
    local data = {
        id = MachineItemData.machine_id,
        Featrueid= MachineItemData.featureId,
        loadType = loadDefault,
    }

    local downloadView = CityDownloadView:New(data);
    Cache.load_prefabs(tmpab,downPname,function(ret)
        if ret then
            local tmpgo = Cache.create(tmpab,downPname)
            downloadView:SkipLoadShow(tmpgo,true)    
            downloadView:SetParent(go)
            downloadView:on_btn_item_click()
            this._DownloadCityUtility.AddEntity(downloadView) 
        end
    end)
end

function CityHomeScene:SetNormalLobby()

end

function CityHomeScene:SetAutoLobby()

end

function CityHomeScene:SelectCityExit()
    Facade.SendNotification(NotifyName.HideUI,ViewList.HallCityView)
    Facade.SendNotification(NotifyName.HideUI,ViewList.HallCityBannerView)
end

function CityHomeScene:NormalLobbyExit()
    local cityMode = ModelList.CityModel:GetEnterGameMode()

    --if cityMode == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        ModelList.CityModel.C2S_ChangeCity(0)
    --end
    ModelList.CityModel.RecordLastPlayId() --记录下之前玩法id,为Winzone使用
    ModelList.CityModel.SetPlayId(nil)
    Facade.SendNotification(NotifyName.HideUI,hallView or ViewList.HallMainView)
end

function CityHomeScene:AutoLobbyExit()
    Facade.SendNotification(NotifyName.HideUI,GetCurHallView())
end

function CityHomeScene:OnHomeSceneViewPromotion()
    homeSceneEntityView:GetCurState():Promotion(homeSceneEntityView)
end

function CityHomeScene.OnGoBackSelectCity(exitType)
    ModelList.CheckExitModular()
    homeSceneEntityView:GetCurState():Change2SelectCity(homeSceneEntityView)
    this.cityIconScrollView:CheckCompleteOnGoBackSelectCity(exitType)
end

function CityHomeScene.ShowOrHideCityEntity(isActive)
    homeSceneEntityView:GetCurState():ShowOrHideCityEntity(homeSceneEntityView,isActive)
end

function CityHomeScene:OnShowOrHideCityEntity(isActive)
    if currentCity and cityEntityCach[currentCity] then
        cityEntityCach[currentCity]:SetActive(isActive)
    end
end

function CityHomeScene:OnSelectCityPromotion()
    self._fsm:GetCurState():EnterHallCity(self._fsm,CityDragStiffParams.selectCityPromotion)
end

function CityHomeScene:DoSelectCityPromotion()
    Facade.SendNotification(NotifyName.HallCity.ShowCityMainView,ViewList.HallCityView,function()

    end,true,PopupOrderOccasion.none)
end

function CityHomeScene:OnNormalLobbyPromotion()
    Facade.SendNotification(NotifyName.HallCity.ShowHallMainView,GetCurHallView(),function()
    end,true,PopupOrderOccasion.none)
end

function CityHomeScene:OnAutoLobbyPromotion()
    --Facade.SendNotification(NotifyName.HallCity.ShowAutoHallView,GetCurHallView(),function()
    --end,true,PopupOrderOccasion.none)
end

function CityHomeScene:OnChange2SelectCity(previous,force)
    self:SetCity(true)
    if previous == nil or force then
        if lobbyEntity then
            lobbyEntity:DestroyLobby()
            lobbyEntity = nil
        end
        local occasion = PopupOrderOccasion.login
        if previous then
            occasion = PopupOrderOccasion.enterMainCity
        end
        Facade.SendNotification(NotifyName.HallCity.ShowCityMainView, ViewList.HallCityView, function()

        end, true, occasion)
        --if ModelList.GuideModel:IsGuideMainView() then
        --    log.r("IsGuideMainView")
        --    LuaTimer:SetDelayFunction(0.3,function()
        --        this.OnBtnBingoClick()
        --        log.r("OnBtnBingoClick")
        --    end)
        --end
    else
        self._fsm:GetCurState():EnterHallCity(self._fsm,CityDragStiffParams.change2SelectCity,previous,force)
    end
end

function CityHomeScene:DoChange2SelectCity(previous,force)
    if lobbyEntity then
        lobbyEntity:DestroyLobby()
        lobbyEntity = nil
    end
    --cityEntityCach[currentCity]:PlayExitLobby(function()
        local occasion = PopupOrderOccasion.login
        if previous then
            occasion = PopupOrderOccasion.enterMainCity
        end
        --Event.Brocast(EventName.Event_TaskTipUpdate)
        Facade.SendNotification(NotifyName.HallCity.ShowCityMainView, ViewList.HallCityView, function()

        end, true, occasion)
        --if ModelList.GuideModel:IsGuideMainView() then
        --    log.r("IsGuideMainView")
        --    LuaTimer:SetDelayFunction(0.3,function()
        --        this:SetCity(true)
        --        this.OnBtnBingoClick()
        --        log.r("OnBtnBingoClick")
        --    end)
        --end
    --end)
end

--function CityHomeScene.OnClick_City_Enter(is2MaxCity,cityId,playId)
function CityHomeScene.OnClick_City_Enter(is2MaxCity,playId)
    ModelList.CityModel.SetPlayId(playId)
    
    --currentCity = cityId
    if this:IsSelectCity() then
        local loadDefault,MachineItemData = CityHomeScene:CheckNeedDownload(currentCity)
        --local isCityType = true 
        --if playId then 
        --    local playData =  Csv.GetData("city_play",playId)
        --    if playData.play_type ~= 1 or playData.play_type ~= 2 then 
        --        isCityType = false 
        --    end 
        --end

        --编辑器模式下load新城市脚本
        --if GameUtil.is_windows_editor() then
            local playID = ModelList.CityModel.GetPlayIdByCity()
            if playID and playID >= 10 then
                ModelList.BattleModel.RequireModuleLua("Play"..playID)
            end
        --end
        
        if loadDefault ==0 and isCityType == true then 
            local playerLevel = ModelList.PlayerInfoModel:GetLevel()
            --推荐玩法得也一定是开放得  --false 才是开启
            local mayopen = Csv.GetCityLevelOpen2(currentCity,playerLevel)
            if mayopen then 
                CityHomeScene:EntityViewDownload(cityEntityCach[currentCity].go,MachineItemData,loadDefault)
            end 
            return;
        end 

        this._fsm:GetCurState():AutoDragCity(this._fsm,is2MaxCity,playId)
    end
end

function CityHomeScene:OnAutoDragCity(is2MaxCity,playId)
    if is2MaxCity then
        --[[
        local gotoCity = cityId or ModelList.CityModel:GetMaxCity()
        AutoDragCity:New():Start(gotoCity,function()
            this._fsm:GetCurState():OnBtnBingoClick(this._fsm,is2MaxCity,gotoCity,playId)
        end)
        --]]
    else
        --local gotoCity = cityId or ModelList.CityModel:GetCity()
        playId = playId or 1
        this._fsm:GetCurState():OnBtnBingoClick(this._fsm,is2MaxCity,playId)
    end
end



function CityHomeScene:OnBtnBingoClick(is2MaxCity,playId)
    if drag_state == LuaEasyTouchDragState.enddrag then
        if this:IsSelectCity() then
            --local cityType = Csv.GetData("city",cityId,"city_type")
            local playerLevel = ModelList.PlayerInfoModel:GetLevel()
            --推荐玩法得也一定是开放得  --false 才是开启
            local mayopen = true -- Csv.GetPlayIdLevelOpen(playId,playerLevel)--ModelList.CityModel:GetMaxCity()
            
            --if not playId and cityId then 
            --    mayopen = (Csv.GetCityLevelOpen2(cityId,playerLevel) == true  and {false} or {true} )[1]
            --else 
            --    mayopen = Csv.GetPlayIdLevelOpen(playId,playerLevel)
            --end 

            --如果是推荐玩法不同得处理
            --local recommdIdOf = ModelList.CityModel:GetRecommendid()
            --local recommdData =  Csv.GetData("feature_enter",recommdIdOf)
            --if recommdData ~= nil and playId == recommdData.city_play then 
            --    mayopen = false 
            --end 

            local isOpen = (PLAY_TYPE.PLAY_TYPE_AUTO_TICKET == cityType and {ModelList.PlayerInfoModel:IsAutoLobbyOpen()} or {mayopen ==false})[1]
            if mayopen then
                --ModelList.CityModel.C2S_ChangeCity(cityId)
                ModelList.CityModel.SetPlayId(playId)
                local forceMaxBet = ModelList.CityModel:IsForceMaxBet()
                local change2MaxBet = ModelList.UltraBetModel:NeedChange2MaxBet(playId)
                ModelList.CityModel:SetUsedBetRate()--要先设置城市和playid再设置倍率，要不出bug
                --if forceMaxBet or change2MaxBet then
                --    ModelList.CityModel:SetUsedBetRate(ModelList.CityModel:GetMaxRateOpen(cityId), cityId)--要先设置城市和playid再设置倍率，要不出bug
                --else
                --    ModelList.CityModel:SetBetRate(ModelList.CityModel:GetMaxRateOpen(cityId),cityId,true)--要先设置城市和playid再设置倍率，要不出bug
                --end
                homeSceneEntityView:GetCurState():Change2NormalLobby(homeSceneEntityView)
                ModelList.CityModel:ClearForceMaxBet()
                ModelList.UltraBetModel:RecordChange2MaxBet(playId)
            else
                UIUtil.show_common_popup(8017,true)
                self._fsm:GetCurState():Finish(self._fsm)
            end
        end
    else
        self._fsm:GetCurState():Finish(self._fsm)
    end
end

function CityHomeScene:OnChange2NormalLobby(anima)
    self:SetEnterHallFromBattle(not anima)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local sceneId = ModelList.CityModel.GetCity()
    if playId > 1 then sceneId = 0 end  --此处先强制校正
    --local atlasName = string.format("LobbyPlay%sEntityAtlas",playId)
    local key = string.format("%s%s", sceneId, playId)
    local pName = string.format("HallBackground%s",key)
    log.log("机台资源引用 " , sceneId , " " , playId , "  " , pName)
    Cache.load_prefabs(AssetList[pName],pName,function(ret)
        if ret then
            --cityEntityCach[currentCity]:PlayEnterLobby(function()
            local lobby_go = Cache.create(AssetList[pName],pName)
            local lobby_anchor = fun.GameObject_find("CanvasScene1/GameScene/MainCityScene/lobby_anchor")
            if not lobby_anchor then
                lobby_anchor = self.lobby_anchor
            end
            fun.set_parent(lobby_go,lobby_anchor,false)
            lobbyEntity = require(string.format("Scene/LobbyEntityView/LobbyEntityView%s",key))
            lobbyEntity:SkipLoadShow(lobby_go)
            lobbyEntity:PlayEnterLobby(function()
                hallView = require(string.format("View/HallCity/HallView/HallView%s",key)) or ViewList.HallMainView
                Facade.SendNotification(NotifyName.HallCity.ShowHallMainView,hallView,function()
                end,true,PopupOrderOccasion.enterNormalHall)
            end)
            --end)
        else
            log.log("错误 资源丢失 场景问题变化 ")
        end
    end)
end

--[[
function CityHomeScene.OnClick_Auto_Enter()
    if drag_state == LuaEasyTouchDragState.enddrag and this:IsSelectCity() then
        this._fsm:GetCurState():OnBtnAutoClick(this._fsm)
    end
end

function CityHomeScene.OnBtnAutoClick()
    if ModelList.PlayerInfoModel:IsAutoLobbyOpen() then
        homeSceneEntityView:GetCurState():Change2AutoLobby(homeSceneEntityView)
    else
        UIUtil.show_common_popup(8016,true)
        UISound.play("button_invalid")
    end
end

function CityHomeScene:OnChange2AutoLobby()
    local pName = "autobackground"
    local ab = AssetList[pName]
    Cache.load_prefabs(ab,pName,function(ret)
        if ret then
            local lobby_go = Cache.create(ab,pName)
            fun.set_parent(lobby_go,self.lobby_anchor,false)
            lobbyEntity:SkipLoadShow(lobby_go)
            
            Facade.SendNotification(NotifyName.HallCity.ShowAutoHallView,GetCurHallView(),function()
                --Facade.SendNotification(NotifyName.HideUI,this)
            end,true,PopupOrderOccasion.enterAutoHall)
        end
    end)
end
--]]

function CityHomeScene:EntityViewDownload(go,MachineItemData,loadDefault)

    if not go then 
        log.r("error not go ")
        return
    end 

    self:isAddDowanload(go,MachineItemData,loadDefault)
   
end

function CityHomeScene:CanDragCity()
    if self._fsm then
        return self._fsm:GetCurState():CanDragCity()
    end
    return false
end

function CityHomeScene.OnTurnCityLeft()
    ModelList.ApplicationGuideModel:UnloadGuide("HallCityView")
    this._fsm:GetCurState():OnTurnCityLeft(this._fsm)
end

function CityHomeScene:OnTurnCityLeftState()
    this.deltaPosition = Vector2.New(0,0)
    if fun.is_null(this.hang_point) then
        this._dragPosX = this.hang_point.transform.localPosition.x
    end
    local camera = ProcedureManager:GetCamera()
    local obj = Util.RayCollideGameObject(Vector2.New(UnityEngine.Screen.width / 2,UnityEngine.Screen.height / 2),camera,nil)
    if obj == this.city01 then
        this.currenCity = this.city01
        this.nextCity = this.city02
    elseif obj == this.city02 then
        this.currenCity = this.city02
        this.nextCity = this.city01
    end
    this:OnDragRight()
    this:OnDragRightEnd()
    ModelList.ApplicationGuideModel:LoadGuide("HallCityView")
end

function CityHomeScene.OnTurnCityRight()
    ModelList.ApplicationGuideModel:UnloadGuide("HallCityView")
    this._fsm:GetCurState():OnTurnCityRight(this._fsm)
end   

function CityHomeScene:OnTurnCityRightState()
    this.deltaPosition = Vector2.New(0,0)
    if fun.is_null(this.hang_point) then
        this._dragPosX = this.hang_point.transform.localPosition.x
    end
    local camera = ProcedureManager:GetCamera()
    local obj = Util.RayCollideGameObject(Vector2.New(UnityEngine.Screen.width / 2,UnityEngine.Screen.height / 2),camera,nil)
    if obj == this.city01 then
        this.currenCity = this.city01
        this.nextCity = this.city02
    elseif obj == this.city02 then
        this.currenCity = this.city02
        this.nextCity = this.city01
    end
    if obj then
        this:OnDragLeft()
        this:OnDragLeftEnd()
    end
    ModelList.ApplicationGuideModel:LoadGuide("HallCityView")
end

function CityHomeScene.OnTurnCityLeftCross()
    this._fsm:GetCurState():OnTurnCityLeft(this._fsm,1)
end

function CityHomeScene:OnTurnCityLeftCrossState()
    local callback = function(obj)
        this.deltaPosition = Vector2.New(0,0)
        if fun.is_not_null(this.hang_point) then
            this._dragPosX = this.hang_point.transform.localPosition.x
        end
        if obj then
            this:SetCityEntityDragRight()
            this:OnDragRightCrossEnd()
        end
    end

    local camera = ProcedureManager:GetCamera()
    local obj = Util.RayCollideGameObject(Vector2.New(UnityEngine.Screen.width / 2,UnityEngine.Screen.height / 2),camera,nil)
    if obj == this.city01 then
        this.currenCity = this.city01
        this.nextCity = this.city02
    elseif obj == this.city02 then
        this.currenCity = this.city02
        this.nextCity = this.city01
    end

    if cityEntityCach[currentCity + 1] then
        cityEntityCach[currentCity + 1]:SetActive(false)
    end
    local maxCity = ModelList.CityModel:GetMaxCity()
    if cityEntityCach[maxCity] then
        cityEntityCach[maxCity]:SetParent(this.nextCity)
        cityEntityCach[maxCity]:SetActive(true)
        callback(obj)
    else
        self:ChangeCity(this.nextCity,nil,maxCity,function()
            callback(obj)
        end,true)    
    end
end

function CityHomeScene.OnTurnCityRightCross()
    this._fsm:GetCurState():OnTurnCityRight(this._fsm,1)
end 

function CityHomeScene:OnTurnCityRightCrossState()
    local callback = function(obj)
        this.deltaPosition = Vector2.New(0,0)
        if fun.is_not_null(this.hang_point) then
            this._dragPosX = this.hang_point.transform.localPosition.x
        end
        if obj then
            this:SetCityEntityDragLeft()
            this:OnDragLeftCrossEnd()
        end
    end

    local camera = ProcedureManager:GetCamera()
    local obj = Util.RayCollideGameObject(Vector2.New(UnityEngine.Screen.width / 2,UnityEngine.Screen.height / 2),camera,nil)
    if obj == this.city01 then
        this.currenCity = this.city01
        this.nextCity = this.city02
    elseif obj == this.city02 then
        this.currenCity = this.city02
        this.nextCity = this.city01
    end

    if cityEntityCach[currentCity + 1] then
        cityEntityCach[currentCity + 1]:SetActive(false)
    end
    local maxCity = ModelList.CityModel:GetMaxCity()
    if cityEntityCach[maxCity] then
        cityEntityCach[maxCity]:SetParent(this.nextCity)
        cityEntityCach[maxCity]:SetActive(true)
        callback(obj)
    else
        self:ChangeCity(this.nextCity,nil,maxCity,function()
            callback(obj)
        end,true)    
    end
end

function CityHomeScene:Turn2MaxOpenCity(city)
    local maxCity = city or ModelList.CityModel:GetMaxCity()
    local curCity = ModelList.CityModel:GetCity()
    local subVlaue = maxCity - curCity
    if 1 == subVlaue then
        self:OnTurnCityRight()
    elseif -1 == subVlaue then
        self:OnTurnCityLeft()
    elseif 0 == subVlaue then
 
    elseif subVlaue > 1 then
        self:OnTurnCityRightCross()
    elseif subVlaue < 1 then
        self:OnTurnCityLeftCross()
    end
end

function CityHomeScene:CanClickIcon()
    if self and self._fsm and self._fsm:GetCurState() then
        return self._fsm:GetCurState():CanClickIcon()
    end
    return true
end

function CityHomeScene:CheckEnterHallFromBattle()
    if isEnterHallFromUI and not isEnterHallFromBattle then
        return true
    end
    return isEnterHallFromBattle or false    
end

function CityHomeScene:SetEnterHallFromBattle(enterHallFromBattle)
    isEnterHallFromBattle = enterHallFromBattle
    if enterHallFromBattle then
        isEnterHallFromUI = false
    end
end

function CityHomeScene:SetEnterHallFromUI(enterFromUI)
    isEnterHallFromUI = enterFromUI
end

function CityHomeScene:Change2NormalLobby()
    homeSceneEntityView:GetCurState():Change2NormalLobby(homeSceneEntityView)
end

function CityHomeScene:InitLobbyCityIcon()
    if self.cityIconScrollView then
    else
        local view = require("View/CommonView/CityIconScroll")
        self.cityIconScrollView = view:New(self.cityScrollView, self.cityItem)
        self.cityIconScrollView:OnEnable()
    end
end


this.NotifyList = {
    {notifyName = NotifyName.SceneCity.Click_City_Enter, func = this.OnClick_City_Enter},
    --{notifyName = NotifyName.SceneCity.Click_auto_Enter, func = this.OnClick_Auto_Enter},
    {notifyName = NotifyName.SceneCity.Goback_select_city, func = this.OnGoBackSelectCity},
    {notifyName = NotifyName.SceneCity.HomeScene_promotion, func = this.OnHomeSceneViewPromotion},
    {notifyName = NotifyName.SceneCity.DragCityLeft, func = this.OnTurnCityLeft},
    {notifyName = NotifyName.SceneCity.DragCityRight, func = this.OnTurnCityRight},
    {notifyName = NotifyName.SceneCity.cityEntity_Show_Hide, func = this.ShowOrHideCityEntity},
}

return this
