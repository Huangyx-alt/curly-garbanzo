--panel管理
require "Common/config"

--[[
页面名称及说明
Error			错误
Tips			提示

Loading			转圈加载
LongLoading		进机台之前的加载界面
LoadingScene	loading场景的逻辑脚本

Home			主界面，即大厅
Setting			设置

Message			--

]]


Panel = {}

---场景列表
Panel.scene_list =
{
	SceneGamePortrait = "SceneGamePortrait",
	SceneGame = "SceneGame",
	SceneHangUp = "SceneHangUp",
	SceneHome = "SceneHome",
	SceneLoading = "SceneLoading",
}


Panel.DESIGN_W = 1920
Panel.DESIGN_H = 1080
--读取一个场景
local scene_target_panel_name = nil
local scene_target_panel_para = nil
local current_scene_name = nil
-- 弹窗排除列表(非弹窗的dialog填入)
local dialog_exception_list = {
	"JackpotTip",
	"EasterEggPartyHammer",
	"MachineUnLockLevel",
	--"StarFishChallenge",
}
--退出场景前的操作
local exit_callback_list = {}
--场景退出前执行操作(回调)
local function before_scene_exit()
	for i,v in ipairs(exit_callback_list) do
		v()
	end
end

--注册回调函数
function Panel.reg_exit_callback(cb)
	table.insert(exit_callback_list,cb)
end


--跳转到新场景后，需要立即显示某个界面
function Panel.GetSceneTargetPanel()
	local ctrl = nil
	if scene_target_panel_name then
		ctrl = {panel_name=scene_target_panel_name,para=scene_target_panel_para}
		scene_target_panel_name	= nil
		scene_target_panel_para	= nil
	end
	return ctrl
end


function GetCurrentSceneName()
	return current_scene_name
end

--存储所有实例化过得panel lua脚本
Panel.Color = {}
Panel.Color.Info = "#FFFFFFFF"
Panel.Color.Warn = "#FFFF00FF"
Panel.Color.Error = "#FF0000FF"


--检查游戏中最后一个场景
function Panel.check_last_scene_is_game()
	if(Panel.prev_scene_name == Panel.scene_list.SceneGamePortrait or
			Panel.prev_scene_name == Panel.scene_list.SceneGame) then
		return true
	end
	return false
end


--每帧更新回调
local function panel_update_call()
	for k,v in pairs(Panel.update_callbacks) do v() end
end

--注册每帧回调
function Panel.reg_update_callback(panel_name,callback)
	Panel.update_callbacks[panel_name] = callback
end

--注销每帧回调
function Panel.unreg_update_callback(panel_name)
	Panel.update_callbacks[panel_name] = nil
end


--添加updata方法
function Panel.add_update_handler()
	Panel.update_handle = UpdateBeat:CreateListener(panel_update_call)
	UpdateBeat:AddListener(Panel.update_handle)
end

--加载某个面板
local function Panel_load_panel(panel_name,para,parent)
	if not parent then parent = Panel.page_layer end
	local ctrl_name = panel_name.."Ctrl"
	require ("Controller/"..ctrl_name)

	local ctrl = _G[ctrl_name]:new()
	para = para or {}
	local dlist = ctrl.depend_panel_name_list
	--先加载依赖的界面,并在所有依赖加载完成后,回调 depend_loaded_callback
	if dlist and #dlist >0 then
		local depends_count = #dlist
		for i,v in ipairs(dlist) do
			--将依赖的界面，注入到父级ctrl里面
			ctrl[v.."Ctrl"] = Panel_load_panel(v,{after_init_callback=function()
				depends_count = depends_count - 1
				
				if depends_count == 0 then
					--再自身加载，因为资源可能已有缓存，则会同步回调本callback.导致ctrl[v.."Ctrl"]未赋值，就调用了ctrl:init(panel_name,para,parent)
					--所以在下面用Invoke，让调用流程，强制变为异步
					Invoke(function() ctrl:init(panel_name,para,parent) end,0.001)
				end
			end},parent)
		end
	else
		ctrl:init(panel_name,para,parent)
	end
	return ctrl
end


--[[
para参数说明
skip_load_prefab 不加载预置体，仅用于处理loading进度界面的流程问题
after_init_callback 界面加载完成后的回调

]]

--界面跳转
function Panel.jump(panel_name,para)
	--清除所有按钮点击回调绑定
	Panel.binded_click_callbacks  = {}
	Panel.binded_button_down_callbacks = {}
	Panel.binded_button_up_callbacks = {}
	
	if not para then
		para = {}
	end
	--关闭所有对话框
	while #Panel.dialog_list>0 do
		Panel.close_dialog()
	end

	--关闭之前的界面
	if Panel.cur_ctrl then
		Panel.close(Panel.cur_ctrl)
		Panel.cur_ctrl = nil
	end

	--清除之前界面中的UI粒子特效记录
	Panel.ui_particle_list = nil

	if string.find(panel_name, ":") then
		local arr = Split(panel_name,":")
		local scene_name = arr[1]
		local panel_name = arr[2]
		LoadScene(scene_name,{panel_name=panel_name,para=para})--选跳转场景，再加载界面
	else
		local after_init_callback = para.after_init_callback
		para.after_init_callback = function(panel_name)
			Panel.ui_particle_list = UnityEngine.GameObject.FindGameObjectsWithTag("UIParticle")
			if #Panel.dialog_list > 0 then
				Panel.hide_ui_particle()
			end
			if after_init_callback then after_init_callback(panel_name) end
		end
		Panel.cur_ctrl = Panel_load_panel(panel_name,para,Panel.page_layer)
	end
end

--销毁面板
function Panel.destroy()
	Event.Brocast(EventName.Event_Destory_Panle)
	if Panel.update_handle then
		UpdateBeat:RemoveListener(Panel.update_handle)
		Panel.update_handle = nil
	end
	if Panel.cur_ctrl then
		Panel.close(Panel.cur_ctrl)
		Panel.cur_ctrl  = nil
	end

	if Panel.dialog_list then
		for i,v in ipairs(Panel.dialog_list) do
			log.r(v.panel_name.." Close "..fun.time().."  "..now_millisecond())
			Panel.close_dialog()
		end
	end
	Panel.black_cover = nil
	Timer.kill_all_invoke()
end

function Panel.close(ctrl)
	--先销毁自己
	local close_handler = function()
		Event.Brocast(EventName.Event_close_panel, ctrl.panel_name)
		if ctrl.panel_name then --异常检测
			if Panel.update_callbacks[ctrl.panel_name] then
				log.r("错误:界面"..ctrl.panel_name.."的update回调没有解除")
			end
		end
		--再销毁依赖
		local dlist = ctrl.depend_panel_name_list
		if dlist and #dlist >0 then
			local depends_count = #dlist
			for i,v in ipairs(dlist) do
				ctrl[v.."Ctrl"]:close()
				Event.Brocast(EventName.Event_close_panel, v)
			end
		end
	end
	ctrl:close(close_handler)
end

function Panel.hide_ui_particle()
	--c#数组，下标从0开始，#list刚好为数组最大下标，即长度-1
	local list = Panel.ui_particle_list
	if list then
		for i=0,list.Length-1 do
			list[i].gameObject:SetActive(false)
		end
	end
end


function Panel.show_ui_particle()
	--c#数组，下标从0开始，#list刚好为数组最大下标，即长度-1
	if #Panel.dialog_list>0 then
		return --7-12修复显示排行榜时关闭loading导致排行榜未关闭但粒子已经显示穿透的问题
	end
	local list = Panel.ui_particle_list
	if list then
		for i=0,list.Length-1 do
			list[i].gameObject:SetActive(true)
		end
	end
end



--


function Panel.show_dialog_mask(dialog)
	local is_show = true;
	for i, v in ipairs(dialog_exception_list) do
		if(dialog == v)then
			is_show = false
			break
		end
	end

	--if(is_show)then
	--	Panel.mask:SetActive(true)
	--end
	Panel.dialog_layer:SetActive(true)
end

--显示对话框
function Panel.show_dialog(panel_name,para)

	if not Panel.is_dialog_showing(panel_name) then
		--显示对话框层
		Panel.show_dialog_mask(panel_name)
		if not para then para = {} end
		para.sibling_index=#Panel.dialog_list+1
		local ctrl = Panel_load_panel(panel_name,para,Panel.dialog_layer)
		ctrl.panel_name = panel_name
		table.insert(Panel.dialog_list,ctrl)
		Panel.hide_ui_particle()
	else
		log.r("dialog已打开,忽略本次show_dialog",panel_name)
	end
end

--查找某个界面正在显示中
function Panel.is_dialog_showing(panel_name)
	if panel_name == nil then
	 	return false
	end
	for i,v in pairs(Panel.dialog_list) do
		if v.panel_name then
			if v.panel_name == panel_name then return true end
		end
	end
	return false
end

--关闭最顶上的对话框
--TODO show与close没有严格的关联关系，有可能会错乱，但暂时够用，暂不处理
function Panel.close_dialog()
	--log.log("Panel.close_dialog")
	if #Panel.dialog_list>0 then
		local ctrl = Panel.dialog_list[#Panel.dialog_list]
		table.remove(Panel.dialog_list,#Panel.dialog_list)
		Panel.close(ctrl)
	end
	--隐藏对话框层
	Panel.hide_dialog_layer()
end


function Panel.is_exception_panle(name)

	for j, k in pairs(dialog_exception_list) do
		if(name == k)then
			return true
		end
	end
	return false
end

function Panel.can_hide_mask()
	local ret = true

	for i, v in pairs(Panel.dialog_list) do
		if(Panel.is_exception_panle(v.panel_name) ==false)then
			ret = false
		end
	end
	return ret
end

function Panel.hide_dialog_layer()
	if Panel.can_hide_mask() then
		if(Panel.hide_mask_invoke)then
			Panel.hide_mask_invoke:Stop()
			Panel.hide_mask_invoke = nil
		end
		Panel.hide_mask_invoke = Invoke(function()
			if Panel.can_hide_mask() then
				Panel.dialog_layer:SetActive(false)
				--Panel.mask:SetActive(false)
				Panel.show_ui_particle()
			end
		end,0.3)

	end
end



function Panel.close_dialog_by_name(dialog_name)
	--log.log("Panel.close_dialog_by_name",dialog_name)

	-- local remove_list = {}
	-- for i = #Panel.dialog_list, 1, -1 do
	-- 	local v = Panel.dialog_list[i]
	-- 	if v.panel_name == dialog_name then
	-- 		table.insert(remove_list, v)
	-- 		table.remove(Panel.dialog_list, i)
	-- 	end
	-- end
	-- for i, v in ipairs(remove_list) do
	-- 	Panel.close(v)
	-- end
	-- Panel.hide_dialog_layer()

end

function Panel.print_dialog_list()
	-- local dialog_name_list = ""
	-- for i, v in ipairs(Panel.dialog_list) do
	-- 	dialog_name_list = dialog_name_list..v.panel_name.."\n"
	-- end
	-- log.y(dialog_name_list)
end
--替换最顶上的dialog
function Panel.show_dialog_replace(panel_name,para)
	Panel.close_dialog()
	Panel.show_dialog(panel_name,para)
end

--绑定点击事件
function Panel.bind_click(go,cb)
	local button_handle_id = Util.ButtonBindClick(go.gameObject)
	if button_handle_id ~= 0 then
		Panel.binded_click_callbacks[button_handle_id] = {callback = cb, last_trigger_time = -1, interval = 0.3}
	end
end

-- 解绑点击事件(Eason 2019.2.14)
function Panel.unbind_click(go)
	local button_handle_id = Util.ButtonUnbindClick(go.gameObject)
	if button_handle_id ~= 0 then
		Panel.binded_click_callbacks[button_handle_id] = nil
	end
end

-- 设置单个按钮快速点击响应间隔
-- 为了防止快速多次点击按钮造成的各种异常 所有按钮默认有响应间隔
function Panel.set_btn_click_interval(btn, interval)
	if interval < 0 then return end 

	local button_handle_id = Util.GetButtonBindingID(btn)
	if button_handle_id ~= 0 then
		local info = Panel.binded_click_callbacks[button_handle_id]
		if info then
			info.interval = interval
		end
	end
end

--按钮的统一回调,C#代码方面，直接写死了该回调方法名
function Panel.OnButtonClick(button_handle_id)
	local click_info = Panel.binded_click_callbacks[button_handle_id]
	if click_info then
		local last_tigger_time = click_info.last_trigger_time
		local now = os.time()
		if now - last_tigger_time >= click_info.interval then
			if click_info.callback then 
				click_info.callback()
				click_info.last_trigger_time = now
			end
		end
	end
end

function Panel.show_tips(title,msg,hide_close_btn,on_close_callback)
	log.r("show_tips",title,msg)
	--ShowMsgTips(title,msg)
end

function Panel.show_error(msg,on_close_callback, will_quit_app) 
	Http.report_error(msg,"Error")
	log.r("Error:"..msg)
	Panel.show_dialog("Tips",{title_msg = "ERROR",content_msg ="Error:"..msg,sibling_index=#Panel.dialog_list+1,	on_close_callback = function()
		if on_close_callback then 
			on_close_callback() 
		else
			if will_quit_app then
				UnityEngine.Application.Quit()
			end
		end
	end})	
end

--显示加载中
function Panel.show_loading()
	Panel.loading:SetActive(true)
	Panel.is_loading_showing = true
	Panel.hide_ui_particle()
	--Panel.show_dialog("Loading")
end

--隐藏加载中
function Panel.hide_loading()
	Panel.loading:SetActive(false)
	Panel.is_loading_showing = false
	if #Panel.dialog_list > 0 then
		Panel.show_ui_particle()
	end
	fun.set_active(Panel.loading_mask,true)
	--Panel.close_dialog()
end

--显示长加载
function Panel.show_long_loading()
	Panel.show_dialog("LongLoading",{sibling_index=#Panel.dialog_list+1})
end

--隐藏长加载
function Panel.hide_long_loading()
	Panel.close_dialog()
end

--显示跑马灯
function Panel.show_roll_msg(msg)
	if not Panel.rollmsg_ctrl then
		Panel.rollmsg_ctrl = LoadPanel("RollMsg",{msg,on_msg_end_callback=function() 			
			if Panel.rollmsg_ctrl then
				Panel.close(Panel.rollmsg_ctrl)
				Panel.rollmsg_ctrl = nil
			end
		end})
	else
		Panel.rollmsg_ctrl:append_msg(msg)
	end
end

function Panel.show_confirm(msg,callback)
	Panel.show_tips("Coming Soon",msg)
end

function Panel.show_messagebox(title, msg, submit_content, cancel_content, on_sumbit, on_cancel)
	Panel.show_dialog("MessageBox",{
		title = title,
		message = msg,
		submit_content = submit_content,
		cancel_content = cancel_content,
	
		on_submit = on_sumbit,
		on_cancel = on_cancel
	})
end

function Panel.on_back_pressed()
	if #Panel.dialog_list>0 then
		--此处加排除规则
		local cur_dialog = Panel.dialog_list[#Panel.dialog_list]
		if cur_dialog:ignore_back_pressed_in_dialog_mode() then
			--弹出窗口忽略后退按按键操作
		else
			log.y("-on_back_pressed-")
			Panel.close_dialog()
		end
	else
		local current_scene_name = Panel.current_scene_name
		if current_scene_name == "SceneHome" or current_scene_name== "SceneGame" or current_scene_name == "SceneGamePortrait" then
			if Panel.cur_ctrl then Panel.cur_ctrl:on_back_pressed() end
		end
	end
end

-----工具方法
--设置panel物体的Z轴（因为ui层加入3d模型的缘故需要以此设置ui和模型的显示关系）
function Panel.set_z(panel_obj,z_pos)
	local rec = fun.get_component(panel_obj,fun.RECT)
	local pos = rec.localPosition
	rec.localPosition = Vector3.New(pos.x, pos.y, z_pos)
end



function Panel.is_any_dialog_on()
	if #Panel.dialog_list > 0 then
		log.log("排除弹窗清单",dialog_exception_list)
		for i,v in ipairs(Panel.dialog_list) do
			local exception = false
			for _, exception_name in ipairs(dialog_exception_list) do
				if exception_name == v.panel_name then
					log.log("排除弹窗",v.panel_name)
					exception = true
				end
			end
			if not exception then
				log.log("有弹窗",v.panel_name)
				return true
			end
		end
		log.log("没有弹窗")
		return false
	else
		log.log("没有弹窗")
		return false
	end
end


function Panel.set_visible(panel_name, visible)
	local ctrl_name = panel_name.."Panel"
	local go = fun.find_child(Panel.page_layer,ctrl_name)
	local canavs = fun.get_component(go, fun.CANVAS)
	--local raycaster = fun.get_component(go,fun.GRAPHICRAYCASTER)
	if canavs == nil then
		canavs = fun.add_component(go,UnityEngine.Canvas)
		--raycaster = fun.add_component(go,UnityEngine.UI.GraphicRaycaster)
	end
	if canavs.enabled ~= visible then
		canavs.enabled = visible
		--raycaster.enabled = visible
	end
end


function Panel.get_panel_cooldown(dialog)
	local cooldown = UserData.get(dialog,-1)
	return cooldown
end
