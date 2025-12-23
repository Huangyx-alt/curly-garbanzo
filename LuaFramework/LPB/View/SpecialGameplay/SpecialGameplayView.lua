SpecialGameplayView =BaseView:New("SpecialGameplayView")

local this = SpecialGameplayView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local ItemEntityCache = {}
local windowView = nil
this.auto_bind_ui_items = {
    "Recommend",
    "ItemList",
    "Item",
    "btn_exit",
    "anim",
    "btn_Bg",
    "RecommendParent",
    "Content",
    "guide_anim",
    "ScrollView"
}

this.itemPre = {

}

function SpecialGameplayView:Awake()
    self:on_init()

    local startTime = os.time()
    self.ScrollView.onValueChanged:AddListener(function(val)
        --1秒等待后可以关闭引导
        if os.time() - startTime > 1 then
            if fun.is_not_null(val) and val.y ~= 1 then
                --log.r("onValueChanged:" .. val.y)
                fun.set_active(self.guide_anim, false)
            end
        end
    end)
end

function SpecialGameplayView:OnEnable(params)
    self.params = params or {}
    self.anim:Play("start")
    this.update_x_enabled = true
    Facade.RegisterView(this)
    this:initData()


    if  Network.isConnect == false then
        UIUtil.show_common_popup(977,true,nil)
    end

    self:CheckOpenFullGamePlayGuide()
    self.ScrollView.content.anchoredPosition = Vector2.zero
end

function SpecialGameplayView:OnDisable()
    self.params = {}
    
    Facade.RemoveView(this)
    for _, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    if  this.recommenr then 
        this.recommenr:OnDestroy()
        this.recommenr = nil
    end 
    ItemEntityCache ={}
    if windowView then
        Facade.SendNotification(NotifyName.HideDialog, windowView)
    end

    this.update_x_enabled = false;
    this:stop_x_update()
end

function SpecialGameplayView:OnDestroy()
    self:Close()
    Facade.RemoveView(this)
    for _, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    if  this.recommenr then 
        this.recommenr:Close()
    end 
    this.update_x_enabled = false;
    this:stop_x_update()

    ItemEntityCache ={}
    if windowView then
        Facade.SendNotification(NotifyName.HideDialog, windowView)
    end
    AssetManager.unload_ab({AssetList.SpecialGameplayView})
end

function SpecialGameplayView:onHide()
    if self.params and self.params.OnClose then
        self.params.OnClose()
    end
end

--初始化数据
function SpecialGameplayView:initData()

    local Macheindata = deep_copy( MachinePortalManager.get_portal_data_by_machine())
    ---每次增加新玩法都需要添加
    local tb ={
        [1] = {   --鸡尾酒
            lock = false ,
            downtye = 2,
            id = 1 ,
            moduleId = 1,
            version = 0,
        },
        [2] = {   --圣诞
            lock = false ,
            downtye = 2,
            id = 2,
            moduleId = 2,
            version = 0,
        },
        [3] = {   --绿头人
            lock = false ,
            downtye = 2,
            id = 3,
            moduleId = 3,
            version = 0,
        },
        [4] = {   --狼人
            lock = false ,
            downtye = 2,
            id = 4,
            moduleId = 4,
            commyType = false,
            version = 0,
        },
        [5] = {
            lock = true ,
            downtye = 0,
            id = 5,
            moduleId = 5 ,
            commyType = true,
            version = 0,
        },
        [6] = { --宝石玩法
            lock = false ,
            downtye = 2,
            id = 6,
            moduleId = 9,
            commyType = false,
            version = 0,
        },
        [7] = { --糖果玩法
            lock = false ,
            downtye = 2,
            id = 7,
            moduleId = 10,
            commyType = false,
            version = 0,
        },
        [8] = { --新圣诞玩法
            lock = false ,
            downtye = 2,
            id = 8,
            moduleId = 13,
            commyType = false,
            version = 0,
        },
        [9] = { --金猪玩法
            lock = false ,
            downtye = 2,
            id = 9,
            moduleId = 15,
            commyType = false,
            version = 0,
        },
        [10] = { --中国龙玩法
            lock = false ,
            downtye = 2,
            id = 10,
            moduleId = 16,
            commyType = false,
            version = 0,
        },
        [11] = { --新绿头人寻路玩法
            lock = false ,
            downtye = 2,
            id = 11,
            moduleId = 17,
            commyType = false,
            version = 0,
        },
        [12] = { --新绿头人寻路玩法
            lock = false ,
            downtye = 2,
            id = 12,
            moduleId = 18,
            commyType = false,
            version = 0,
        },
        [13] = { --火山玩法
            lock = false ,
            downtye = 2,
            id = 13,
            moduleId = 19,
            commyType = false,
            version = 0,
        },
        [14] = { --海盗船玩法
            lock = false ,
            downtye = 2,
            id = 14,
            moduleId = 20,
            commyType = false,
            version = 0,
        },       
        [15] = { --猫咪大盗玩法
            lock = false ,
            downtye = 2,
            id = 15,
            moduleId = 21,
            commyType = false,
            version = 0,
        },

        [16] = { --鼹鼠矿工玩法
            lock = false ,
            downtye = 2,
            id = 16,
            moduleId = 23,
            commyType = false,
            version = 0,
        },
        [17] = { --鼹鼠矿工玩法
            lock = false ,
            downtye = 2,
            id = 17,
            moduleId = 24,
            commyType = false,
            version = 0,
        },
        [18] = { --赛马玩法
            lock = false ,
            downtye = 2,
            id = 18,
            moduleId = 25,
            commyType = false,
            version = 0,
        },
        [19] = { --刮刮卡玩法
            lock = false ,
            downtye = 2,
            id = 19,
            moduleId = 26,
            commyType = false,
            version = 0,
        },
        [20] = { --金币火车
            lock = false ,
            downtye = 2,
            id = 20,
            moduleId = 27,
            commyType = false,
            version = 0,
        },
        [21] = { --圣诞合成
            lock = false ,
            downtye = 2,
            id = 21,
            moduleId = 28,
            commyType = false,
            version = 0,
        },
        [22] = { --
            lock = false ,
            downtye = 2,
            id = 22,
            moduleId = 32,
            commyType = false,
            version = 0,
        },
        [23] = { --
            lock = false ,
            downtye = 2,
            id = 23,
            moduleId = 30,
            commyType = false,
            version = 0,
        },
        [24] = { --
            lock = false ,
            downtye = 2,
            id = 24,
            moduleId = 31,
            commyType = false,
            version = 0,
        },
        [25] = { --
            lock = false ,
            downtye = 2,
            id = 25,
            moduleId = 32,
            commyType = false,
            version = 0,
        },
    } --合规数据

    fun.set_active(self.Recommend,false)
    --and fun.IsEditor() == false


    if Macheindata and type(Macheindata) == "table"  then 
        ---这里插入正规得数据
        for _,v in pairs(Macheindata) do
            for _,v2 in pairs(tb) do
               
                if v2.id == v.featureId and v.moduleType == modular_type.playType then -- 如果是这个id 判断是否下载
                    --判断需要下载
                    local version = MachineDownloadManager.read_machine_local_version(v.machine_id)
                 
                    if version ~= nil  then --也有可能正在下载
                        if  version >= v.version then --已下载
                            if resMgr and v.name then
                                --TODO by LwangZg 运行时热更部分
                                resMgr:RefreshModuleInfo(v.name)
                            elseif LuaHelper.GetResManager() and v.name then
                                LuaHelper.GetResManager():RefreshModuleInfo(v.name)
                            end
                            v2.downtye =2
                        
                        else 
                            if  MachineDownloadManager.is_machine_downloading(v.machine_id) then 
                           
                                v2.downtye =1
                            else 
                             
                                v2.downtye =0 
                            end 
                        end 

                        v2.version =  v.version
                    else 
                        log.r("  error   error  error  error  error  error status not Download ")
                        v2.downtye =0
                    end 
                end 
            end 
        end
    end 
  
    local count = 0
    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    local tmpTable = {}
    self:ClearMailList()

    local isOpen = ModelList.CityModel:IsFullGameplayOpen()
    local isValid = ModelList.CityModel:GetFullGameplayRemainTime() > 0
    if isValid then
        tmpTable = self:GetServerEntrance(tb)
        --[[
        --强制关闭全机台开放
        tmpTable = self:GetCfgEntrance(tb)
        --]]
    else
        if isOpen then
            tmpTable = self:GetCfgEntrance(tb)
        else
            local ServerData = ModelList.CityModel:GetRecommendBanners()
            local limitLevel = Csv.GetData("control", 157, "content")[1][1] or 2
            if not ServerData or #ServerData <=2 or playerLevel < limitLevel then
                tmpTable = self:GetCfgEntrance(tb)
            else
                tmpTable = self:GetServerEntrance(tb)
            end
        end
    end

    --[[
    --强制关闭全机台开放
    tmpTable = self:GetCfgEntrance(tb)
    --]]

    local recommdIdOf = ModelList.CityModel:GetRecommendid()
    for _,v in ipairs(tmpTable) do
        local featureData = Csv.GetData("feature_enter",v.id)
        if featureData ~= nil then
            --判断倍数，是否要上锁
            local lockState = Csv.GetPlayIdLevelOpen(featureData.city_play,playerLevel)
            v.lock = lockState

            --主推玩法不受控制
            if recommdIdOf ~= nil and v.id == recommdIdOf then
                v.lock = false
            end

            --判断是否已经下载了
            count = count +1
            local view =  this:GetItemViewInstance(count)
            if view then
                view:UpdateData(v)
            end
        end
    end
end

--取配置表配置机台
function SpecialGameplayView:GetCfgEntrance(tb)
    local tmpTable = {}
    for i =1,#tb do
        --确保数据存在
        local featureData = Csv.GetData("feature_enter",tb[i].id)
        if featureData ~= nil and featureData.featured_banner >0 then
            table.insert(tmpTable,tb[i])
        end
    end
    table.sort(tmpTable,function(a,b)
        local featureDataA = Csv.GetData("feature_enter",a.id)
        local featureDataB = Csv.GetData("feature_enter",b.id)
        return featureDataA.featured_banner > featureDataB.featured_banner
    end)
    return tmpTable
end 

--取后台配置机台
function SpecialGameplayView:GetServerEntrance(tb)
    local tmpTable = {}
    local ServerData = ModelList.CityModel:GetRecommendBanners()
    for k,v in ipairs(ServerData) do
        --确保数据存在
        for i =1,#tb do
            --确保数据存在
            if tb[i].id == v then
                table.insert(tmpTable,tb[i])
                break
            end
        end
    end
    return tmpTable
end

function SpecialGameplayView:GetItemViewInstance(index)
    local view = require "View/SpecialGameplay/SGPRecommend"
    local view_instance = nil
    
    if ItemEntityCache[index] == nil then
        --local items = fun.find_child(self.ItemList,"item"..math.ceil(index/2))
        local item = fun.get_instance(self.Recommend,self.Content)
        view_instance = view:New(self)
        view_instance:SkipLoadShow(item)
        ItemEntityCache[index] = view_instance
    else
        view_instance = ItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)

    return view_instance
end 

function SpecialGameplayView:ClearMailList()
    
	for i, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache ={}
end

function SpecialGameplayView:on_btn_exit_click()
    this:OnBtnExit()
end 

function SpecialGameplayView:on_btn_Bg_click()
    this:OnBtnExit()
end

function SpecialGameplayView:Promote(params)
    if self.go then 
      
        fun.set_active(self.go,true)
    else 
   
        ViewList.SpecialGameplayView.isShow = false 
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayView,nil,nil,nil)
    end 

    if params then

    end
end

function SpecialGameplayView:OnBtnExit()
    AnimatorPlayHelper.SetAnimationEvent(self.anim,"SpecialGameplayView_end",function()
        local openByFullGameplayPoster = self.params and self.params.OpenByFullGameplayPoster
        Facade.SendNotification(NotifyName.HideUI,ViewList.SpecialGameplayView)

        local pId = ModelList.CityModel:GetRecommendPop()
        local featureData = Csv.GetData("feature_enter",pId)
        if not pId or not featureData then 
            pId = Csv.getSGPPop()
        end

        if not openByFullGameplayPoster then
            if ModelList.CityModel.haveisTraSGP()then
                ModelList.CityModel.setTrasSgp()
                Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayEnter,nil,nil,pId)
            end
        end
    end)
    self.anim:Play("end") 
end

function SpecialGameplayView:CloseSelf()
    Facade.SendNotification(NotifyName.HideUI,ViewList.SpecialGameplayView)
end

function SpecialGameplayView:CheckOpenFullGamePlayGuide()
    local actEndTime = ModelList.CityModel:GetFullGameplayEndTime()
    if actEndTime then
        local key = "FullGamePlayGuide-"..actEndTime
        local temp = fun.read_int_by_userid(key, 0)
        if temp == 0 then
            fun.save_int_by_userid(key, 1)
            fun.set_active(self.guide_anim, true)
        end
    end
end

function SpecialGameplayView:CheckGuidAnimOpen()
    local state = fun.get_active_self(self.guide_anim)
    return state
end

function SpecialGameplayView:SetGuidAnimState(state)
    fun.set_active(self.guide_anim, state)
end

-----------------------------------下载更新
---

function SpecialGameplayView.OnEventUpdate(id,progress,size)
    if not ViewList.SpecialGameplayView.go or not fun.get_active_self(ViewList.SpecialGameplayView.go) then 
        return 
    end 

    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id then 
            v:OnEventUpdate(id,progress,size)
        end 
	end

    if this.recommenr  then
        local data = this.recommenr:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id then 
            this.recommenr:OnEventUpdate(id,progress,size)
        end 
    end 

end

function SpecialGameplayView.OnEventSuccess(id)
    if not ViewList.SpecialGameplayView.go or not fun.get_active_self(ViewList.SpecialGameplayView.go) then 
        return 
    end 

    ModelList.CityModel.SetDownloadList(id,false)
    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            v:OnEventSuccess(id)
        end 
	end

    if this.recommenr  then
        local data = this.recommenr:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            this.recommenr:OnEventSuccess(id)
        end 
    end 

    this.update_x_enabled = false;
    this:stop_x_update()
end

function SpecialGameplayView.OnEventStart(id)

    if not ViewList.SpecialGameplayView.go or not fun.get_active_self(ViewList.SpecialGameplayView.go) then 
        return 
    end 
    ModelList.CityModel.setTrasSgp()   --已经开始下载就不弹出第二个界面
    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            v:OnEventStart(id)
        end 
	end

    if this.recommenr  then
        local data = this.recommenr:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id then 
            this.recommenr:OnEventStart(id)
        end 
    end 
    this:start_x_update()
end 

function SpecialGameplayView.OnEventError(id)

    if not ViewList.SpecialGameplayView.go or not fun.get_active_self(ViewList.SpecialGameplayView.go) then 
        return 
    end 

    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            v:OnEventError(id)
        end 
	end

    if this.recommenr  then
        local data = this.recommenr:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            this.recommenr:OnEventError(id)
        end 
    end 

    --下载出现错误弹出提示框 
    --判断下网络状态，如果网络状态不好

    log.g(" SpecialGameplayView.OnEventError ")

    if  Network.isConnect == false then 
        if not windowView then
            windowView =  UIUtil.show_common_popup(977,true,nil)
        else 
           -- Facade.SendNotification(NotifyName.ShowDialog, windowView)
        end
    else 
        if not windowView then
            windowView =  UIUtil.show_common_popup(978,true,nil)
        else 
          --  Facade.SendNotification(NotifyName.ShowDialog, windowView)
        end 
    end     

    this.update_x_enabled = false;
    this:stop_x_update()
end 

function SpecialGameplayView.OnEventStop(id)
    if not fun.get_active_self(this.go) then 
        return 
    end 

    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id  then 
            v:OnEventStop(id)
        end 
	end

    if this.recommenr  then
        local data = this.recommenr:getSelfData()
        local tmpData = Csv.GetData("feature_enter", data.id )
        if data ~= nil and tmpData.modular_id ==id   then 
            this.recommenr:OnEventStop(id)
        end 
    end 

    this.update_x_enabled = false;
    this:stop_x_update()
  
end

function SpecialGameplayView:on_x_update()
    if  Network.isConnect == false then 

        --在下载得都
        for _, v in pairs(ItemEntityCache) do
            v:GetIsLoadingStateAndChange() 
        end
    
        if this.recommenr  then 
            this.recommenr:GetIsLoadingStateAndChange()
        end 
        
        if not ViewList.SpecialGameplayView.go or not fun.get_active_self(ViewList.SpecialGameplayView.go) then 
            
            this.update_x_enabled = false;
            this:stop_x_update()
            return 
        end 

        if not windowView then
            windowView =  UIUtil.show_common_popup(977,true,function()
                this.update_x_enabled = false;
                this:stop_x_update()
            end)
        end
    end 
end



this.NotifyList ={
    {notifyName = NotifyName.SpecialGameplay.CloseSpecialGameplayView, func = this.CloseSelf},
    {notifyName = NotifyName.Event_machine_download_update, func = this.OnEventUpdate},
    {notifyName = NotifyName.Event_machine_download_success_view, func = this.OnEventSuccess},
    {notifyName = NotifyName.Event_machine_download_error, func = this.OnEventError},
    {notifyName = NotifyName.Event_machine_download_start, func = this.OnEventStart},
    {notifyName = NotifyName.Event_machine_download_stop, func = this.OnEventStop},
}

return this


