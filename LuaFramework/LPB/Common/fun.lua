require "Common/StringUtil"

local json = require "cjson"
local json_util = require "Common/3rd/cjson/util"

local showDeltaTime = ArtConfig.Show_DialogView_Time
local hideDeltaTime = ArtConfig.Hide_DialogView_Time
local limitNameNum = ArtConfig.LimitNameNum

--common脚本
fun = {}
fun.None = "None"
fun.IMAGE = 'UnityEngine.UI.Image'
fun.RAW_IMAGE = 'UnityEngine.UI.RawImage'
fun.OLDTEXT = 'UnityEngine.UI.Text'  --暂废弃 使用TMPro.TextMeshProUGUI
fun.TEXT = 'TMPro.TextMeshProUGUI'    
fun.BUTTON = 'UnityEngine.UI.Button'
fun.SLIDER = 'UnityEngine.UI.Slider'
fun.INPUT_FIELD = 'UnityEngine.UI.InputField'
fun.ANIMATOR = 'Animator'
fun.RECT = 'RectTransform'
fun.OUT_LINE = 'UnityEngine.UI.Outline'
fun.DRAPDOWN = 'UnityEngine.UI.Dropdown'
fun.ANIMATION = 'Animation'
fun.MESH_RENDERER = 'UnityEngine.MeshRenderer'
fun.RENDERER = 'UnityEngine.Renderer'
fun.SCROLL_RECT = 'UnityEngine.UI.ScrollRect'
-- fun.TRAIL_RENDERER = "UnityEngine.TrailRenderer" -- 为了适配2022版本的unity 魔改了tolua生成规则,有差异 by LwangZg
fun.PARTICLE = 'UnityEngine.ParticleSystem'
fun.SPINE = 'Spine.Unity.SkeletonAnimation' -- SPINE动画组件
fun.SPINEGRAPHIC = 'SpineControl' -- SPINE动画组件

fun.REFER = 'ReferGameObjects'
fun.CLIPPING = "ClippingGroup"	-- SPINE动画裁剪组件
fun.ROLLING = "RollingNumber" -- 滚动数字控件
fun.MASK = "UnityEngine.UI.Mask"
fun.RECT_MASK = "UnityEngine.UI.RectMask2D"
fun.IMAGESPRITESCONTAINER = "ImageSpritesContainer"
fun.HORIZONTALLAYOUT = "UnityEngine.UI.HorizontalLayoutGroup"
fun.VERTICALLAYOUT = "UnityEngine.UI.VerticalLayoutGroup"
fun.MEMORY = "InstanceMemory" -- 实例变量寄存器
fun.CANVAS = "Canvas"
fun.CANVAS_GROUP = "CanvasGroup"
fun.BUTTON_EVENT = "ButtonEventController" -- 按钮事件处理(长按)
fun.VIBRATOR = "Vibrator" -- 震动控制器
fun.TOGGLE = "UnityEngine.UI.Toggle"
fun.COUNTDOWN = "SpriteCountDown" -- 倒计时控件
fun.MACHINECFG = "MachineCfg"
fun.GRAPHICRAYCASTER = "UnityEngine.UI.GraphicRaycaster"
fun.LayoutElement = "UnityEngine.UI.LayoutElement"
fun.FAKELOBBYRTT = "FakeRTT"
fun.TRAILRENDERER = "TrailRenderer"
fun.LUABEHAVIOUR = "LuaFramework.LuaBehaviour"
fun.TXTPRO = "TMPro.TextMeshProUGUI"
fun.SPRITETXTPRO = "TMPro.SpriteTextMeshProUGUI"
fun.ELEMENTMAMANAGER = "ElementManager"
fun.ELEMENTMAMANAGEREFFECT = "ElementManagerEffect"
fun.IMAGEUVCHANGEANIMATION = "ImageUVChangeAnimation"
fun.ROLLINGNUMBER3D = "RollingNumber3D"
fun.SIGNAPPLE = "SignInWithAppleLua"
fun.SAFEAREAEX = "SafeAreaEx"
fun.TRIGGER2D = "LuaTrigger2D"
fun.VWHEELROTATOR = "VerticalWheelRotator"
fun.CAMERASHAKE = "CameraShake"
fun.GAMEOBJECTCONTAINER = "GameObjectContainer"
--lua中number的最大值
fun.NUMBER_MAX = 2^53+10
fun.EPS_UI = 0.1 --精度（用于UI尺寸偏差判定）
fun.OBJECTSELECTOR = "ObjectSelector"
fun.LANGUAGERESMANAGER = "LanguageResManager"
fun.BOXCOLLIDER2D = "BoxCollider2D"
fun.CIRCLECOLLIDER2D = "CircleCollider2D"
fun.UIDRAGCONTROL = "UIDRAGCONTROL"
fun.CLICKHINGEJOINT = "ClickHingeJoint"
fun.LayoutRebuilder = "UnityEngine.UI.LayoutRebuilder"
fun.SPRITERENDERER = "SpriteRenderer"
fun.SPRITEASSETCONTAINER = "SpriteAssetContainer"
fun.PAGEVIEW = "PageView"
fun.Op = 
{
	Equal = 0,
	EqualOrLargeThan = 1,
	EqualOrSmallThan = 2
}


local SystemInfo = UnityEngine.SystemInfo;


function fun.is_ios_platform()
	local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.IPhonePlayer or platform == UnityEngine.RuntimePlatform.OSXPlayer then
        return true
    end
    return false
end
function fun.is_android_platform()
	
    if(fun.IsEditor())then 
        return true 
    end
	local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.Android then
        return true 
    end
	return false 
end

--用于判断低内存
function fun.is_low_memory()
	if(not fun._memory_value)then 
		fun._memory_value = SystemInfo.systemMemorySize
		log.r("_memory_value",fun._memory_value)
	end

	if(fun._memory_value and fun._memory_value < 1024)then 
		return true 
	end 

	return false
end

function fun.is_android_low_memory() 
	 local ram = ThinkingAnalyticsHelper.Instance:GetRam()
	 if(StringUtil.is_empty(ram))then 
		log.r("ram is empty")
		 return false 
	 end
	 local memory = StringUtil.split_string(ram,"/")
	 local allocableMemory = tonumber(memory[1]) *1024
	 local totalMemory = tonumber(memory[2])  

	 log.r("lxq ram:",memory,allocableMemory,totalMemory)
	 if(allocableMemory>0 and allocableMemory<300)then
		if SDK then
			SDK.TrackEvent("andoird_low_memory",{totalMemory = totalMemory,allocableMemory= allocableMemory})
		end
		return true 
	 end 
	  
	return false
end


-- 判断c#对象为空
function fun.is_null(cls)
	local str = tostring(cls)
	return cls == nil  or str == "null" or tostring(cls) == "userdata: NULL" or Util.IsNull(cls)
end

function fun.is_not_null(cls)
	return not fun.is_null(cls)
end

function fun.is_empty_str(s)
	return s == nil or s == ''
end

function fun.GameObject_find(name)
	return GameObject.Find(name)
end

function fun.find_gameObject_with_tag(tagName)
	local go = UnityEngine.GameObject.FindGameObjectWithTag(tagName)
	if fun.is_null(go) then
		log.r("can not find GameObject with tag " .. tagName)
	end
	return go
end

--获取当前场景
function fun.get_active_scene()
	return UnityEngine.SceneManagement.SceneManager.GetActiveScene()
end

--世界坐标转屏幕坐标
function fun.world_to_ui_point(canvas,pos)
    local v_v3 = UnityEngine.Camera.main:WorldToScreenPoint(pos)  
	local v_ui = canvas.worldCamera:ScreenToWorldPoint(v_v3)
	local v_new = Vector3.New(v_ui.x, v_ui.y, fun.get_component(canvas.gameObject,fun.RECT).anchoredPosition3D.z)
    return v_new
end

--get instance
function fun.get_instance(obj,parent)
	if fun.is_null(obj) then
		log.r("get instance fail. obj is null")
		return
	end
	--Util.Log(obj.gameObject.name)
	if fun.is_null(parent) then
		return UnityEngine.GameObject.Instantiate(obj.gameObject)
	else
		return UnityEngine.GameObject.Instantiate(obj.gameObject,parent.transform)
	end
end

--开启一个协程
function fun.run(func)
	return coroutine.start(func)
end


--停止一个协程 func_coroutine=开启时返回的参数
function fun.stop(func_coroutine)
	coroutine.stop(func_coroutine)
end

--持久化用户数据
function fun.save_value(key,v)
	if v then
		UnityEngine.PlayerPrefs.SetString(key,TableToJson({v=v}))
	else
		UnityEngine.PlayerPrefs.SetString(key,"")
	end
	UnityEngine.PlayerPrefs.Save()
end

--读取用户数据
function fun.read_value(key, default)
	local s = UnityEngine.PlayerPrefs.GetString(key,"")	
	if s ~= "" then 
		local data = JsonToTable(s) 
		if type(data) == "table" then
			return data.v
		end
	end
 
	return default
end

--读取用户数据2
function fun.read_value2(key, default)
	local s = UnityEngine.PlayerPrefs.GetString(key,"")	
	if s ~= "" then 
		return s
	end
 
	return default
end

function fun.delete_value(key)
	UnityEngine.PlayerPrefs.DeleteKey(key)
end

-- 持久化Int型数据
function fun.save_int(key, val)
	val = val or 0
	UnityEngine.PlayerPrefs.SetInt(key, val)
end

-- 读取Int型数据
function fun.get_int(key, default)
	return UnityEngine.PlayerPrefs.GetInt(key, default)
end

function fun.save_int_by_userid(key, value)
	local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
	local userID = userInfo.uid or "12345"
	key = string.format("%s-%s", key, userID)
	fun.save_int(key, value)
end

function fun.read_int_by_userid(key, default)
	local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
	local userID = userInfo.uid or "12345"
	key = string.format("%s-%s", key, userID)
	local ret = fun.get_int(key, default)
	return ret
end

----------------------Gameobject/transform相关设置

function fun.get_clip_length(anim,name)
	return Util.GetClipLength(anim, name)
end

function fun.set_gameobject_pos(obj,x,y,z,isLocal)
	if fun.is_null(obj) then
		log.r("obj is null. set gameObject pos fail.")
		return
	end
	if isLocal then
		LuaFramework.ToLuaUtil.SetLocalPos(obj,x,y,z)
	else
		LuaFramework.ToLuaUtil.SetPos(obj,x,y,z)
	end
	--fun.set_transform_pos(obj.transform,x,y,z,isLocal)
end
function fun.TransformPoint(obj,x,y,z)
	 return LuaFramework.ToLuaUtil.TransformPoint(obj,x,y,z)
end
function fun.SetAsLastSibling(obj)
	LuaFramework.ToLuaUtil.SetAsLastSibling(obj)
end
function fun.SetAsFirstSibling(obj)
	LuaFramework.ToLuaUtil.SetAsFirstSibling(obj)
end

function fun.SetSiblingIndex(obj,index)
    if(not fun.is_null(obj))then 
        local transform = obj.transform
        transform:SetSiblingIndex(index)
    end

end

function fun.SetGameObjectLocalY(obj,y)
	LuaFramework.ToLuaUtil.SetLocalY(obj,y)
end


function fun.GetGameObjectLocalX(obj)
	return LuaFramework.ToLuaUtil.GetLocalX(obj)
end
function fun.GetTransformLocalX(transform)
	return LuaFramework.ToLuaUtil.GetLocalX(transform)
end

function fun.set_transform_pos(tran,x,y,z,isLocal)
	if(isLocal ~= true) then
		tran.position = Vector3.New(x, y, z)
	else
		tran.localPosition = Vector3.New(x, y, z)
	end
end


function fun.set_gameobject_pos_opt(obj,x,y,z,isLocal)
	if(isLocal ~= true) then
		Util.ChangeWorldPosition(obj, x, y, z)
	else
		Util.ChangeLocalPosition(obj, x, y, z)
	end
end

function fun.get_gameobject_pos(obj, isLocal)
	if fun.is_not_null(obj) then
		if(isLocal ~= true) then
			return obj.transform.position
		else
			return obj.transform.localPosition
		end
	else
		return Vector3.zero
	end
end

function fun.get_gameobject_pos_with_offset(obj, offset, isLocal)
	if fun.is_not_null(obj) then
		if(isLocal ~= true) then
			return obj.transform.position + offset
		else
			return obj.transform.localPosition + offset
		end
	else
		return Vector3.zero
	end
end

function fun.set_gameobject_rot(obj,x,y,z,isLocal)
	if(isLocal ~= true) then
		obj.transform.eulerAngles = Vector3.New(x,y,z)
	else
		obj.transform.localEulerAngles = Vector3.New(x,y,z)
	end
end

function fun.get_gameobject_rot(obj,isLocal)
	if(isLocal ~= true) then
		return obj.transform.eulerAngles
	else
		return obj.transform.localEulerAngles
	end
end

function fun.set_gameobject_scale(obj,x,y,z)
	if fun.is_null(obj) then
		log.r("obj is nil. set_gameobject_scale fail.")
		return
	end
	LuaFramework.ToLuaUtil.SetLocalScale(obj,x,y,z)
end

function fun.get_gameobject_scale(obj, isLocal)
	if fun.is_not_null( obj) then
		if isLocal then
			return obj.transform.localScale
		else
			return obj.transform.lossyScale
		end
	else
		return Vector3.zero
	end
end

--设置物体active
function fun.set_active(obj, status, delay)
	if fun.is_null(obj) then
		log.r("obj is nil. set_active fail")
		return
	end
	local set = function(obj, status)
		if obj == nil or obj.gameObject == nil then
			return
		elseif obj.gameObject and obj.gameObject.activeSelf == status then
			return
		end
		--log.r("fun.set_active    "..obj.name.."   "..tostring(status))
		obj.gameObject:SetActive(status)
	end

	local time = delay or 0
	if time == 0 then
		set(obj, status)
	else
		Invoke(function ()
			set(obj, status)
		end, delay)
	end
end

function fun.get_active_self(obj)
	if fun.is_null(obj) or fun.is_null(obj.gameObject) then
		log.r("obj is nil")
		return false
	end
	return obj.gameObject.activeSelf
end

function fun.add_component(obj,Component)
	return obj.gameObject:AddComponent(typeof(Component))
end

--获取物体component
function fun.get_component(obj, name)
	if fun.is_null(obj) then
		log.r("obj is nil")
		return nil
	end
	return obj.gameObject:GetComponent(name)
end

function fun.get_atlasByView(view)
    return string.gsub(string.lower(view),"view","atlas")
end

--获取components
function fun.get_components_in_child(obj,name)
	if fun.is_null(obj) then
		log.r("obj is nil")
		return nil
	end
	return obj.gameObject:GetComponentsInChildren(typeof(name))
end

function fun.get_component_in_child(obj,name)
	if fun.is_null(obj) then
		log.r("obj is nil")
		return nil
	end
	return obj.gameObject:GetComponentInChildren(typeof(name))
end

function CreateEmptyGameobject(x,y,transform)
	local go = GameObject.New()
	if transform then
		fun.set_parent(go,transform)
	end
	go.transform.localScale = Vector3.one
	go.transform.localPosition = Vector3.New(x, y, 0)
    return go
end

--获取gameobject上的动画组件
function fun.get_animator(obj)
	return fun.get_component(obj,fun.ANIMATOR)
end

function fun.find_child(obj,name)
	if fun.is_null(obj) then
		log.r("Obj is nil. Find child fail.")
		return nil
	end
	local child = obj.transform:Find(name)
	if(  fun.is_null(child)  ) then
		--log.r("在 "..obj.name.." 中查找子物体 "..name.." 失败，该物体不存在！")
		return nil
	else
		return child.gameObject
	end
end

function fun.get_child(obj,index)
	local childCount = fun.get_child_count(obj)
	if index >= childCount then
		return
	end
	
	local child = obj.transform:GetChild(index)
	if(child == nil) then
		log.w("在 "..obj.name.." 中查找子物体序号 " ..index.. " 失败，该物体不存在！")
	end
	return child
end

function fun.get_child_count(obj)
	if fun.is_null(obj) then
		log.r("Obj is nil. Get child count fail.")
		return 0
	end
	return obj.transform.childCount
end

function fun.eachChild(obj, func)
	local childCount = fun.get_child_count(obj)
	if childCount == 0 then
		return
	end

	for i = 0, childCount - 1 do
		local childCtrl = fun.get_child(obj, i)
		if childCtrl and func then
			func(childCtrl, i)
		end
	end
end

function fun.set_child_layer(obj,layername)
	fun.set_layer_name(obj,layername)
	for i=0,fun.get_child_count(obj)-1 do
		local child = fun.get_child(obj,i)
		if(fun.get_child_count(child)>0) then
			fun.set_child_layer(child,layername)
		else
			fun.set_layer_name(child,layername)
		end
	end
end
function fun.clear_all_child(parent)
	local list = {}
	for i = 1, fun.get_child_count(parent) do
		table.insert(list,fun.get_child(parent,i-1))
	end
	for i, v in pairs(list) do
		Destroy(v)
	end
end
--set obj parent
--isInitPos=是否对其坐标到父物体
function fun.set_parent(obj,parent,isInitPos)
	if fun.is_null(obj) then
		log.r("set parent fail. obj is null")
		return
	end
	if parent==nil or fun.is_null(parent)  then
		obj.transform:SetParent(nil)
	else
		obj.transform:SetParent(parent.transform)
		if(isInitPos) then
			--LuaFramework.ToLuaUtil.SetLocalPos(obj,0,0,0)
			--LuaFramework.ToLuaUtil.SetLocalScale(obj,1,1,1)
			obj.transform.localScale = Vector3.one
			obj.transform.localPosition = Vector3.zero
		end
	end
end

--set obj name
function fun.set_name(obj,name)
	obj.transform.name = name
end

function fun.set_tag_name(obj,tagName)
	obj.gameObject.tag = tagName
end

--设置物体层级
function fun.set_layer_name(obj,layerName)
	if fun.is_null(obj) then
		log.r("set layer fail. obj is null")
		return
	end
	obj.gameObject.layer = UnityEngine.LayerMask.NameToLayer(layerName)
end

-------静态方法

function DestroyImmediate(go,time)
	if time then
		UnityEngine.Object.Destroy(go.gameObject,time)
	else
		if(go and go.gameObject)then
			UnityEngine.Object.DestroyImmediate(go.gameObject)
		end
	end
end

function Destroy(go,time)
	if fun.is_null(go) then
		return
	end

	if time then
		--log.g("Destroy:"..go.name.." time:"..time)
		UnityEngine.Object.Destroy(go.gameObject,time)
	else
		if(go and go.gameObject)then
			--log.g("Destroy:"..go.name)
			UnityEngine.Object.Destroy(go.gameObject)
		end
	end
end

function JsonToTable(text)
	if text == "" then
		return {}
	else
		return json.decode(text)
	end
end

function TableToJson(t)
	return json.encode(t)
end

function SaveFile(path,data)
	if type(data) ~= 'string' then
		data = TableToJson(data)
	end
	--json_util.file_save(path,data)
	--WriteFiles.WriteFrameToFile(data)
	WriteFiles.WriteStringToFile()
end

-- --读取一个resource的sprite文件
-- function LoadSprite(path)
-- 	return UnityEngine.Resources.Load(path,typeof(UnityEngine.Sprite))
-- end

-- function LoadTexture(path)
-- 	return UnityEngine.Resources.Load(path,typeof(UnityEngine.Texture))
-- end

-- --读取一个resource文件，转为type
-- function LoadResource(path,type_string)
-- 	return UnityEngine.Resources.Load(path,typeof(type_string))
-- end

function LoadFile(path)
	log.y(path)
	return Util.ReadCryptedFileText(path)
end

function LoadJson(path)
    local text = LoadFile(path)
    if text and #text>0 then
        return json.decode(text)
	end
end

--获取table长度
function GetTableLength(tab)
	if tab == nil then
		return 0
	end
	local index = 0
	for i,v in pairs(tab) do
		index = index+1
	end
	return index
end

--从1970-1-1，0：0：0至今的毫秒数
function now_millisecond()
	--暂时屏蔽 by LwangZg
--[[ 	if Util.NowMillisecond ~= nil then
		return Util.NowMillisecond()
	end ]]
    return 0
end

function child(str)
	return transform:FindChild(str)
end

--深度拷贝
function DeepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function Split(s, sp)  

	if(type(s)~="string")then 
		return 
	end

    local res = {} 
    local temp = s  
    local len = 0  
    while true do  
        len = string.find(temp, sp)  
        if len ~= nil then  
            local result = string.sub(temp, 1, len-1)  
            temp = string.sub(temp, len+1)  
            table.insert(res, result)  
		else
			if type(temp) ~= 'string' or #temp > 0 then
				table.insert(res, temp)
			end
			
            break  
        end  
    end  
  
    return res  
end

function IsValueInList(value, array)
	for _, v in ipairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

function IsValueInTable(value, tbl)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

--模拟c# INVOKE函数,time单位是秒。scale false 采用deltaTime计时，true 采用 unscaledDeltaTime计时
function Invoke(func,time,scale)

	if(func and type(func)=="function" and time and type(time)=="number")then 
	--log.r("注意，Invoke与Lua的闭包规则不兼容，也即Invoke的执行的函数，不能访问其外面的局部变量。")
		if not scale then scale = false end
		tim = Timer.New(func,time,1,scale)	
		tim:Start()
		return tim
	else
		log.r("func or time type error")
	end


end


-- 循环调用func time=间隔时间 loop=循环次数 loop=-1无限循环
-- 模拟c# INVOKE函数
function InvokeRepeat(func,time,loop)
	loop = loop or -1
	tim = Timer.New(func,time,loop,true)	
	tim:Start()
	return tim
end

-- 判断浮点数相等
function math.equal(a,b)
	return (math.abs(a-b) < 0.000001)
end

function fun.play_animator(go, animator_name,is_from_beginning)
	if fun.is_null(go) then
		log.r("play animator failed. animator is null")
		return
	end
	local animator = fun.get_component(go,fun.ANIMATOR)
	if(animator and animator.Play and animator.Update)then
		animator.enabled = true
		--log.r("play_animator",go.name,animator_name)
		if is_from_beginning then
			animator:Play(animator_name,-1,0)
			animator:Update(0);
		else
			animator:Play(animator_name);
		end

	end
end


function fun.format_float(num)
	local data = string.format("%.1f", num)
end


--格式化千位分隔符
function fun.format_money(num)
	local formatted = tostring(num)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	return formatted
end

--格式化时间为xx:xx,大于一小时时显示xx:xx:xx
function fun.format_time(second)
	local hour = math.floor(second/60/60)
	if hour == 0 then
	 	return string.format("%02d:%02d",math.floor(second/60),second%60)
	elseif hour < 24 then
		return string.format("%02d:%02d:%02d",hour,math.floor((second/60)%60),second%60)
	elseif hour < 24 * 30 then
		return string.format("%02dd:%02dh",math.floor(hour/24),hour%24)
	elseif hour < 24 * 30 * 12 then
		return string.format("%02dm:%02dd:%02dh",math.floor(hour/(24 * 30)),(hour%(24 * 30))/24,(hour%(24 * 30))%24)
	else
		return string.format("%02dy:%02dm:%02dd",math.floor(hour/(24 * 365)),(hour%(24 * 365))/(24 * 30),((hour%(24 * 365))%(24 * 30))/24)
	end
end

function fun.format_time_day(seconds)
	local day = math.floor(seconds/60/60/24)
	return day
end

function fun.format_time_hour(seconds)
	local hour = math.floor(seconds/60/60)
	return hour
end

function fun.format_time_minute(seconds)
	local minute = math.floor(seconds/60)
	return minute
end

function fun.format_percent(num)
	if type(num) == "number" then
		return tostring(num*100) .. "%"
	else
		log.r("format_percent 参数类型错误 num应该是数字",num)
		return 0
	end
end

function fun.format_price(num)
	if type(num) == "number" then
		return "$" .. tostring(num)
	else
		log.r("format_price 参数类型错误 num应该是数字",num)
		return 0
	end
end

function fun.format_vip_points(num)
	if type(num) == "number" then
		return "+" .. fun.format_money(num) .. " VIP POINTS"
	else
		log.r("format_vip_points 参数类型错误 num应该是数字",num)
		return 0
	end
end

function fun.format_key_count(num)
	if type(num) == "number" then
		return "X"..fun.format_money(num)
	else
		log.r("format_key_count 参数类型错误 num应该是数字",num)
		return 0
	end
end

local cfg = 
{
	[1] = {1000000000, "B"},
	[2] = {1000000, "M"},
	[3] = {1000, "K"},
}



--将数字格式化为以“B/M/K”单位结尾
function fun.format_number(digit, onlyInt)
	digit = tonumber(digit)
	for k,v in ipairs(cfg) do
		if digit >= v[1] then
			if onlyInt then
				return math.floor(digit / v[1]) .. v[2]
			else
				local ret_digit = math.floor((digit / v[1]) * 10)
				return (ret_digit / 10) .. v[2]
				--[[
				local ret_num = ret_digit - ret_digit % 0.1 -- tonumber(string.format("%0.1f", ret_digit)) 去掉四舍五入
				if(ret_num == math.floor(ret_digit)) then
					return math.floor(ret_digit)..v[2]
				else
					return ret_num..v[2]
				end
				--]]
			end
		end
	end

	if onlyInt then
		return math.floor(digit)
	else
		return tonumber(string.format("%.1f", digit))
	end
end

function fun.format_bonus_number(digit, onlyInt)
	digit = tonumber(digit)
	for k,v in ipairs(cfg) do
		if digit >= v[1] then
			local ret_digit = digit / v[1]
			local ret_num = 0
			if ret_digit >= 10 then
				ret_num = math.modf(ret_digit)
			else
				ret_num = tonumber(string.format("%.1f", ret_digit))
			end

			return ret_num..v[2]
		end
	end

	if onlyInt then
		return math.floor(digit)
	else
		return tonumber(string.format("%.1f", digit))
	end


end



--根据积分获得当前段位table 三个字段 id paragraph integral（0开始）
function fun.get_paragraph_id(integral)
	local paragraphs = StaticData.get_paragraph_list()
	
	for i=1,#paragraphs do
		if integral<paragraphs[i].integral then
			return paragraphs[i]
		end
	end
	
	return paragraphs[#paragraphs]
end

--根据玩家id获取下一个段位
function fun.get_next_paragraph(id)
	local paragraphs = StaticData.get_paragraph_list()
	return paragraphs[id+1]
end

--获取下一点体力恢复时间
function fun.get_next_energy_revive_time(next_energy)
	local energies = StaticData.get_energy_list()
	return energies[next_energy+1].second --因为insert导致下标从1开始了
end

--根据服务器的下一点体力恢复时间计算出上一点体力恢复到现在所经过的时间
--例：服务器返回当前三点体力，下一点体力恢复时间剩余unix时间+60s 以下简称服务器时间
--3点体力恢复时间为1500s,返回值为 unix时间-（unix时间+1500-服务器时间） 是一个绝对时间
function fun.cast_energy_revive_time_to_absolute_time(energy,response_time)
	if energy ~= ENERGY_MAXIMUM then
		local n = fun.get_next_energy_revive_time(energy)
		--log.r("相对时间:"..Util.GetTimeUnix() + n - response_time)
		return os.time()-(os.time() + n - response_time)
	else
		return 0
	end
end


function fun.get_localposition(panel_obj)
	local rec = fun.get_component(panel_obj,fun.RECT)
	if fun.is_not_null(rec) then
		return rec.localPosition
	else
		return panel_obj.transform.localPosition
	end
end

function fun.get_localposition_y(obj)
	if fun.is_not_null(obj) then
		return obj.transform.localPosition.y
	else
		log.r("get_localposition_y 参数错误")
		return 0
	end
end

function fun.set_rect_local_pos(panel_obj,x,y,z)
	local rec = fun.get_component(panel_obj,fun.RECT)
	--local pos = rec.localPosition
	rec.localPosition = Vector3.New(x, y, z)
end

function fun.set_rect_local_pos_x(panel_obj,x)
	local rec = fun.get_component(panel_obj,fun.RECT)
	local pos = rec.localPosition
	rec.localPosition = Vector3.New(x, pos.y, pos.z)
end

function fun.set_rect_local_pos_y(panel_obj,y)
	local rec = fun.get_component(panel_obj, fun.RECT)
	local pos = rec.localPosition
	rec.localPosition = Vector3.New(pos.x, y, pos.z)
end

function fun.set_rect_local_pos_z(panel_obj,z)
	local rec = fun.get_component(panel_obj,fun.RECT)
	local pos = rec.localPosition
	rec.localPosition = Vector3.New(pos.x, pos.y, z)
end

--设置坐标偏移
function fun.set_rect_offset_local_pos(panel_obj, x, y, z)
	x = x or 0
	y = y or 0
	z = z or 0
	local rec = fun.get_component(panel_obj,fun.RECT)
	local pos = rec.localPosition
	rec.localPosition = Vector3.New(pos.x + x, pos.y + y, pos.z + z)
end

function fun.get_rect_delta_size(panel_obj,z)
	local rec = fun.get_component(panel_obj,fun.RECT)
	return rec.sizeDelta
end

function fun.set_rect_anchored_position_x(panel_obj,x)
	local rec = fun.get_component(panel_obj,fun.RECT)
	local position = rec.anchoredPosition
	rec.anchoredPosition = Vector3.New(x, position.y, position.z)
end

function fun.set_rect_anchored_position_y(panel_obj,y)
	local rec = fun.get_component(panel_obj,fun.RECT)
	local position = rec.anchoredPosition
	rec.anchoredPosition = Vector3.New(position.x, y , position.z)
end

function fun.set_rect_anchored_position(go, x, y)
	local rec = fun.get_component(go, fun.RECT)
	local position = rec.anchoredPosition
	rec.anchoredPosition = Vector2.New(x, y)
end

function fun.set_rect_anchored_position_ex(go, v)
	local rec = fun.get_component(go, fun.RECT)
	local position = rec.anchoredPosition
	rec.anchoredPosition = v;
end


function fun.get_rect_anchored_position(go)
	local rect = fun.get_component(go, fun.RECT)
	return rect.anchoredPosition
end

function fun.get_rect_worldPos(rectGo)
	local result = Vector3.New(0,0,0)
	local temp = rectGo.transform
	while temp do
		if fun.is_not_null(temp.parent) then
			result = result + temp.parent.rotation * temp.localPosition
			temp = temp.parent
		else
			break
		end
	end
	return result
end

function fun.set_same_position_with(change_go, target_go)
	if target_go and not fun.is_null(target_go) and change_go and not fun.is_null(change_go) then
		change_go.transform.position =  target_go.transform.position
	end
end

function fun.set_same_position_x(change_go, target_go)
	if target_go and not fun.is_null(target_go) and change_go and not fun.is_null(change_go) then
		local pos = change_go.transform.position
		local targetX = target_go.transform.position.x
		change_go.transform.position = Vector3.New(targetX, pos.y, pos.z)
	end
end

function fun.set_same_position_y(change_go, target_go)
	if target_go and not fun.is_null(target_go) and change_go and not fun.is_null(change_go) then
		local pos = change_go.transform.position
		local targetY = target_go.transform.position.y
		change_go.transform.position = Vector3.New(pos.x, targetY, pos.z)
	end
end

function fun.set_same_position_z(change_go, target_go)
	if target_go and not fun.is_null(target_go) and change_go and not fun.is_null(change_go) then
		local pos = change_go.transform.position
		local targetZ = target_go.transform.position.z
		change_go.transform.position = Vector3.New(pos.x, pos.y, targetZ)
	end
end

function fun.set_same_world_scale_with(change_go, target_go)
	if change_go.transform.lossyScale.x ~= 0 and change_go.transform.lossyScale.y~=0 then
		local x =  target_go.transform.lossyScale.x / change_go.transform.lossyScale.x
		local y =  target_go.transform.lossyScale.y / change_go.transform.lossyScale.y
		local temp = change_go.transform.localScale
		change_go.transform.localScale =  Vector3.New(temp.x*x,temp.y*y,temp.z)
	end
end

function fun.set_same_position_with_but_z_zero(change_go, target_go)
	if fun.is_not_null(change_go) and fun.is_not_null(target_go) then
		change_go.transform.position =  target_go.transform.position
		local pos = change_go.transform.localPosition
		change_go.transform.localPosition = Vector3.New(pos.x, pos.y, 0)
	end
end

function fun.set_same_rotation_with(change_go,target_go)
    change_go.transform.eulerAngles =  target_go.transform.eulerAngles
end

function fun.set_rect_pivot(go, pivotX, pivotY)
	local rect = fun.get_component(go.gameObject, fun.RECT)
	rect.pivot = Vector2.New(pivotX, pivotY)
end

-- 合并array
function fun.merge_array(base_array,...)
	if type(base_array)~="table" then log.r("合并array错误:base_array不是table",type(base_array)) return end
	local args={...}
	for key, value in pairs(args) do
		if type(value)=="table" then
			for k, v in pairs(value) do
				if type(k) == "string" then
					base_array[k] = v
				else
					table.insert(base_array,v)
				end
			end
		else
			log.r("合并array错误:子array不是table,跳过",type(value),value)
		end
	end
	return base_array
end

-- 合并table(相同key覆盖value)
function fun.merge_table(base_table, ...)
	if type(base_table)~="table" then log.r("合并table错误:base_table不是table",type(base_table),base_table) return end
	local args={...}
	for i,tab in ipairs(args) do
		if type(tab)=="table" then
			for k,v in pairs(tab) do
				base_table[k]=v
			end
		else
			log.r("合并table错误:子table不是table,跳过",type(tab),tab)
		end
	end
	return base_table
end

--合并table （两个table元素都为1，2，等开始的）
function fun.add_table(base_table,...)
	if type(base_table)~="table" then log.r("合并table错误:base_table不是table",type(base_table),base_table) return end
	local args={...}
	local index=#base_table
	for i,tab in ipairs(args) do
		if type(tab)=="table" then
			for k,v in pairs(tab) do
				index=index+1
				base_table[index]=v
			end
		else
			log.r("合并table错误:子table不是table,跳过",type(tab),tab)
		end
	end
	return base_table
end

-- 合并table(相同key忽略value)
function fun.merge_table_ignore(base_table, ...)
	if type(base_table)~="table" then log.r("合并table错误:base_table不是table",type(base_table),base_table) return end
	local args={...}
	for i,tab in ipairs(args) do
		if type(tab)=="table" then
			for k,v in pairs(tab) do
				if base_table[k]==nil then
					base_table[k]=v
				end
			end
		else
			log.r("合并table错误:子table不是table,跳过",type(tab),tab)
		end
	end
	return base_table
end

-- 合并table(相同key value相加),
-- 注意：这里只能处理value为number类型的表
function fun.merge_table_same_key_add(...)
	local args = {...}
	if #args < 2 then
		log.r("参数不足, 合并失败")
		return
	end

	local ret = {}
	for i, tab in ipairs(args) do
		if type(tab) == "table" then
			for k, v in pairs(tab) do
				if ret[k] ~= nil then
					ret[k] = ret[k] + v
				else
					ret[k] = v
				end
			end
		else
			log.r("合并错误:第" + i + "个参数类型不批配", type(tab), tab)
			return
		end
	end
	return ret
end

function fun.insert_table_item(tbl,item)
	tbl[#tbl+1] = item
end
--删除tbl中value值为item的元素
function fun.remove_table_item(tbl,item)
	local del_item_index
	for i,v in pairs(tbl) do
		if v == item then
			del_item_index = i
			break
		end
	end
	if del_item_index then
		return table.remove(tbl,del_item_index)
	end
end

function fun.is_table_empty(t)
	if not t then return true end
	for k,v in pairs(t) do
		return false
	end
	return true
end

--[[
	将数组型的table_src拷贝到table_dst中
]]
function fun.copy_array(table_src, table_dst, from, to)
	local src_cnt = #table_src
	to = to or src_cnt
	if to <= 0 then to = src_cnt end
	if from <= src_cnt then
		for i = from, math.min(src_cnt, to) do
			table_dst[#table_dst + 1] = table_src[i]
		end
	end
end

-- 启用/禁用按钮
function fun.enable_button(button, bool)
	if not button or  fun.is_null(button) then
		log.log("按钮丢失")
		return
	end
	fun.get_component(button,fun.BUTTON).interactable = bool
end
function fun.get_button_enable(obj)
	return fun.get_component(obj,fun.BUTTON).interactable
end
-- 启用/禁用按钮(带子节点Image/Text变灰)
function fun.enable_button_with_child(button, enable)
	local btn = fun.get_component(button, fun.BUTTON)
	if btn then
		btn.interactable = enable
	end
	fun.set_color_grey(button, not enable)
	
	local child_count = fun.get_child_count(button)
	for i = 0, child_count-1 do
		local child = fun.get_child(button, i)
		if child then
			fun.set_color_grey(child, not enable)
		end
	end
end

-- 设置灰色(Image/Text)
function fun.set_color_grey(go, enable)
	local img = fun.get_component(go, fun.IMAGE)
	local txt = fun.get_component(go, fun.OLDTEXT)
	if img then
		if enable then
			img.color = Color(0.22, 0.707, 0.071, 1)
		else
			img.color = Color(1, 1, 1, 1)
		end
	elseif txt then
		if enable then
			txt.color = Color(0.22, 0.707, 0.071, 1)
		else
			txt.color = Color(1, 1, 1, 1)
		end
	end
end

function fun.print_timestamp(tag)
	tag = tag or ""
	log.r(tag.."时间戳时间："..Util.NowMillisecond())
end

-- 设置图片颜色
function fun.set_img_color(img,color)

	if(img==nil)then
		log.w("img is nil")
		return
	end

	local img = fun.get_component(img.gameObject,fun.IMAGE) or fun.get_component(img.gameObject,fun.RAW_IMAGE)
	img.color = color
end

---设置图片
function fun.set_ctrl_sprite(ctrl, sprite)
	if fun.is_null(ctrl) or fun.is_null(sprite) then
		return
	end
	
	local imageCom = fun.get_component(ctrl, fun.IMAGE)
	if fun.is_not_null(imageCom) then
		imageCom.sprite = sprite
	end
end

function fun.set_recttransform_native_size(go, width, height)
	local rect_transform = fun.get_component(go, fun.RECT)
	rect_transform.sizeDelta = Vector2.New(width, height)
end

function fun.set_recttransform_native_width(go, width)
	local rect_transform = fun.get_component(go, fun.RECT)
	local height = rect_transform.sizeDelta.y
	rect_transform.sizeDelta = Vector2.New(width, height)
end

function fun.set_recttransform_native_height(go,  height)
	local rect_transform = fun.get_component(go, fun.RECT)
	local width = rect_transform.sizeDelta.x
	rect_transform.sizeDelta = Vector2.New(width, height)
end

-- 设置透明度
function fun.set_alpha(go, alpha)
	if go and alpha then
		local img = fun.get_component(go,fun.IMAGE)
		local txt = fun.get_component(go,fun.TEXT)
		local img1 = fun.get_component(go,fun.RAW_IMAGE)
		if img then
			local c = img.color
			c.a = alpha
			img.color = c
		elseif txt then
			local c = txt.color
			c.a = alpha
			txt.color = c
		elseif img1 then 
			local c = img1.color
			c.a = alpha
			img1.color = c
		else
			log.r({"对象不存在Image或Text控件",go})
		end
	end
end

function Assert(t)
	if not t then error("断言失败，变量不能为nil") end
end
function Globe(str_name)
	if not str_name then log.r("str_name is nil") end
	local a = Split(str_name,"%.")
	local r = nil
	for i,v in ipairs(a) do
		if i==1 then 
			r = _G[v] 
		else
			r = r[v]
		end
		if not r then break end
	end
	return r
end

function GlobeState(str_name)
	if not str_name then log.r("str_name is nil") end
	local a = Split(str_name,"%.")
	local r = nil
	for i,v in ipairs(a) do
		if i==1 then 
			r = _G[v] 
		else
			r = r[v]
		end
		if not r then break end
	end

	if(r == nil)then 
		local statebase = "Machine."..str_name.."Base"
	    require(statebase)
	    r = _G[machine_state_clazz_name.."Base"]
	end 
	return r
end
--根据基准值动态增加obj所有包含canvas的sorting order
function fun.set_sorting_order_relative(obj,fiducialValue)
	return Util.SetCanvasSortingOrderRelative(obj,fiducialValue)
end

function fun.read_local_machine_setting()
	local str = Util.ReadLocalSettingTXT()
	if str then
		return JsonToTable(str)
	else
		return nil
	end
end

function fun.read_local_openid()
	local str = Util.ReadLocalOpenId()
	return str
end

function fun.change_loacal_openid(str)
	Util.ModifyLocalOpenId(str)
end
-- 强制rebuild布局
function fun.ForceRebuildLayoutImmediate(obj)
	if fun.is_null(obj) then
		log.r("RebuildLayout对象为空！")
	else
		Util.ForceRebuildLayoutImmediate(obj.gameObject)
	end
end
-- 16进制色值转Color
function fun.hex_to_color(hex)
	local c = Color.New()
	c.r = tonumber(string.sub(hex,1,2),16)/256
	c.g = tonumber(string.sub(hex,3,4),16)/256
	c.b = tonumber(string.sub(hex,5,6),16)/256
	c.a = 1
	return c
end

function fun.calc_new_position_between(start_pos, end_pos, x_factor, y_factor, z_factor)
	local x = start_pos.x + (end_pos.x - start_pos.x) * x_factor
    local y = start_pos.y + (end_pos.y - start_pos.y) * y_factor
    local z = start_pos.z + (end_pos.z - start_pos.z) * z_factor;
    return Vector3.New(x, y, z)
end

function fun.table_len(t)
	if not t then return 0 end
	local count = 0
    for k,v in pairs(t) do
        count = count + 1
	end
	return count
end

-- CSharp的List转为Lua的Table(拷贝内容数据)
function fun.list_to_table(cs_list)
	if cs_list == nil then
		log.r("list_to_table错误:源数据list不存在")
		return
	end
	local t = {}
	local count = cs_list.Count
	for i = 1, count do
		t[i] = cs_list[i-1]
	end
	return t
end

-- table内数字求总和
function fun.add_up_table(t)
	local total = 0
	for i, v in ipairs(t) do
		total = total + v
	end
	return total
end

function fun.get_num_char_count(num)
	local count = 1
	while num / 10 >=1 do
		count = count + 1
		num = num / 10
	end
	return count
end

function  fun.formate_decimal(decimal, decimal_digits)
	local int_num , decimal_num = math.modf( decimal )
	if decimal_num == 0 then
		return tostring(int_num)
	else
		local fix_decimal_num = tonumber(string.format( "%."..decimal_digits.."f",decimal_num))
		return tostring(int_num + fix_decimal_num)
	end 
end

function fun.compare(left, right, op)
	log.r(left, right, op)
	if op == fun.Op.Equal then
		return left == right
	elseif op == fun.Op.EqualOrLargeThan then
		return left >= right
	elseif op == fun.Op.EqualOrSmallThan then
		return left <= right
	end
end

function fun.table_pop_first(table_data, except_data)
	if #table_data > 0 then
		local first_validate = nil
		for i = 1, #table_data do
			local item = table_data[i]
			if first_validate == nil and item ~= except_data then
				first_validate = item
			end

			if first_validate ~= nil then
				if i < #table_data then
					table_data[i] = table_data[i + 1]
				end
			end
		end
		table_data[#table_data] = nil
		return first_validate
	else
		return nil
	end
end

function fun.tween_out_sound(hash,audio_source,update_cb,complete_cb)
    Anim.do_smooth_float_update(audio_source.volume, 0, 1,update_cb, complete_cb)
end

function fun.date()
	return os.date("%Y-%m-%d")
end

function fun.time()
	return os.date("%H:%M:%S")
end

function fun.time_to_date(timestamp)
	return os.date("%Y-%m-%d", timestamp)
end

function fun.time_to_date_2(timestamp)
	return os.date("%Y%m%d", timestamp)
end

function fun.date_with_offset(offset)
	local t = os.time() + offset
	return os.date("%Y-%m-%d", t)
end

function fun.time_with_offset(offset)
	local t = os.time() + offset
	return os.date("%H:%M:%S", t)
end

function fun.seconds_to_min(seconds)
	return seconds / 60
end

function fun.seconds_to_hour(seconds)
	return seconds / 3600
end

function fun.seconds_to_day(seconds)
	return seconds /(3600*24)
end

function fun.millisecond_to_second(millisecond)
	return millisecond/1000
end

function  fun.SecondToStrFormat( time )
	local calTime = 0
	local day = math.floor(time/86400)
	calTime = day*86400
	local hour = math.floor( (time- calTime)/3600)
	if day >0 then
		return string.format("%2dd %2dh", day, hour)
	end
	calTime = calTime + hour*3600
	local minute = math.fmod(math.floor((time-calTime)/60), 60)
	if hour >0 then
		return string.format("%2dh %2dm", hour, minute)
	end
	calTime = calTime + minute*60
	local second = math.fmod(time- calTime, 60)
	return string.format("%2dm %2ds", minute, second)
end

---时间中间没有空格
function  fun.SecondToStrFormat2( time )
	local calTime = 0
	local day = math.floor(time/86400)
	calTime = day*86400
	local hour = math.floor( (time- calTime)/3600)
	if day >0 then
		return string.format("%dd%dh", day, hour)
	end
	calTime = calTime + hour*3600
	local minute = math.fmod(math.floor((time-calTime)/60), 60)
	if hour >0 then
		return string.format("%dh%dm", hour, minute)
	end
	calTime = calTime + minute*60
	local second = math.fmod(time- calTime, 60)
	return string.format("%dm%ds", minute, second)
end

function fun.get_index(array, element)
	for i = 1, #array do
		if array[i] == element then
			return i
		end
	end
	return -1
end

function fun.select_image(obj, texture_name)
	local image_sprite_container = fun.get_component(obj, fun.IMAGESPRITESCONTAINER)
	if image_sprite_container then
		image_sprite_container:ShowSprite(texture_name)
	else
		log.r(tostring(obj).."对象上不存在图片容器ImageSpriteContainer")
	end
end

function fun.calc_distance(point1, point2)
	 local x = point1.x - point2.x
	 local y = point1.y - point2.y

	 return math.sqrt( x * x + y * y )
end

-- 在delay时间后启用button按钮
function fun.delay_enable_button(button, delay)
	button.enabled = false
	Invoke(function()
		button.enabled = true
	end, delay)
end

function fun.split_path(file, trunk)  
    local index = string.find(file, trunk)  
	if index ~= nil then  
		local prefix = string.sub(file, 1, index-1)  
		local postfix = string.sub(file, index + #trunk + 1)  
		return prefix, postfix
	else
		return  file, ""
	end
end

function fun.file_exist(file)
	local f=io.open(file,"r")
	if f~=nil then io.close(f) return true else return false end
end

function fun.remove_file(file)
	if fun.file_exist(file) then
		os.remove(file)
		log.r("remove file: "..file.." at "..now_millisecond())
	end
end

function fun.starts(src,target)
	return string.sub(src,1,string.len(target))==target
 end
 
 function fun.ends(src,target)
	return target =='' or string.sub(src,-string.len(target))==target
 end

--从如[1,0,0,1,1]字符串返回其中数字元素的表
function fun.get_nums_from_symbol(str)
	if str==nil or type(str)~="string" then return nil end
	str=string.sub(str,2,#str-1)
	local t=Split(str,",")
	for i=1,#t do
		t[i]=tonumber(t[i])
	end
	return t
end

-- -- 生成概率表
-- function fun.make_rate_table(res_table)
-- 	local rate_table = {}
-- 	-- 总权重
-- 	local total_weight = 0
-- 	for value, weight in pairs(res_table) do
-- 		total_weight = total_weight + weight
-- 	end
-- 	-- 基础概率
-- 	local base_rate = 0
-- 	for value, weight in pairs(res_table) do
-- 		-- 单项概率
-- 		local item_rate = weight / total_weight
-- 		-- 上限概率
-- 		local max_rate = base_rate + item_rate 
-- 		-- 单项数据
-- 		local item = {
-- 			value = tonumber(value),
-- 			min = base_rate,
-- 			max = max_rate,
-- 			weight = weight, -- 单项权重(供参考)
-- 		}
-- 		table.insert(rate_table, item)
-- 		-- 更新基础概率
-- 		base_rate = max_rate
-- 	end
-- 	return rate_table
-- end

-- -- 按概率表进行随机
-- function fun.random_by_rate_table(rate_table)
-- 	if type(rate_table) ~= "table" then
-- 		log.r({"概率随机报错", rate_table})
-- 		return nil
-- 	end
-- 	local rand = math.random()
-- 	local final = nil
-- 	for _,v in ipairs(rate_table) do
-- 		if rand >= v.min and rand < v.max then
-- 			final = v.value
-- 			break
-- 		end
-- 	end
-- 	if final == nil then
-- 		final = rate_table[#rate_table].value
-- 		log.r({"概率随机报错",rate_table,"默认取最后一项"})
-- 	else
-- 		log.y("随机成功 概率",rand,"结果",final,rate_table)
-- 	end
-- 	return final, rand
-- end

-- 拷贝纯数据table
function fun.copy_data(src_table)
	local t = {}
	for k,v in pairs(src_table) do
		if type(v) == "table" then
			t[k] = fun.copy_data(v)
		else
			t[k] = v
		end
	end
	return t
end

-- 生成权重表
function fun.make_weight_table(res_table)
	local weight_table = {}
	for value, weight in pairs(res_table) do
		local item = {}
		item.value = tonumber(value)
		item.weight = weight
		table.insert(weight_table, item)
	end
	return weight_table
end

-- 按权重表随机
function fun.random_by_weight_table(weight_table)
	-- 总权重
	local total_weight = 0
	for _, item in ipairs(weight_table) do
		total_weight = total_weight + item.weight
	end
	-- 随机数
	local rand = math.random(1, total_weight)
	-- 匹配
	for _, item in ipairs(weight_table) do
		rand = rand - item.weight
		if rand <= 0 then
			return item.value
		end
	end

	log.r({
		msg="按权重随机出错",
		weight_table=weight_table,
		total_weight=total_weight,
		rand=rand,
	})
end

-- 从权重表中去掉一个元素
function fun.remove_from_weight_table(weight_table, value)
	for i, item in ipairs(weight_table) do
		if item.value == value then
			table.remove(weight_table, i)
			break
		end
	end
end

function fun.is_net_reachable()
	return UnityEngine.Application.internetReachability ~= UnityEngine.NetworkReachability.NotReachable
end

-- 从启动开始计算的真实时间(不受pause影响)
function fun.get_real_time_since_startup()
	return Time.realtimeSinceStartup
end

-- 秒转换成合适的单位
function fun.seconds_to_day_hour_min(seconds, ceil)
	local value
	local suffix
	if seconds >= 3600*24 then
		value = fun.seconds_to_day(seconds)
		suffix = " day"
	elseif seconds >= 3600 then
		value = fun.seconds_to_hour(seconds)
		suffix = " hour"
	elseif seconds >= 60 then
		value = fun.seconds_to_min(seconds)
		suffix = " min"
	else
		value = seconds
		suffix = " second"
	end
	if ceil then
		value = math.ceil(value)
	else
		value = math.floor(value)
	end
	if value > 1 then
		return value .. suffix .. "s"
	else
		return value .. suffix
	end
end

-- 从PrizeInfo数组(prizes)中取出指定类型(item_type)物品的数量(count)和余额(balance)
function fun.get_item_by_type_from_prizes(prizes, item_type)
	if prizes and type(prizes) == "table" then
		for _,v in ipairs(prizes) do
			if v.type == item_type then
				return v.count, v.balance
			end
		end
	end
end

function fun.get_table_size(t)
	if t then
		local size=0
		for i,v in pairs(t) do
			size = size +1
		end
		return size
	else
		return 0
	end
end

-- 插值
function fun.lerp(from, to, t)
	local dis = to - from
	return from + dis * t
end

-- 设置组件启用
function fun.enable_component(com, enabled)
	if fun.is_null(com) then
		log.r("com is null")
		return
	end
	if com.enabled == enabled then
		return
	end
	com.enabled = enabled
end

-- 判断字符串是否为空
function string.is_empty(str)
	return str == "" or str == nil
end

-- 判断字符串是否为空
function string.toCharTable(str)
	if string.is_empty(str) then
		return {}
	end
	
	local chars = {}
	for w in string.gmatch(str, ".") do
		table.insert(chars, w)
	end
	return chars
end

function fun.get_strNoEmpty(str,default_str)
	if string.is_empty(str) then
		return default_str
	end
	return str
end

--- 判断某个值是否在table里存在
function fun.is_include(value, tbl)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

---@see 判断某个key值是否在table里存在
function fun.is_key_include(key, tbl)
	for k, v in pairs(tbl) do
		if k == key then
			return true
		end
	end
	return false
end

function fun.table_remove_at(t,index)
	 local tmp = {}
	 local ans = nil
	 for k, v in ipairs(t) do
		 if k == index then
			 ans = v
		 else
			 table.insert(tmp, v)
		 end
	 end
	return tmp,ans
end

function fun.ends(String,End)
	return End=='' or string.sub(String,-string.len(End))==End
end

function fun.isJackpot(value)
	return value == "Major"  or value == "Mini" or value == "Grand" or value == "Minor"
end

function fun.deltaTime()
	--return Time.deltaTime
    return Time.smoothDeltaTime
end
function fun.get_number_from_string(value)
	local zero =  string.byte('0')
	local nine =  string.byte('9')
	local ans = ""
	for i = 1, string.len(value) do
		local num = string.byte(value,i)
		if num>=zero and num<=nine then
			ans = ans..string.sub(value,i, i)
		end
	end
	return ans
end

function fun.FormatTime(time)
    local hour = math.floor(time/3600)
    local minute = math.fmod(math.floor(time/60), 60)
    local second = math.fmod(math.floor(time), 60)
    
	return hour or 0 , minute or 0, second or 0
end

function fun.SetSmoothCanvasGroup(go,time,beginValue,toValue)
	if(go)then 
		local canvansGroup = fun.get_component(go,fun.CANVAS_GROUP)
		if(canvansGroup)then 
			canvansGroup.alpha = beginValue
			Anim.do_smooth_float_update(beginValue,toValue,time,function(num)
				canvansGroup.alpha = num
			end,function()
				canvansGroup.alpha = toValue
			end) 
		else
			log.r("没有canvasGroup")
		end
	end
end

function fun.TweenTargetIn(target_obj)
	local target_transform = target_obj.transform
    target_transform.localScale = Vector3.zero
    target_transform:DOScale(Vector3.one, showDeltaTime):SetEase(DG.Tweening.Ease.OutBack)
end

function fun.TweenTargetOut(target_obj, closeFunc)
	local target_transform = target_obj.transform
    target_transform.localScale = Vector3.one
    target_transform:DOScale(Vector3.zero, hideDeltaTime):SetEase(DG.Tweening.Ease.InBack):OnComplete(function()
		if closeFunc then
			closeFunc()
		end
		fun.set_active(target_obj, false)
    end)
end

function fun.IsEditor()
	if(fun._is_editor==nil)then
		fun._is_editor = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor

	end
	return fun._is_editor
end

--处理消息参数
local select = select
local insert = table.insert

function HandleNotifyParams(...)
    local view, args = nil, {};
    local count = select('#', ...);
    for index = 1, count do
        if index == 1 then view = select(1, ...);
        else
            local tempArg = select(index, ...);
            insert(args, index - 1, tempArg);
        end
    end
    return view, args;
end

function fun.CreatAverageLoopFunc(start_value , end_value , time, loop_func, end_func)
	local func = Anim.do_smooth_float_update_average(start_value, end_value, time,
    function(num)
		if loop_func then
			loop_func(num)
		end
    end,
    function()
		if end_func then
			end_func()
		end
	end)
	return func
 
end

function fun.BindBtnClickEvent(btn_obj,clickCall,longCall,downCall,upCall)
    local btn = btn_obj:GetComponent(fun.BUTTON_EVENT)

	btn:RegClickCallback(function()
		if clickCall then
			clickCall()
		end
    end)

	btn:RegLongPressCallback(function()
		if longCall then
			longCall()
		end
    end)

    btn:RegDownCallBack(function()
		if downCall then
			downCall()
		end
    end)
    btn:RegUpCallBack(function()
		if upCall then
			upCall()
		end
    end)
end 

--[[
    @desc: 将string转成bool   ,"true" --true  
    author:{author}
    time:2020-11-23 14:52:06
    --@str:
	--@defaultValue: 
    @return:
]]
function fun.GetBool(str,defaultValue)
	local ret = defaultValue or false 
	local defStr = str 
	if(not defStr or #defStr == 0)then 
		return ret
	end
	local defStr = string.lower(defStr)
	if(defStr == "false")then 
		return false 
	end
	if(defStr == "true")then 
		return true 
	end
end

function fun.starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
 end
 
 function fun.ends(String,End)
	return End=='' or string.sub(String,-string.len(End))==End
 end
 
 --将数字格式化为以“B/M/K”单位结尾
 function fun.format_filesize(digit, onlyInt)
	 digit = tonumber(digit)
	 local ret_digit = digit / 1024
	 local ret_num = tonumber(string.format("%0f", ret_digit))
	 return math.floor(ret_num)
  
 end



function fun.PhoneHasBottomLine()
	-- 这两个型号表示IphoneX
	local deviceModel = SystemInfo.deviceModel;
	if deviceModel == "iPhone10,3" or deviceModel == "iPhone10,6" then
		return true;
	end
	
	local strs = Split(deviceModel, ",");
	if nil ~= strs and #strs > 0 then
		local _start, _end = string.find(strs[1], "iPhone");
		if nil ~= _end then
			local iphoneIndex = tonumber(string.sub(strs[1], _end + 1));
			if iphoneIndex > 10 then	-- >10表示IphoneX以上
				return true;
			end
		end
	end

	return false;
end

function fun.GetAnimatorTime(animator,animation_name)
	local clips = animator.runtimeAnimatorController.animationClips;
	local time_length = nil
	for i = 0, clips.Length-1 do
		if clips[i].name == animation_name then
			time_length = clips[i].length
		end
	end
	return time_length
end

function fun.GetAnimatorClip(animator, animation_name)
	if fun.is_null(animator) or string.is_empty(animation_name) then
		return
	end
	
	local clips = animator.runtimeAnimatorController.animationClips
	for i = 0, clips.Length - 1 do
		if clips[i].name == animation_name then
			return clips[i]
		end
	end
end

function fun.FindAnimatorClip(animator, nameKeyList)
	if fun.is_null(animator) or #nameKeyList == 0 then
		return
	end
	if fun.is_null(animator.runtimeAnimatorController) then
		return
	end
	local clips = animator.runtimeAnimatorController.animationClips
	for i = 0, clips.Length - 1 do
		local clipName = string.lower(clips[i].name)
		for k = 1, #nameKeyList do
			if string.find(clipName, nameKeyList[k]) then
				return clips[i]
			end
		end
	end
end

--设置名字(带有头像框的名字栏使用,个人信息除外)
function fun.get_player_name(name , limit_name_num)
	local length = fun.get_str_length(name)
	local current_str = ""
	if length > limit_name_num then
		current_str = string.sub(name,1,limit_name_num) .. "..."
	else
		current_str = name
	end
	return current_str
end

function fun.TransformTimeToTxt(_remainTime)
	if _remainTime and _remainTime > 0 then
      
        local d = math.floor(_remainTime/60/60/24)
        local h = math.floor(_remainTime/60/60%24)
        local m = math.floor(_remainTime/60%60)
        local s = math.floor(_remainTime%60)
        if d > 0 then
            if d > 1 and h > 1 then
                return string.format("%sD%sH",d,h)
            elseif d > 1 and h == 1 then
                return string.format("%sD%sH",d,h)
            elseif d > 1 and h == 0 then
                return string.format("%sD%02d:%02d",d,m,s)
            elseif d == 1 and h > 1 then
                return string.format("%sD%s:%02d",d,h,m)
            elseif d == 1 and h == 1 then
                return string.format("%sD%s:%02d",d,h,m)
            elseif d == 1 and h > 1 then
                return string.format("%sD%sH%02d",d,h,m)
            end
        elseif h > 1 then
            return string.format("%s:%02d:%02d",h,m,s)
        elseif h == 1 then
            return string.format("%s:%02d:%02d",h,m,s)
        else
            return string.format("00:%02d:%02d",m,s)
        end    
    end
end

--字符数量
function fun.get_str_length(str)
	local lenInByte = #str
    local width = 0
    local i = 1
    while (i<=lenInByte) 
    do
		local curByte = string.byte(str, i)
        local byteCount = 1;
		if curByte>0 and curByte<=127 then
            byteCount = 1                                           --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                           --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                           --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                           --4字节字符
        end

        i = i + byteCount                                 -- 重置下一字节的索引
        width = width + 1                                 -- 字符的个数（长度）
	end
    return width
end

function CleanTable(tableData)
	if(tableData and type(tableData)=="table")then 
		for k,v in pairs(tableData) do
			tableData[k] = nil 
		end
	end
	tableData = nil 
end

function deep_copy(obj)
	local lookup_table = {}
	local function _copy(obj)
		if type(obj) ~= "table" then
			return obj
		elseif lookup_table[obj] then
			return lookup_table[obj]
		end
		local new_table = {}
		lookup_table[obj] = new_table
		for index, value in pairs(obj) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(obj))
	end
	return _copy(obj)
end


function fun.formatNum( numTmp )
	numTmp = tonumber(numTmp)
	local resultNum = numTmp
	if type(numTmp) == "number" then
		local inter, point = math.modf(numTmp)

		local strNum = tostring(inter)
		local newStr = ""
		local numLen = string.len( strNum )
		local count = 0
		for i = numLen, 1, -1 do
			if count % 3 == 0 and count ~= 0  then
				newStr = string.format("%s,%s",string.sub( strNum,i,i),newStr)
			else
				newStr = string.format("%s%s",string.sub( strNum,i,i),newStr)
			end
			count = count + 1
		end

		if point > 0 then
			--@desc 存在小数点，
			local strPoint = string.format( "%.2f", point )
			resultNum = string.format("%s%s",newStr,string.sub( strPoint,2, string.len( strPoint )))
		else
			resultNum = newStr
		end
	end
	--log.r("resultNum  "..resultNum)
	return resultNum
end

--给数字串插入逗号（产生好多内存碎片）
function fun.NumInsertComma(num)
	local str_comma = ""
	local str_tail = ""
	if type(num) == "number" or type(num) == "string" then
		local str_num = tostring(num)
		local len = string.len(str_num)
		local str_index =  nil
		local ascll = string.byte(str_num,len)
		if ascll < 48 or ascll > 57 then
			local linex = 0
			for i = len, 1,-1 do
				ascll = string.byte(str_num,i)
				if ascll >= 48 and ascll <= 57 then
					break
				end
				linex = i
			end
			str_tail = string.sub(str_num,linex)
			str_num = string.sub(str_num,1,math.max(1,len - (len - linex) - 1))
			len = string.len(str_num)
		end
		while true do
			if str_comma ~= "" then
				str_comma = "," .. str_comma
			end
			str_index = math.max(1,len - 2)
			str_comma = string.sub(str_num,str_index,math.min(str_index + 2,len)) .. str_comma
			if str_index == 1 then
				break
			end
			len = len - 3
		end
	end
	return str_comma .. str_tail
end

function fun.FormatText(data)
	local text = nil
	if (data.id and data.id  == Resource.hintTime ) or  (data[1] and data[1] == Resource.hintTime) then
		---放大镜数量转化成时间
		local ti = data.value or data[2]
		local hrs = math.floor(ti / 3600)
		if hrs > 0 then
			text = fun.NumInsertComma(hrs) .. " HRS"
		else
			local min = math.floor(ti / 60)
			if min > 1 then
				text = fun.NumInsertComma(min) .. " Mins"
			else
				text = fun.NumInsertComma(min) .. " Min"
			end
		end
	elseif (data.id and data.id  == Resource.dailycoins_bonus ) or  (data[1] and data[1] == Resource.dailycoins_bonus) then
		text = string.format("%s%s%s", "+" ,data.value or data[2] , "%")
	else
		text = fun.format_number(data.value or data[2])
	end
	return text
end

function fun.FormatTextToTime(value)
	local text = nil

	local ti = value or 0
	local hrs = math.floor(ti / 3600)
	if hrs > 0 then
		text = hrs .. "hrs"
	else
		local min = math.floor(ti / 60)
		if min > 1 then
			text = min .. "mins"
		elseif min == 1 then
			text = min .. "min"
		elseif ti > 0 then
			text = ti .. "s"
		else
			text = "0s"
		end
	end

	return text
end


function fun.FormatTextToTimeReplace(value)
	local textValue = nil
	local textTime = nil
	local ti = value or 0
	local hrs = math.floor(ti / 3600)
	local min = math.floor(ti / 60)
	if hrs > 0 then
		if hrs == 1 then
			textValue = min
			textTime = "Minutes"
		else
			textValue = hrs
			textTime = "Hours"			
		end
	else
		if min > 1 then
			textValue = min
			textTime = "Minutes"
		elseif min == 1 then
			textValue = min
			textTime = "Minute"
		elseif ti > 0 then
			textValue = ti
			textTime = "S"
		else
			textValue = ti
			textTime = "S"
		end
	end

	return textValue , textTime
end

function fun.GetGpuInfo()
	local info = {renderer = SystemInfo.graphicsDeviceName,  vender = SystemInfo.graphicsDeviceVendor}
	return TableToJson(info)
end

function fun.GetRamInfo()
	local info = {total = SystemInfo.systemMemorySize,  vender = SystemInfo.graphicsDeviceVendor}
	return TableToJson(info)
end

function fun.get_network()
	if UnityEngine.Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork  then
		return "3g_4g_5g"
	elseif UnityEngine.Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork then
		return "wifi"
	end
	return ""
end

-- table 去重
function fun.table_unique(t)
	local check = {};
	local n = {};
	for key , value in pairs(t) do
		if not check[value] then
			n[key] = value
			check[value] = value
		end
	end
	return n
end

function fun.format_reward(reward)
	if (reward.id and reward.id < 100 ) or  (reward[1] and reward[1] < 100) then
		if (reward.id and reward.id  == Resource.hintTime ) or  (reward[1] and reward[1] == Resource.hintTime) then
			---放大镜数量转化成时间
			local ti = reward.value or reward[2]
			local hrs = math.floor(ti / 3600)
			if hrs > 0 then
				return fun.NumInsertComma(hrs) .. " HRS"
			else
				local min = math.floor(ti / 60)
				return fun.NumInsertComma(min) .. " Min"
			end
		else
			return fun.format_number(reward.value or reward[2])
		end
	else
		return fun.NumInsertComma(reward.value or reward[2]) 
	end
end

function fun.format_money_reward(reward)
	if (reward.id and reward.id < 100 ) or  (reward[1] and reward[1] < 100) then
		if (reward.id and reward.id  == Resource.hintTime ) or  (reward[1] and reward[1] == Resource.hintTime) then
			---放大镜数量转化成时间
			local ti = reward.value or reward[2]
			local hrs = math.floor(ti / 3600)
			if hrs > 0 then
				return fun.NumInsertComma(hrs) .. " HRS"
			else
				local min = math.floor(ti / 60)
				return fun.NumInsertComma(min) .. " Min"
			end
		else
			return fun.format_money(reward.value or reward[2])
		end
	else
		return fun.format_money(reward.value or reward[2]) 
	end
end


function fun.format_money_reward_v2(reward)
	if (reward.id and reward.id < 100 ) or  (reward[1] and reward[1] < 100) then
		if (reward.id and reward.id  == Resource.hintTime ) or  (reward[1] and reward[1] == Resource.hintTime) then
			---放大镜数量转化成时间
			local ti = reward.value or reward[2]
			local hrs = math.floor(ti / 3600)
			if hrs > 0 then
				return fun.NumInsertComma(hrs) .. " HRS"
			else
				local min = math.floor(ti / 60)
				return fun.NumInsertComma(min) .. " Min"
			end
		else
			if(reward.type == "kmb")then 
				return fun.format_number(reward.value or data[2])
			else
				return fun.format_money(reward.value or reward[2])
			end
			
		end
	else
		if(reward.type == "kmb")then 
			return fun.format_number(reward.value or data[2])
		else
			return fun.format_money(reward.value or reward[2]) 
		end
		
	end
end

--判断是亚马逊卡
function fun.CheckIsAmazonCard(itemId)
	if itemId == 1048 or itemId == 1049 or itemId == 1050 or itemId == 1108 or itemId == 1109 then
		return true
	end
	return false
end

-- 获取亚马逊卡描述
function fun.GetAmazonCardDescription(itemId)


	if fun.is_android_platform() then 
		if itemId == 1050 then
			return "VIP"
		elseif itemId == 1049 then
			return "VIP"
		elseif itemId == 1048 then
			return "VIP"
		elseif itemId == 1108 then
			return "VIP"
		elseif itemId == 1109 then
			return "VIP"
		end
	else
		if itemId == 1050 then
			return "$50"
		elseif itemId == 1049 then
			return "$100"
		elseif itemId == 1048 then
			return "$200"
		elseif itemId == 1108 then
			return "$30"
		elseif itemId == 1109 then
			return "$10"
		end
	end
	return ""
end

--转换千分号
function fun.TransitionNet(num) --转换一千
	local tmpNum = 0 
	
	if num >= 10 and 100 > num then
		local tmp = num /10 
		tmpNum = fun.NewRound(tmp) * 10
	elseif num >= 100 and 1000 > num then 
		local tmp = num /10
		tmpNum = fun.NewRound(tmp) * 10
	elseif num >= 1000 and 10000 > num then 
		local tmp = num /100
		tmpNum = fun.NewRound(tmp) * 100
	elseif num >= 10000 and 100000 > num then 
		local tmp = num /1000
		tmpNum = fun.NewRound(tmp) * 1000
	elseif num <10 then 
		tmpNum =10
	else 
		local tmp = num /1000
		tmpNum = fun.NewRound(tmp) * 1000
	
	end 

	return tmpNum
end 

function fun.NewRound(decimal)
	local decimal = math.floor(decimal+0.5)  --不保留整数100
	return decimal;
end

function fun.isString(value)
	return type(value) == "string"
end

function fun.isNumber(value)
	return type(value) == "number"
end

function fun.isFunction(value)
	return type(value) == "function"
end

function fun.isValidCfgString(str)
	return not fun.is_empty_str(str) and str ~= "0"
end

---------------------------------------- table拓展 ----------------------------------------begin

---遍历table里的每一个元素
---@param func table 对每一个元素的操作
function table.each(tb, func)
	if not tb or not func then
		return
	end

	for key, value in pairs(tb) do
		func(value, key)
	end
end

---从table取得所有符合条件的元素
---@param func table 查找条件
function table.findAll(tb, func)
	if not tb or not func then
		return
	end

	local ret = {}
	for key, value in pairs(tb) do
		if func(key, value) then
			table.insert(ret, value)
		end
	end
	return ret
end

---从table随机取得元素
---@param func table 元素需要符合的条件
function table.randomValue(tb, func)
	if fun.table_len(tb) == 0 then
		return
	end

	local keys = {}
	for key, value in pairs(tb) do
		if func and type(func) == "function" then
			if func(key, value) then
				table.insert(keys, key)
			end
		else
			table.insert(keys, key)
		end
	end

	if fun.table_len(keys) == 0 then
		return
	end
	
	local randomKey = keys[math.random(1, #keys)]
	local ret = tb[randomKey]
	return ret
end

function table.groupBy(tb, func)
	local group_func, result = func, {}

	if fun.isString(func) then
		group_func = function(k, v)
			return v[func]
		end
	end

	table.each(tb, function(v, k)
		local key = group_func(v, k)
		result[key] = result[key] or {}
		table.insert(result[key], v)
	end)

	return result
end

--- 获取table中所有value
function table.values(tb, func)
	local values = {}
	if not tb then
		return values
	end

	for k, v in pairs(tb) do
		values[#values + 1] = func and func(k, v) or v
	end
	return values
end

--- 反转Table
function table.reverse(tb)
	local length = fun.table_len(tb)
	for i = 1, length / 2, 1 do
		tb[i], tb[length - i + 1] = tb[length - i + 1], tb[i]
	end
	return tb
end

--- 打印table
function table.print(tb)
	local str
	table.each(tb, function(v)
		if type(v) ~= "function" and type(v) ~= "table" then
			if not str then
				str = tostring(v)
			else
				str = string.format("%s, %s", str, tostring(v))
			end
		end
	end)
	return str
end

---------------------------------------- table拓展 ----------------------------------------end

---------------------------------------- 扩展类的功能 ----------------------------------------begin
fun.ExtendFunction = {
	mutual = "mutual",
}

function fun.ExtendClass(Cls, funcName)
	if funcName == fun.ExtendFunction.mutual then
		fun.ImplementMutualTask(Cls)
	end
end

function fun.ImplementMutualTask(Cls)
	function Cls:DoMutualTask(task)
		if self.mutualTaskExecuting then
			return
		end
		self.mutualTaskExecuting = true
		task()
	end

	function Cls:MutualTaskFinish()
		self.mutualTaskExecuting = false
	end

	function Cls:ClearMutualTask()
		self.mutualTaskExecuting = false
	end
end
---------------------------------------- 扩展类的功能 ----------------------------------------end

function fun.GetPlayerAndDeviceCode()
	local playerCode, deviceCode
	local filePath = string.gsub(UnityEngine.Application.dataPath, "/Assets", "") .. "/tool/loginconfig"
	if fun.file_exist(filePath) then
		local file = assert(io.open(filePath, "rb"))
		local line = file:read("*line")
		while line do			
			if fun.starts(line, "#") then
				--注释
			elseif fun.starts(line, "KEY:") then
				local content = string.sub(line, 5)
				if content and #content > 0 then
					playerCode = content
				end
			elseif fun.starts(line, "DEVICE:") then
				local content = string.sub(line, 8)
				if content and #content > 0 then
					deviceCode = content
				end
			end
			line = file:read("*line")
		end
		file:close()
	end
	if not playerCode or playerCode == "" then
		playerCode = "default"
	end
	if not deviceCode or deviceCode == "" then
		deviceCode = UnityEngine.SystemInfo.deviceUniqueIdentifier
	end
	local pattern = "%s+"
	playerCode = string.gsub(playerCode, pattern, "")
	deviceCode = string.gsub(deviceCode, pattern, "")
	return playerCode, deviceCode
end

--上报错误日志
function fun.ReportErrorLog(msg)
	if SDK and SDK.send_error_log_to_server and msg and msg ~= "" then
		SDK.send_error_log_to_server(msg)
	end
end

function fun.SetSprite(spriteObj,spriteRes)
	if fun.is_not_null(spriteObj) then
		spriteObj.sprite = spriteRes
	end
end

function fun.SetNotDestroyParent(obj)
	local mana = fun.GameObject_find("GameManager")
	local jokerRoot = fun.find_child(mana,"Joker")
	if not jokerRoot then
		jokerRoot = CreateEmptyGameobject(0,0,mana.transform)
		jokerRoot.name = "Joker"
	end
	if jokerRoot then
		fun.set_parent(obj,jokerRoot)
	end
end

function fun.GetNotDestroyJokerParent()
	local mana = fun.GameObject_find("GameManager")
	local jokerRoot = fun.find_child(mana,"Joker")
	if not jokerRoot then
		jokerRoot = CreateEmptyGameobject(0,0,mana.transform)
		jokerRoot.name = "Joker"
	end
	return jokerRoot
end



--[[
    @desc: 将string转成二维数组，string格式   xx,dd;qq,ww       
    author:{author}
    time:2024-03-12 14:15:33
    --@dataStr: 
    @return:
		{
		[xx,dd],
		[qq,ww]
	}
]]
function fun.stringToArrays(dataStr)
	local ret = {}  
	local items = Split(dataStr,";")
	if items then
		for index, value in ipairs(items) do
			table.insert(ret,fun.stringToTable(value))
		end
	end
     
    return ret
end


function fun.stringToTable(dataStr)
	local ret =nil
	local items = Split(dataStr,",") 
	if(items and #items>0)then 
		ret = {}
		 for k,v in pairs(items) do
			ret[k] = tonumber(v)
		 end
	end
    return ret
end

--[[
    @desc:返回当前周榜活动(周榜或名人堂)的段位图片
    author:nuts
    time: 2024-04-10 16:11
    @return:
]]
function fun.GetCurrTournamentActivityImg(Id)
	if ModelList.HallofFameModel:IsActivityAvailable() then
		return string.format("MRTht0%s",Id)
	else
		return	string.format("ZBjb0%s",Id)
	end
end

--[[
    @desc:在指定表中查找指定字段为所要匹配的值（find xxx from tableName where matchKey == matchValue)
	params:
		tableName:所要查的表名
		matchKey:所要匹配的字段
		matchValue:目标值
    @return: item 或 nil
]]
function fun.GetDataFromCsvMatchCondition(tableName, matchKey, matchValue)
	if not Csv then
		return
	end

	if not Csv[tableName] then
		return
	end

	if not matchKey then
		return
	end

	if not matchValue then
		return
	end

	for i, v in pairs(Csv[tableName]) do
		if v[matchKey] == matchValue then
			return v
		end
	end
end

function fun.DelayPlaySound(delay, sound_name, volume)
	if not delay or delay <= 0 then
		UISound.play(sound_name, volume)
	else
		LuaTimer:SetDelayFunction(delay, function()
			UISound.play(sound_name, volume)
		end, false)
	end
end

function fun.OpenURL(url)
	if fun.is_ios_platform() then
		Util._OpenURL(url)
	else
		UnityEngine.Application.OpenURL(url)
	end
end

function fun.SafeCall(func, ...)
	if func then
		func(...)
	end
end

--商品奖励加上vip加成和等级加成
function fun.ResetShopRewardValue(value)
	local addValue = ModelList.PlayerInfoModel.GetTotalAddValue()
	if addValue <= 0 then
		return value
	end
	local data = (addValue * 0.01 + 1) * value
	local num = fun.NewRound(data)
	return num
end 