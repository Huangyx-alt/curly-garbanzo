--region BaseViewEx.lua
--View 层基类
--endregion
local setmetatable = setmetatable
local wait = coroutine.wait

---@class BaseViewEx
BaseViewEx = class("BaseViewEx", Object)
BaseViewEx.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
local this = BaseViewEx;
this.luabehaviour = nil --LuaBehaviour c#代码，详细查看其
this.update_x_enabled = false --开启独立刷新
this.dev_mode_ui_list = {}  --Dev环境显示的uilist
this.isInit = false
this.isCleanRes = false
this.second_atlas_name = nil
this.isCleanAb = true

local creat_sole_identity = (function()
	local sole_identity = 0
	local fun = function()
		sole_identity = sole_identity + 1
		--log.r("============================>>creat_sole_identity "  .. sole_identity)
		return sole_identity
	end
	return fun
end)()

local function GetNoRepeatIdentity()
	return creat_sole_identity()
end

local creat_activated_view_list = (function()
	local activated_view_list = {}
	local fun = function()
		return activated_view_list
	end
	return fun
end)()


local function GetActivatedViewList()
	return creat_activated_view_list()
end

local function GetActivatedViewById(id)
	return creat_activated_view_list()[id]
end

local function SetActivatedView(id,value)
	creat_activated_view_list()[id] = value
end

--创建View对象--
function BaseViewEx:New(viewName,atlasName,bundleName)
	local o = {viewName = viewName,atlasName = atlasName,bundleName = bundleName, isShow = false, isLoaded = false, changeSceneClear = true}
	self.__index = self
    setmetatable(o, self)
	return o
end


function BaseViewEx:GetRootView()
	if fun.is_null(SceneViewManager.page_layer) then
		SceneViewManager.page_layer = UnityEngine.GameObject.FindWithTag("NormalUiRoot")
	end 
	local parent = SceneViewManager.page_layer
 
	return parent
end

function BaseViewEx:init()
	local p = self.viewName
	local atlas = self.atlasName
	local ab = self.bundleName
	self.closed = false
	self.nameGuid =GameMaster.GameAPI.OnClickUI(p)
	self.atlasRefs = {}  -- 存储图集引用 {atlasName = true}
	 -- 1. 构建图集列表（支持主图集+副图集）
    local atlasList = {self.atlasName}
    if self.second_atlas_name then
        table.insert(atlasList, self.second_atlas_name)
    end

	-- 2. 异步加载所有关联图集
    AtlasManager:LoadAtlasesAsync(
        atlasList,
        self.viewName,  -- 使用viewName作为引用标识
        function(success)
            if not success or self.closed then 
                log.e("图集加载失败或视图已关闭:", self.viewName)
                return
            end
            
            -- 记录已加载图集引用
            for _, atlas in ipairs(atlasList) do
                self.atlasRefs[atlas] = true
            end
			local fileName = self.bundleName or self.viewName
            -- 3. 加载视图预制体
            ResourcesManager:LoadAssetAsync(
                BundleCategory.LPB.Prefabs,
                self.viewName,
				typeof( CS.GameObject),
                function(assetId, err)
                    if not assetId or self.closed then
                        log.e("预制体加载失败:", self.viewName, err)
                        return
                    end
                    
                    -- 4. 实例化视图
                    local prefab = ResourcesManager:GetAssetObject(assetId)
                    self:_instantiate_view(prefab)
                end
            )
        end
    )
end
-- 视图实例化（私有方法）
function BaseViewEx:_instantiate_view(prefab)
    local go = fun.get_instance(prefab)
    if not go then
        log.e("实例化失败:", self.viewName)
        return
    end

    -- 初始化视图属性
    go.name = self.viewName
    local parent = self:GetRootView()
    go.transform:SetParent(parent.transform)
    go.transform.localScale = Vector3.one
    go.transform.localPosition = Vector3.zero

    -- 设置RectTransform
    local rect = fun.get_component(go, fun.RECT)
    if rect then
        rect.offsetMin = Vector2.zero
        rect.offsetMax = Vector2.zero
    end

    -- 核心组件绑定
    self.go = go
    self.transform = go.transform
    self.luabehaviour = Util.AddLuaBehaviour(go, function(t, g)
        self:OnLuaBehaviour(t, g)
    end)

    fun.set_active(go, true)
    self:on_init()
    
    -- UI显示埋点
    if self.nameGuid then
        GameMaster.GameAPI.OnShowUI(self.nameGuid)
    end
end
--加载prefabs
-- function BaseViewEx:init()
-- 	local p = self.viewName
-- 	local atlas = self.atlasName
-- 	local ab = self.bundleName
-- 	self.closed = false
-- 	self.nameGuid =GameMaster.GameAPI.OnClickUI(p)
-- 	Cache.load_view_prefab(ab,p,atlas,function(panel_name,prefabs)
-- 		if not self.closed then --加载过程中有销毁动作则不再Instantiate
-- 			--初始加载UI
-- 			if self.nameGuid then
-- 				GameMaster.GameAPI.OnIoUI(self.nameGuid)
-- 			end
-- 			local go = fun.get_instance(prefabs)
-- 			if go and go.transform then
-- 				go.name = panel_name
-- 				local parent = self:GetRootView()
-- 				go.transform:SetParent(parent.transform)
-- 				go.transform.localScale = Vector3.New(1,1,1)
-- 				go.transform.localPosition = Vector3.New(0,0,0)
-- 				local rect = fun.get_component(go,fun.RECT)
-- 				if rect then
-- 					rect.offsetMin = Vector2.New(0, 0)
-- 					rect.offsetMax = Vector2.New(0, 0)
-- 				end
-- 				--初始赋值
-- 				self.go = go
-- 				self.transform = go.transform
-- 				self.luabehaviour = Util.AddLuaBehaviour(self.go,function (t,g)
-- 					self:OnLuaBehaviour(t,g)
-- 				end)
-- 				fun.set_active(self.go,true)
-- 				self:on_init()
-- 				if self.nameGuid then
-- 					GameMaster.GameAPI.OnShowUI(self.nameGuid)
-- 				end
-- 				return true
-- 			else
-- 				log.r("!!!!!error: "..panel_name.." go is null")
-- 				return false
-- 			end
-- 		end
-- 	end,self.second_atlas_name)
-- end

function BaseViewEx:Awake(g)
	--子类重载
end

function BaseViewEx:Start()
	--子类重载
end

function BaseViewEx:OnEnable(params)
	--子类重载
end

function BaseViewEx:OnDisable()
	--子类重载
end

function BaseViewEx:Promote(params)
	--子类重载
end

function BaseViewEx:OnClick()
	--子类重载
end

function BaseViewEx:OnDestroy()
	--子类重载
	self:Close()
end

function BaseViewEx:IsTrunk()
	--子类重载
	return false
end

function BaseViewEx:IsTopBarView()
	--子类重载
	return false
end

function BaseViewEx:OnEnable_before()
	--子类重载
end

function BaseViewEx:OnEnable_late()
	--子类重载
end

function BaseViewEx:OnDisable_late()
	--子类重载
end

function BaseViewEx:OnDestroy_late()
	--子类重载
end

function BaseViewEx:OnApplicationFocus(focus)
	--子类重载
end

function BaseViewEx:OnApplicationPause(pause)
	--子类重载
end

function BaseViewEx:OnApplicationQuit()
	--子类重载
end

function BaseViewEx:CanAddSceneViewManager()
	--子类重载
	return true
end

--子类重载
function BaseViewEx:PlayBtnClickSound(btn_name)
	if btn_name == "btn_goback" or btn_name == "btn_close" then
        UISound.play("interfaceclosed")
    else
        UISound.play("kick")    
    end
end

--子类重写
function BaseViewEx:OpenView(callback, ...)
	if self.viewName and ViewList[self.viewName] then
		Facade.SendNotification(NotifyName.ShowUI,ViewList[self.viewName],function()
			if callback then
				callback()
			end
		end)
	end
end

--子类重写
function BaseViewEx:CloseView(callback, ...)
	Facade.SendNotification(NotifyName.CloseUI,self)
end

function BaseViewEx:GetParentView()
	--子类重写
	return nil
end

function BaseViewEx:HideCoverageEntity()
	--子类重写
end

function BaseViewEx:ShowCoverageEntity()
	--子类重写
end

function BaseViewEx:IsLifeStateDisable()
	return self._lifeState == nil
	or self._lifeState == 3
	or self._lifeState == 5
end

function BaseViewEx:IsLifeStateEnable()
	return self._lifeState == 2
end

function BaseViewEx:NotifyHideCoverageEntity()
	Facade.SendNotification(NotifyName.SceneCity.cityEntity_Show_Hide,false)
end

function BaseViewEx:NotifyShowCoverageEntity()
	Facade.SendNotification(NotifyName.SceneCity.cityEntity_Show_Hide,true)
end

function BaseViewEx:OnLuaBehaviour(t,g)
	if t == 0 then
		self:Awake(g)
		self._lifeState = t
	elseif t == 1 then
		self:Start()
		self._lifeState = t
	elseif t == 2 then
		----优先生成id，以免在执行OnEnable的过程中Disable掉
		self._view_identity = GetNoRepeatIdentity()
		SetActivatedView(self._view_identity,self)
		----优先生成id，以免在执行OnEnable的过程中Disable掉

		self:OnEnable_before()
		self:OnEnable(self._enableParams)
		self:OnEnable_late()
		self._enableParams = nil
		self._lifeState = t
	elseif t == 3 then
		self:OnDisable()
		self:OnDisable_late()
		if self._view_identity then
			SetActivatedView(self._view_identity,nil)
			self._view_identity = nil
		else
			log.r("============>>view_identity error: " .. tostring(self.viewName))		
			--log.r("============>>view_identity error: " .. tostring(self.atlasName))
			--log.r("============>>view_identity error: " .. tostring(self.bundleName))
		end
		self._lifeState = t
	elseif t == 4 then
		self:OnClick(g)
	elseif t == 5 then
		self:OnDestroy()
		self:OnDestroy_late()
		self._lifeState = t
	end
end

function BaseViewEx:on_init()
	if self.go == nil then
		return
	end
	if(self.isInit == nil or self.isInit == false)then
		self.isInit = true
		if(self.luabehaviour==nil)then
			self.luabehaviour = fun.get_component(self.go,fun.LUABEHAVIOUR)
		end
		self:auto_find_ui_item()
		self:on_init_dev_ui()
		self:start_x_update()
		if self.on_after_bind_ref then
			self:on_after_bind_ref(self._showViewCallback)
		end
		CanvasSortingOrderManager.SetLayerOrder(self.viewType,self.go)
		self:LoadCallback()
		return true
	else
		return false
	end 
end


function BaseViewEx:LoadCallback()
	if(self._showViewCallback  and type(self._showViewCallback) == "function")then
		self._showViewCallback(self.go)
		self._showViewCallback = nil
	end
	self:HideCoverageEntity()
end

--判断是否有canvasngroup,用来做渐变转场使用
function BaseViewEx:HasCanvasGroup()
    local canvansGroup = fun.get_component(self.go,fun.CANVAS_GROUP)
	if(canvansGroup)then 
		self._canvansGroup  = canvansGroup
        return true
    end
    return false
end

local changeViewAlpahTime = 2
function BaseViewEx:DoTweenIn()
	if(self:HasCanvasGroup())then 
		local canvansGroup = fun.get_component(self.go,fun.CANVAS_GROUP)
		self._canvansGroup.alpha = 0
		Anim.do_smooth_float_update(0,1,changeViewAlpahTime,function(num)
			self._canvansGroup.alpha = num
		end,function()
			self._canvansGroup.alpha = 1 
		end) 
	end 
end
function BaseViewEx:DoTweenOut()
	if(self:HasCanvasGroup())then 
		local canvansGroup = fun.get_component(self.go,fun.CANVAS_GROUP)
		self._canvansGroup.alpha = 1
		Anim.do_smooth_float_update(1,0,changeViewAlpahTime,function(num)
			self._canvansGroup.alpha = num
		end,function()
			self._canvansGroup.alpha = 0
			fun.set_active(self.go,false)
		end) 
	else

		fun.set_active(self.go,false)
	end 
end

function BaseViewEx:SkipLoadShow(obj,activeGo,callback,params)
	if callback ~= nil then
		self._showViewCallback = callback;
	end
	self._enableParams = params
	local isActive = true
	if activeGo == false then
		isActive = false
	end
	--- View/AWrap/UI/BaseViewEx:356: attempt to index field 'go' (a nil value)  收集的报错
	if fun.is_null(obj) then
		log.r("SkipLoadShow obj is null")
		return
	end
	if(self.go == nil or self.go ~= obj)then
		--log.r("SkipLoadShow self.go == nil or self.go ~= obj")
		self.go = obj
		self.transform = self.go.transform
		self.luabehaviour = Util.AddLuaBehaviour(self.go,function (t,g)
 				self:OnLuaBehaviour(t,g)
		end)
		self:on_init()
	else
		--log.r("SkipLoadShow self.go ~= obj")
		if self.on_after_bind_ref then
			self:on_after_bind_ref(self._showViewCallback)
		end
		self:LoadCallback()
		if self.go and activeGo and (self.go.name == "HallMainView" or self.go.name == "HallCityView") then
			ModelList.GuideModel:BackToActiveUI(self.go.name)
		end
	end
	CanvasSortingOrderManager.SetLayerOrder(self.viewType,self.go) 
	self.isLoaded = true;
	self.isShow = isActive;
	fun.set_active(self.go,isActive)
end


--显示View对象
function BaseViewEx:Show(callback,params)
	self._showViewCallback = callback;
	self._enableParams = params
	if(self.go == nil)then
		--log.y("Show self.go == nil")
		self:init(callback)
	else
		--log.y("Show self.go ~= nil")
		fun.set_active(self.go,true)
		if self.on_after_bind_ref then
			self:on_after_bind_ref(self._showViewCallback)
		elseif self._showViewCallback then
			self._showViewCallback()
		end
		CanvasSortingOrderManager.SetLayerOrder(self.viewType,self.go)
	end
	--事件打点_UI交互_打开界面
	--SDK.open_view(self.viewName,UnityEngine.SceneManagement.SceneManager.GetActiveScene().name)

	-- self:SetCanvasOrder()
	--UIManager:ShowUI(self.viewName);
	self.isLoaded = true;
	self.isShow = true;
end

function BaseViewEx:SetCanvasOrder()
	local order =  StaticData.get_view_order(self.viewName)
	if order == nil then
		return
	end
	local canvas = fun.get_component(self.go,fun.CANVAS)
	if canvas~= nil then
		canvas.overrideSorting = true
		canvas.sortingOrder = order
	end

end
--隐藏View对象,不要直接调用该方法，使用HideUi Command走统一接口方便管理ui
function BaseViewEx:Hide()
	--UIManager:HideUI(self.viewName);
	if(self.onHide)then 
		self:onHide()
	end
	self:stop_all_invoke()
	self:stop_all_coroutine()

	if self.viewType ~= CanvasSortingOrderManager.LayerType.None then
		CanvasSortingOrderManager.RecycleLayerOrder(self.viewType,self.go)
	end
	fun.set_active(self.go,false)
	
	self.isShow = false;
end

function BaseViewEx:Click_to_hide()

end

--销毁View对象
function BaseViewEx:Close(is_not_destroy_gameobject)
	if not self.isInit then
		return
	end
	self:ShowCoverageEntity()
	self.isInit = false 
	self.isShow = false;

	if(self.on_close)then 
		self:on_close()
	end

	--local viewname = self.viewName or self.go.name
    SceneViewManager.RemoveView(self)
	CanvasSortingOrderManager.RecycleLayerOrder(self.viewType,self.go)
	self:_close(is_not_destroy_gameobject)
	self.isLoaded = false;
	--Facade.RemoveView(self)
end

function BaseViewEx:clean_raycast()
	Util.ClearRaycastResults(self.go)
end

function BaseViewEx:closeWithAnimation()
	--可能的关闭动画的nameKey
	local closeAnimaNameKeyList = { 
		"viewend", "view_end", 
		"viewexit", "view_exit", 
		"viewclose", "view_close",
	}
	
	--animator组件
	local anima = self.Anima or self.anima
	anima = anima or fun.get_component(self.go, fun.ANIMATOR)
	
	if not anima then
		return this._close(self)
	end
	
	local clip = fun.FindAnimatorClip(anima, closeAnimaNameKeyList)
	if fun.is_not_null(clip) then
		AnimatorPlayHelper.Play(anima, {"end", clip.name}, false, function()
			this._close(self)
		end)
	else
		this._close(self)
	end
end

function BaseViewEx:_close(is_not_destroy_gameobject)
	-- log.log("CtrlBase:close",self.viewName)
	self:clean_raycast()
	self.closed = true

	self:stop_all_invoke()
	self:stop_all_coroutine()
	self:stop_all_timer()
	self.btn_click_bind_map = nil

	self:stop_x_update()
	if not fun.is_null(self.go) and is_not_destroy_gameobject ~= true then
		fun.set_active(self.go,false)
		Destroy(self.go)
	end
	self.go = nil 
	self.isInit = false

	if(self.isCleanRes)then 
		self:clean_res()
	elseif(fun.is_low_memory())then  
		self:clean_res()
	end
end

--[[
    @desc: 清理ab资源,低端机在加载UI后,如果不清理,内存不会卸载
    author:{author}
    time:2021-04-21 14:28:19
    @return:
]]
function BaseViewEx:clean_res()
	--log.r(" run clean_res ")
	if(self.viewName or self.atlasName)then
		local waitTime = 3
		if self._cleanImmediately or not self.isCleanRes then waitTime = 0 end
		Invoke(function()
			if self.closed then
				if self.atlasName  then
					--AssetManager.unload_atlas_ab({self.atlasName})
					--log.r("unload_ab   atlasName "..self.atlasName)
					Cache.remove_atlas_reference(self.atlasName,AssetList[self.viewName] or self.viewName)
				end
				if self.second_atlas_name then
					Cache.remove_atlas_reference(self.second_atlas_name,AssetList[self.viewName] or self.viewName)
				end
				if self.viewName and AssetList[self.viewName] and self.isCleanAb  then
					if ViewList[self.viewName]  == nil or not (ViewList[self.viewName].go and not fun.is_null(ViewList[self.viewName].go))   then
						AssetManager.unload_ab({AssetList[self.viewName]})
						--log.r("unload_ab    "..AssetList[self.viewName])
					else
						log.r("cancel unload_ab    "..AssetList[self.viewName])
						return
					end
				end
			end
		end,waitTime)--ResourceManager有引用计数器了，延迟久点没关系，要不关闭界面卡死了
	end
end

function BaseViewEx:run_coroutine(func)

	if(self.coroutines==nil)then  
		self.coroutines = {}
	end

	if(self.coroutines)then
		local coroutine = fun.run(func)
		self.coroutines[#self.coroutines + 1] = coroutine
		return coroutine
	end
	return nil
end

function BaseViewEx:register_invoke(func,delay_time,scale)
	local invoke_func = Invoke(func,delay_time,scale)

	if self.invoke_group == nil then self.invoke_group = {} end
	table.insert(self.invoke_group,invoke_func)
	return invoke_func
end
function BaseViewEx:register_timer(delay_time,func)
	 local ret =  LuaTimer:SetDelayFunction(delay_time, func) 
	 if self.timer_group == nil then self.timer_group = {} end
	 table.insert(self.timer_group,ret)
	return ret
end
function BaseViewEx:register_loop_timer(delayTime, loopDelay, loopCout, funcLoop,funcOnFinish,is_real_time,timer_type)
	local ret =  LuaTimer:SetDelayLoopFunction(delayTime, loopDelay, loopCout, funcLoop,funcOnFinish,is_real_time,timer_type) 
	if self.timer_group == nil then self.timer_group = {} end
	table.insert(self.timer_group,ret)
   return ret
end


function BaseViewEx:stop_all_timer()
	if self.timer_group then
		for _,v in pairs(self.timer_group) do
			self:stop_timer(v)
		end
	end
	self.timer_group = nil
end

function BaseViewEx:stop_timer(timerId,timeType)
	LuaTimer:Remove(timerId, timeType)  
end
 

function BaseViewEx:register_invoke_repeat(func,delay_time)
	local invoke_repeat_func = InvokeRepeat(func,delay_time)
	if(self.invoke_repeat_group ==nil)then self.invoke_repeat_group = {} end
	table.insert(self.invoke_repeat_group,invoke_repeat_func)
	return invoke_repeat_func
end

function BaseViewEx:stop_all_coroutine()
	if self.coroutines then
		for _,v in pairs(self.coroutines) do
			fun.stop(v)
		end
	end
	self.coroutines = nil
end

function BaseViewEx:stop_all_invoke()
	if self.invoke_group then
		for i,v in pairs(self.invoke_group) do
			if v then
				v:Stop()
			end
		end
		self.invoke_group = nil
	end
	if self.invoke_repeat_group then
		for i,v in pairs(self.invoke_repeat_group) do
			v:Stop()
		end
	end
	self.invoke_repeat_group = nil
end

--获取界面Atlas
function BaseViewEx:SetAtlas(func)
	local GetLoader = BaseLoad.GetLoader;
	self.viewAtlas = GetLoader(self.atlasName);
	if (not self.viewAtlas) then
		wait(0.1);
		self.viewAtlas = GetLoader(self.atlasName);
	end
	if (func) then spawn(func) end;
	return self.viewAtlas; 
end

--释放View对象
function BaseViewEx:Destroy()
	if self.auto_bind_ui_items then
		self:auto_unbind_child_by_ref(self.auto_bind_ui_items)
	end
	self.go = nil 
	self.isInit = nil
end

--发送通知--
function BaseViewEx.SendNotification(notifyName, ...)
	Facade.SendNotification(notifyName, ...);
end

function BaseViewEx:stop_x_update()
	if not self.update_x_enabled then return end
	if self.update_x_handler then
		UpdateBeat:RemoveListener(self.update_x_handler)
		self.update_x_handler = nil
	end
end

function BaseViewEx:start_x_update()
	if not self.update_x_enabled then return end
	self:stop_x_update()
	self.invoke_x_list = {}
	self.start_time = fun.get_real_time_since_startup()
	self.update = xp_call(function()
		self:on_x_update()
	end)

	self.update_x_handler = UpdateBeat:CreateListener(self.update)
	UpdateBeat:AddListener(self.update_x_handler)
end

function BaseViewEx:on_x_update() end

--初始化开发ui ，正式环境不显示
function BaseViewEx:on_init_dev_ui()
	if self.dev_mode_ui_list then
		local bool = AppConst.DevMode
		for i, v in ipairs(self.dev_mode_ui_list) do
			if self[v] then
				fun.set_active(self[v], bool)
			end
		end
	end
end

function BaseViewEx:auto_find_ui_item()
	if self.auto_bind_ui_items then
		self:auto_bind_child_by_ref(self.go,self.auto_bind_ui_items)
	else
		log.r("跳过绑定",self.panel_name)
	end
end

function BaseViewEx:auto_bind_child_by_ref(go,auto_bind_ui_items)
	local ref = fun.get_component(go.transform,fun.REFER)
	if ref then
		for i,v in ipairs(auto_bind_ui_items) do
			--log.r("=============================>>auto_bind_child_by_ref " .. v)
			self[v] = ref:Get(v)
			if self[v] == nil then
				--log.log("[auto_bind 提示]",go.name,"下未找到节点",v)
			else
				if StringUtil.start_with(v,"btn_") then
					-- print("================================>> " .. v)
					self:bind_click(v,"on_"..v.."_click")
				end
			end
		end
	else
		log.r(go.name.." 未绑定控件")
	end
end

function BaseViewEx:auto_unbind_child_by_ref(auto_bind_ui_items)
	for i,v in ipairs(auto_bind_ui_items) do
		if self[v] ~= nil and  not fun.is_null( self[v])  then
			if StringUtil.start_with(v,"btn_") then
				self.luabehaviour:RemoveClick(self[v].gameObject)
			end
		end
		self[v] = nil
		if(self.btn_click_bind_map)then 
			self.btn_click_bind_map[v] = nil 
		end
	end
end

function BaseViewEx:bind_click(button_name,callback_name)
	self.btn_click_bind_map = self.btn_click_bind_map or {}
	if type(callback_name) == "function" then
		if self.btn_click_bind_map[button_name] then
			log.r({
				err = "按钮事件重复绑定",
				button_name = button_name,
				panel_name = self.panel_name,
			})
		end
		self.btn_click_bind_map[button_name] = callback_name

		self.luabehaviour:AddClick(self[button_name].gameObject,function()
			self:PlayBtnClickSound(button_name)
			callback_name(self)
		end)
	else
		if self.btn_click_bind_map[button_name] then
			log.r({
				err = "按钮事件重复绑定",
				button_name = button_name,
				panel_name = self.viewName,
				callback_name = callback_name,
			})
		end
		self.btn_click_bind_map[button_name] = callback_name
		if(self[button_name])then
			self.luabehaviour:AddClick(self[button_name].gameObject,function()
				if self[callback_name] then
					self:PlayBtnClickSound(button_name)
					log.r("btnsss",button_name)
					self[callback_name](self)
				else
					log.r({
						err = "按钮回调方法不存在",
						button_name = button_name,
						panel_name = self.viewName,
						callback_name = callback_name,
					})
				end
			end)
		else
			log.r("没有找到btn"..button_name)
		end
	end
end

--显示弹出框
local function ShowMsgBox(content, confirm, cancel)
	this.SendNotification(NotifyName.ShowUI, MsgBox, content, confirm, cancel);
end

--显示弹出tips
local function ShowMsgTips(content)
	this.SendNotification(NotifyName.ShowUI, MsgTips, content);
end


return this