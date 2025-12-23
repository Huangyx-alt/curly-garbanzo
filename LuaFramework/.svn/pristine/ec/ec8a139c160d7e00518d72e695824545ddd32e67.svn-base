
local FunctionIconView = Clazz()
FunctionIconView.belong2Type = {hallmain = 1,normalbattle = 2,autobattle = 3}

local curFunctionView = nil
local FunctionIconScrollView = require "View/CommonView/FunctionIconScrollView"

local FunctionIconSaleView = require "View/CommonView/FunctionIconSaleView"



function FunctionIconView:New(belong,leftHangPoint,rightHangPoint,rightHangPoint2,centerleftPoint,bottomLeftPoint)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._belong = belong or 1
    o._leftHangPoint = leftHangPoint
    o._rightHangPoint = rightHangPoint

    o.funciconEntityCach = {}
    o.showFunctionIdCache = Queue:New()
    o.saleCodeList = {}
    fun.set_active(o._leftHangPoint, true)
    fun.set_active(o._rightHangPoint, true)
    return o
end

function FunctionIconView:InitConfig()
    self.iconConfig = {}
    for k, v in ipairs(Csv.new_function_icon) do
        self.iconConfig[v.component_name] =
        {
            prefab_name = v.prefab_name,
            location = v.location,
            weight = v.weight
        }
    end
end

function FunctionIconView:GetIconWight(component_name)
    return self.iconConfig[component_name].weight
end

function FunctionIconView:CreatIconControl()
    self.iconScrollLeft = FunctionIconScrollView:New(self,self._leftHangPoint , LOBBY_ICON_POSITION.LEFT)
    self.iconScrollRight = FunctionIconScrollView:New(self,self._rightHangPoint , LOBBY_ICON_POSITION.RIGHT)
end

function FunctionIconView:OnEnable()
    self:RegisterEvent()
    self:InitConfig()
    self:CreatIconControl()
    curFunctionView = self
    self:ShowIcon()
end

function FunctionIconView:OnDisable()
    self.showFunctionIdCache:reset()
    self:RemoveEvent()   
end

function FunctionIconView:OnHintTimeChange()
    self:CheckHintTime()
end

function FunctionIconView:OnCouponChange()
    self:CheckCoupon()
end

function FunctionIconView:OnChangeCity()
    self:OnCheckChangeCity()
end

function FunctionIconView:CheckChangeDouble()
    for key, value in pairs(self.funciconEntityCach) do
        local activityId = Csv.GetData("new_function_icon",value:GetFunctionId(),"activity_type")
        if activityId  and activityId >0 then
            if ModelList.ActivityModel:IsWaitingShowChangeDouble(activityId) then
                value:OnChangeDouble()
                ModelList.ActivityModel:HadShowChangeDouble(activityId)
            end
        end
    end
end

function FunctionIconView:CheckDoubleActivityChange(id,isOpen)
    for key, value in pairs(self.funciconEntityCach) do
        local activityId = Csv.GetData("new_function_icon",value:GetFunctionId(),"activity_type")
        if activityId  and activityId == id then
            if not isOpen then
                value:OnExitDouble()
                if activityId == ActivityTypes.doublePuzzle then
                    Event.Brocast(EventName.Event_Hide_BetRateOperatedView_Double_Flag,false)
                end
            else
                value:OnChangeDouble()
                ModelList.ActivityModel:HadShowChangeDouble(activityId)
            end
            break
        end
    end
end

function GetFunctionPosition(functionName)
    local func = nil
    if curFunctionView then
        func = curFunctionView:GetFunctionByName(functionName)
    end
    if func then
        return func:GetPosition()
    end
    return nil
end

function GetFunctionView(functionName)
    local func = nil
    if curFunctionView then
        func = curFunctionView:GetFunctionByName(functionName)
    end
    if func then
        return func:GetView()
    end
    return nil
end

function GetFunctionViewRef(functionName)
    local func = nil
    if curFunctionView then
        func = curFunctionView:GetFunctionByName(functionName)
    end
    if func then
        return func:GetRef()
    end
    return nil
end

function FunctionIconView:GetFunctionByName(name)
    if self.funciconEntityCach then
        for key, value in pairs(self.funciconEntityCach) do
            if value.fun_name == name  then
                return value
            end
        end
    end
    return nil
end

function FunctionIconView:ShowIcon()
    for index, value in ipairs(Csv.new_function_icon) do
        self:AddFunctionIcon(nil,value)
    end
end

function FunctionIconView:CheckHintTime()
    local funcData = Csv.new_function_icon
    local data = nil
    if funcData then
        for index, value in ipairs(funcData) do
            if value then
                data = value
                break
            end
        end
    end
    if data then
        self:AddFunctionIcon(nil,data)
    end
end

function FunctionIconView:CheckCoupon()
    local funcData = Csv.new_function_icon
    local data = nil
    if funcData then
        for index, value in ipairs(funcData) do
            if value then
                data = value
                break
            end
        end
    end
    if data then
        if self.funciconEntityCach[data.id] then
            if self.funciconEntityCach[data.id]:IsExpired() then
                self:RemoveFunctionIcon(data.id)
            else
                self.funciconEntityCach[data.id]:UpdataShow()
            end
        else
            if data then
                self:AddFunctionIcon(nil,data)
            end
        end
    end
end

function FunctionIconView:OnCheckChangeCity()
    local city = ModelList.CityModel:GetCity()
    local maxcity = ModelList.CityModel:GetMaxCity()
    local loadDefault ,_ = ModelList.CityModel.checkModuleDownload(city)
    for key, value in pairs(self.funciconEntityCach) do
        if value:GetFunctionSoleCity() == 1 then
            if not value.isShow then
                if city <= maxcity and loadDefault ==2  then
                    value:OnChangeCity(true,true)
                    value:Show()
                end
            else
                if city > maxcity or loadDefault ~= 2 then
                    value:OnChangeCity(false)
                else
                    value:OnChangeCity(true,true)
                end    
            end
        end
    end
end

function FunctionIconView:CheckCacheFunId()
    local cacheId = self.showFunctionIdCache:pop()
    if cacheId then
        self:AddFunctionIcon(cacheId)
    else
        log.log("结束添加 ")
        self:SetGiftIcon()
    end
end

function FunctionIconView:LoadFunctionIcon(data)
    if data then
        local checkNext = function()
            self.isLoading = false
            self:CheckCacheFunId()
        end
        log.log("dps 老版本 加载图标数据 " , data)
        --local compo = require(data.component_name)
        local success, compo = pcall(require, string.format("View/CommonView/%s",data.component_name))
        if not success then
            log.log("FunctionIconView:LoadFunctionIcon Error!!! ", data.component_name, "  " , string.format("View/CommonView/%s",data.component_name))
            checkNext()
            return
        end

   
        if not compo:IsFunctionOpen() then
            checkNext()
            return
        end
        if compo:IsExpired() then
            checkNext()
            return
        end


        self.isLoading = true

        local ab = AssetList[data.prefab_name] --"luaprefab_prefabs_city"


        Cache.load_prefabs(ab,data.prefab_name,function(ret)
            if ret and self.isLoading ~= nil then
                local go = fun.get_instance(ret) --Cache.create(ab,data.prefab_name)
                local funcentity = compo:New(data);
                funcentity:SetFunctionData(data)

                funcentity.fun_name = data.component_name
                self.funciconEntityCach[data.id] = funcentity

                funcentity:SkipLoadShow(go,true,nil,true)
                funcentity:IsFunctionOpenCity()
                funcentity:SetIconManager(self)
                local iconControl = self:GetIconControl(data.component_name)
                if iconControl then
                    iconControl:AddIcon(go, funcentity ,data.component_name,false)
                else
                    log.log("错误 缺少图标类型 " , data.component_name)
                end
            end
            checkNext()
        end)
    else
        log.log("活动图标加载结束")
    end
end

function FunctionIconView:GetIconControl(component_name)
    local iconPos = self:GetIconPosition(component_name)
    if not iconPos then
        return nil
    end
    log.log("dps 新版图标 获取位置  " , component_name , iconPos)
    local control = nil
    if iconPos == LOBBY_ICON_POSITION.LEFT then
        control = self.iconScrollLeft
    elseif iconPos == LOBBY_ICON_POSITION.RIGHT then
        control = self.iconScrollRight
    end
    return control
end

function FunctionIconView:GetIconPosition(component_name)
    if not self.iconConfig or not self.iconConfig[component_name] then
        log.r("错误 未知的图标类 " , component_name)
        return nil
    end
    return self.iconConfig[component_name].location
end

function FunctionIconView:AddFunctionIcon(id,data)
    log.log("dps 添加图标数据 " , id , data)
    local key = id or data.id
    local funcData = data or Csv.GetData("new_function_icon",key)
    if self.isLoading then
        self.showFunctionIdCache:push(key)
    else
        if self.funciconEntityCach[key] then
            if self.funciconEntityCach[key]:IsExpired() then
                self:RemoveFunctionIcon(key)
                return
            else
                if self.funciconEntityCach[key].go then
                    if not self.funciconEntityCach[key].isShow then
                        self.funciconEntityCach[key]:Show()
                    else
                        self.funciconEntityCach[key]:UpdataShow()
                    end
                    --要检查一下缓存列表里有没有待显示的id，要不可能会漏掉需要显示的图标
                    self:CheckCacheFunId()
                    return
                end
            end
        end
        if funcData then
            self:LoadFunctionIcon(funcData)
        end
    end
end

function FunctionIconView:RemoveFunctionIcon(id)
    if self.funciconEntityCach[id] then
        self.funciconEntityCach[id]:Close()
        self.funciconEntityCach[id] = nil
    end
end

function FunctionIconView:GetFunctionEntityById(id)
    if id then
        return self.funciconEntityCach[id]
    end
    return nil
end

function FunctionIconView:AddFunctionIconIfNotExist(params)
    log.log("dps 新版图标 外部添加 ", params)
    if params and params.componentName == "FunctionIconDiscountAllView" then
        log.log("老版本图标需要排除 FunctionIconDiscountAllView" )
        return
    end
    if not params or type(params) ~= "table" then
        log.log("FunctionIconView:AddFunctionIconIfNotExist(params) 参数有误", params)
        return
    end
    local funcData = Csv.new_function_icon
    local data = nil
    if funcData then
        for index, value in ipairs(funcData) do
            if value and value.component_name == params.componentName then
                data = value
                break
            end
        end
    end

    if data then
        if self.funciconEntityCach[data.id] then
            --self.funciconEntityCach[data.id]:UpdataShow()
        else
            self:AddFunctionIcon(nil, data)
        end
    end

    if params.callback then
        params.callback(self.funciconEntityCach[data.id])
    end
end

--生成礼包图标
function FunctionIconView:SetGiftIcon()
    local showData = ModelList.GiftPackModel:GetPackEnterViewDisplayData()
    log.log("展示的礼包数据 FunctionIconView" , showData)
    local ab = AssetList.FunctionIconSale --促销图标都有这个
    local curr = ModelList.PlayerInfoModel.get_cur_server_time()
    Cache.load_prefabs(ab,"FunctionIconSale",function(ret)
        if ret then
            for k, v in pairs(showData) do
                if v.isDisplay and v.expireTime > curr and not self.saleCodeList[v.name] and v.name ~= "565" then --屏蔽礼包
                    local go = fun.get_instance(ret)
                    local saleCode = FunctionIconSaleView:New(v);
                    saleCode:SkipLoadShow(go,true,nil,true)
                    saleCode:IsFunctionOpenCity()
                    saleCode:SetIconManager(self)
                    self.iconScrollRight:AddIcon(go, saleCode ,v.name, true)
                    self.saleCodeList[v.name] = saleCode
                end
            end
        else
            log.r("错误 缺少加载内容 FunctionIconSale")
        end
    end)
end

function FunctionIconView:HideSaleIcon(saleIdName)
    if self.saleCodeList and self.saleCodeList[saleIdName] then
        self.saleCodeList[saleIdName]:Close()
        self.saleCodeList[saleIdName] = nil
    end
    
    self.iconScrollLeft:RemoveIcon(saleIdName)
end

function FunctionIconView:TestDele()
    Invoke(function()

        if self.iconScrollLeft then
            self.iconScrollLeft:Dispose()
        end

        if self.iconScrollRight then
            self.iconScrollRight:Dispose()
        end
    end, 20)
end

function FunctionIconView:Dispose()
    self._belong = nil
    self._leftHangPoint = nil
    self._rightHangPoint = nil
    self._rightHangPoint2 = nil
    self.funciconEntityCach = nil
    self.isLoading = nil
    self.saleCodeList = {}

    if self.iconScrollLeft then
        self.iconScrollLeft:Dispose()
    end

    if self.iconScrollRight then
        self.iconScrollRight:Dispose()
    end
end

function FunctionIconView:RegisterEvent()
    Event.AddListener(EventName.Event_Gift_Update,self.OnGiftChange,self)
    Event.AddListener(EventName.Event_hintTime_change,self.OnHintTimeChange,self)
    Event.AddListener(EventName.Event_coupon_change,self.OnCouponChange,self)
    Event.AddListener(EventName.Event_change_city,self.OnChangeCity,self)
    Event.AddListener(EventName.Event_Enter_City_Check_function_icon_change_double,self.CheckChangeDouble,self)
    Event.AddListener(EventName.Event_Check_Double_Activity,self.CheckDoubleActivityChange,self)
    Event.AddListener(EventName.Event_Add_Function_Icon, self.AddFunctionIconIfNotExist, self)
end

function FunctionIconView:RemoveEvent()
    Event.RemoveListener(EventName.Event_Gift_Update,self.OnGiftChange,self)
    Event.RemoveListener(EventName.Event_hintTime_change,self.OnHintTimeChange,self)
    Event.RemoveListener(EventName.Event_coupon_change,self.OnCouponChange,self)
    Event.RemoveListener(EventName.Event_change_city,self.OnChangeCity,self)
    Event.RemoveListener(EventName.Event_Enter_City_Check_function_icon_change_double,self.CheckChangeDouble,self)
    Event.RemoveListener(EventName.Event_Check_Double_Activity,self.CheckDoubleActivityChange,self)
    Event.RemoveListener(EventName.Event_Add_Function_Icon, self.AddFunctionIconIfNotExist, self)
end

function FunctionIconView:OnGiftChange()
    local showData = ModelList.GiftPackModel:GetPackEnterViewDisplayData()
    --log.log("展示的礼包数据 FunctionIconView OnGiftChange" , showData)
    local checkList = {}
    local creatList = {}
    local destroyList = {}
    for k, v in pairs(showData) do
        checkList[v.name] = true
        if not self.saleCodeList[v.name] then
            --不存在的礼包图标
            creatList[v.name] = v
        end
    end
    for k ,v in pairs(self.saleCodeList) do
        if not checkList[k] then
            --需要删除的礼包图标
            destroyList[k] = true
        end
    end
    log.log("展示的礼包数据 FunctionIconView OnGiftChange creatList " , creatList)
    log.log("展示的礼包数据 FunctionIconView OnGiftChange destroyList " , destroyList)

    if GetTableLength(destroyList) > 0 then
        for k ,v in pairs(destroyList) do
            self.iconScrollRight:RemoveIcon(k)
            self:HideSaleIcon(k)
        end
    end
    if GetTableLength(creatList) == 0 then
        return
    end
    local ab = AssetList.FunctionIconSale --促销图标都有这个
    local curr = ModelList.PlayerInfoModel.get_cur_server_time()
    Cache.load_prefabs(ab,"FunctionIconSale",function(ret)
        if ret then
            for k, v in pairs(creatList) do
                if v.isDisplay and v.expireTime > curr and not self.saleCodeList[v.name] and v.name ~= "565" then --屏蔽礼包
                    local go = fun.get_instance(ret)
                    local saleCode = FunctionIconSaleView:New(v);
                    saleCode:SkipLoadShow(go,true,nil,true)
                    saleCode:IsFunctionOpenCity()
                    saleCode:SetIconManager(self)
                    self.iconScrollRight:AddIcon(go, saleCode ,v.name, true)
                    self.saleCodeList[v.name] = saleCode
                end
            end
        else
            log.r("错误 缺少加载内容 FunctionIconSale")
        end
    end)
end


return FunctionIconView