local hh = LuaFramework.AnimHelper
local anim_handler_dic = {}

Anim = {}



--平滑一个数值 sourceNum=table 这样才能按引用传递
function Anim.do_smooth_float(sourceNum,targetNum,time)
	return hh.AniDoSmoothFloat(sourceNum,targetNum,time)
end

--平滑一个float数值,不需要传table，会每帧执行回调
function Anim.do_smooth_float_update(sourceNum,targetNum,time,callback,complete_callback)
	 return hh.DoSmoothFloatUpdate(sourceNum,targetNum,time,callback,complete_callback)
end


--匀速平滑一个float数值
function Anim.do_smooth_float_update_average(sourceNum,targetNum,time,callback,complete_callback)
	return hh.DoSmootFloatUpdateAverage(sourceNum,targetNum,time,callback,complete_callback)
end

--平滑一个数值int sourceNum=table 这样才能按引用传递
function Anim.do_smooth_int(sourceNum,targetNum,time,callback)
	hh.DoSmoothInt(sourceNum,targetNum,time,callback)
end

function Anim.do_smooth_int2(text,sourceNum,targetNum,time,ease,updatCallback, finishCallback)
	if fun.is_not_null(text) then
		hh.DoSmoothInt2(text,sourceNum,targetNum,time,ease,updatCallback,finishCallback)
	else
		if finishCallback then finishCallback() end
	end
	return nil
end

function Anim.do_smooth_int2_tween(text,sourceNum,targetNum,time,ease,updatCallback, finishCallback)
	if fun.is_not_null(text) then
		return hh.DoSmoothInt2(text,sourceNum,targetNum,time,ease,updatCallback,finishCallback)
	else
		return nil
	end
end

function Anim.do_smooth_int_by_speed(text,sourceNum,targetNum,speed,ease)
	if fun.is_not_null(text) then
		hh.DoSmoothInt(text,sourceNum,targetNum,speed,ease)
	end
end

--平滑一个text int,sourceText是unity的text组件
function Anim.do_smooth_text(sourceText,targetNum,time,callback)
	if fun.is_not_null(sourceText) then
		return hh.DoSmoothText(sourceText,targetNum,time,callback)
	end
end

--平滑一个带千位分隔符text int
function Anim.do_smooth_text_with_comma(sourceText,targetNum,time,callback)
	if fun.is_null(sourceText) then return nil end
	return hh.DoSmoothNumTextWithComma(sourceText,targetNum,time,
			function()
				--c#层处理大数有不对，手动干预
				if(sourceText and sourceText.text)then
					sourceText.text =  tostring(fun.format_money(targetNum))
				end
				if(callback)then
					callback()
				end
 	end	)
end

--平滑移动
function Anim.smooth_move(go,pos_table,time,delay,pathType,with_ease,callback)
	if fun.is_not_null(go) then
		return hh.DoSmoothPath(go,pos_table,time,delay,pathType,with_ease,callback)
	else
		if callback then callback() end
	end
	return nil
end

function Anim.bezier_move(go,pos_table,time,delay,path_type,with_ease,callback,is_local)
	if fun.is_not_null(go) then
		return hh.DoBezierPath(go,pos_table,time,delay,path_type,with_ease,callback,is_local)
	else
		if callback then callback() end
	end
	return nil
end
function Anim.throw_move(go,pos_table,time,callback)
	if fun.is_not_null(go) then
		return hh.DoThrowPathMove(go,pos_table,time,callback)
	else
		if callback then callback() end
		return nil
	end
end


function Anim.move_to_y(go,y,t,callback)
	if fun.is_not_null(go) then
		return Anim.move(go,go.transform.localPosition.x,y,0,t,true,false,callback)
	else
		if callback then callback() end
	end
	return nil
end

function Anim.move_to_x(go,x,t,callback)
	if fun.is_not_null(go) then
		return Anim.move(go,x,go.transform.localPosition.y,0,t,true,false,callback)
	else
		if callback then callback() end
	end
	return nil
end

function Anim.move_to_xy(go,x,y,t, callback)
	if fun.is_not_null(go) then
		return Anim.move(go,x,y,0,t, false, false, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.move_to_xy_local(go,x,y,t, callback)
	if fun.is_not_null(go) then
		return Anim.move(go,x,y,0,t, true, false, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.move_to_xy_local_ease(go,x,y,t, callback)
	if fun.is_not_null(go) then
		return Anim.move(go,x,y,0,t, true, true, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.scale_to_x(go,x,t)
	if fun.is_not_null(go) then
		local local_scale = go.transform.localScale
		hh.Scale(go,x,local_scale.y, local_scale.z, t,true,nil)
	end
end

function Anim.scale_to_y(go,y,t,callback)
	if fun.is_not_null(go) then
		local local_scale = go.transform.localScale
		return hh.Scale(go,local_scale.x,y,local_scale.z,t,true,callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.scale_to_xy(go,x,y,t, callback)
	if fun.is_not_null(go) then
		local local_scale = go.transform.localScale
		return hh.Scale(go,x,y,local_scale.z,t,true,callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.scale_to_xy_ease(go,x,y,t,ease,callback)
	if fun.is_not_null(go) then
		local local_scale = go.transform.localScale
		return hh.Scale_ease(go,x,y,local_scale.z,t,true,callback,ease)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.renderer_color(render, color, t, callback)
	return hh.DoColor(render, color, t, callback)
end

function Anim.renderer_color_loop(render, color, t,loop, callback)
	if fun.is_not_null(render) then
		return hh.DoColorLoop(render, color, t,loop, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.image_color_loop(img, color, t,loop, callback)
	if fun.is_not_null(img) then
		return hh.DoImageColorLoop(img, color, t,loop, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.scale_loop(go, scale, t, loopcnt, callback)
	if fun.is_not_null(go) then
		return hh.DoScaleLoop(go, scale, t, loopcnt, callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 滑动列表平滑滚动到X坐标
function Anim.scroll_to_x(scroll_content,target_x,time,callback)
	if fun.is_not_null(scroll_content) then
		return hh.ScrollToX(scroll_content,target_x,time,callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 滑动列表平滑滚动到X坐标
function Anim.scroll_to_x_ease(scroll_content,target_x,time,ease,callback)
	if fun.is_not_null(scroll_content) then
		return hh.ScrollToX_Ease(scroll_content,target_x,time,ease,callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 滑动列表平滑滚动到Y坐标
function Anim.scroll_to_y(scroll_content,target_y,time,callback)
	if fun.is_not_null(scroll_content) then
		return hh.ScrollToY(scroll_content,target_y,time,callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 滑动列表平滑滚动到Y坐标
function Anim.scroll_to_y_ease(scroll_content,target_y,time,ease,callback)
	return hh.ScrollToY_Ease(scroll_content,target_y,time,ease,callback)
end

-- 滑动列表平滑滚动到xY坐标
function Anim.scroll_to_xy(scroll_content,target,time,callback)
	return Anim.ScrollToXY_Ease(scroll_content, target,time, Ease.Linear, callback)
end

-- 滑动列表平滑滚动到xY坐标
function Anim.ScrollToXY_Ease(scroll_content,target,time,easeType, callback)
	return hh.ScrollToXY_Ease(scroll_content,target,time,easeType, callback)
end


-- 滚动条平滑增长
function Anim.slide_to(slider, text, target, time, callback)
	if fun.is_not_null(slider) then
		return hh.SlideTo(slider, text, target, time, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.slide_to_num(slider, text, target,max, time, callback)
	if fun.is_not_null(slider) then
		return hh.SlideTo(slider, text, target,max, time, callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 延迟移动
function Anim.delay_move(go, to, duration, delay, is_local, callback)
	if fun.is_not_null(go) then
		return hh.DelayMove(go, to, duration, delay, is_local, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.canvas_fade(canvas, to, duration, delay, callback)
	if fun.is_null(canvas) then 
		log.r("canvas is null. canvas_fade fail")
		return
	end
	return hh.DoCanvasGroupFade(canvas, to, duration, delay, callback)
end

--[[
    @desc: 
    author:{author}
    time:2020-12-11 10:41:22
    --@canvas:
	--@to:
	--@duration:
	--@delay:
	--@callback: 
    @return:
]]
function Anim.go_fade(go, to, duration, delay, callback)

	local canvas = fun.get_component(go,fun.CANVAS_GROUP)
	if fun.is_null(canvas) then
		log.r("canvas is null. canvas_fade fail")
		return
	end
	return hh.DoCanvasGroupFade(canvas, to, duration, delay, callback)
end


function Anim.image_do_fade(img, from, to, duration, callback)
	if fun.is_not_null(img) then
		if from then
			local color = img.color
			color.a = from
			img.color = color
		end
		return hh.DoFade(img, to, duration, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.image_do_fade_loop(img, from, to, duration,times,looptype, callback)
	if fun.is_not_null(img) then
		if from then
			local color = img.color
			color.a = from
			img.color = color
		end
		return hh.DoFadeLoop(img, to,duration,times,looptype, callback)
	else
		if callback then callback() end
		return nil
	end
end
function Anim.text_do_fade_loop(label, from, to, duration,times,looptype, callback)
	if fun.is_not_null(label) then
		if from then
			local color = label.color
			color.a = from
			label.color = color
		end
		return hh.DoFadeTextLoop(label, to,duration,times,looptype, callback)
	else
		if callback then callback() end
		return nil
	end
end

function Anim.canvas_group_do_fade_loop(group, from, to, duration,times,looptype, callback)
	if fun.is_not_null(group) then
		if from then
			group.alpha = from;
		end
		return hh.DoCanvasGroupFadeLoop(group, to,duration,times,looptype, callback)
	else
		if callback then callback() end
		return nil
	end
end

-- 透明度渐变
function Anim.do_fade(go, from, to, duration, callback)
	local img = fun.get_component(go,fun.IMAGE)
	local txt = fun.get_component(go,fun.TEXT)
	if img then
		if from then
			local color = img.color
			color.a = from
			img.color = color
		end
		return hh.DoFade(img, to, duration, callback)
	elseif txt then
		if from then
			local color = txt.color
			color.a = from
			txt.color = color
		end
		return hh.DoFadeText(txt, to, duration, callback)
	else
		log.r("目标go不存在Image或Text控件,无法执行DoFade透明度变换")
	end
end

-- --------------------animation---------------------------
-- Anim.Dire = {}
-- Anim.Dire.x = LuaFramework.Direction.x
-- Anim.Dire.y = LuaFramework.Direction.y
-- Anim.Dire.z = LuaFramework.Direction.z

--以下是库方法，以上是核心玩法中，实际使用中的方法
function Anim.move(go,x,y,z,t,is_local,isEase,callback)
	if fun.is_null(go) then
		return nil
	end
	local key = "move_"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	if t == 0 then --时间为零时，直接设置位置
		go.transform.localPosition = Vector3.New(x,y,z)
	else
		if(isEase == true) then
			handler = hh.MoveEase(go,x,y,z,t,is_local,DG.Tweening.Ease.InOutSine,function() anim_handler_dic[key]=nil if callback then callback() end end)
		else
			handler = hh.Move(go,x,y,z,t,is_local,function() anim_handler_dic[key]=nil if callback then callback() end end)
		end
		anim_handler_dic[key] = handler
	end
	return handler
end

function Anim.move_ease(go,x,y,z,t,is_local,ease,callback)
	if fun.is_null(go) then if callback then callback() end return nil end
	local key = "move_"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	if t == 0 then --时间为零时，直接设置位置
		go.transform.localPosition = Vector3.New(x,y,z)
	else
		handler = hh.MoveEase(go,x,y,z,t,is_local,ease,function() anim_handler_dic[key]=nil if callback then callback() end end)
		anim_handler_dic[key] = handler
	end
	return handler
end

function Anim.move_ease_update(go,x,y,z,t,is_local,ease,updateCallback,callback)
	if fun.is_null(go) then if callback then callback() end return nil end
	local key = "move_"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	if t == 0 then --时间为零时，直接设置位置
		go.transform.localPosition = Vector3.New(x,y,z)
	else
		handler = hh.MoveEase(go,x,y,z,t,is_local,ease,updateCallback,function() anim_handler_dic[key]=nil if callback then callback() end end)
		anim_handler_dic[key] = handler
	end
	return handler
end

function Anim.move_by_speed(go, x, y, speed, is_local, ease_type, on_complete)
	if fun.is_null(go) then if on_complete then on_complete() end return nil end
	local key = "move_by_speed"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	
	local handler = nil
	if not is_local then
		handler = go.transform:DOMove(Vector3.New(x, y, 0), speed)
	else
		handler = go.transform:DOLocalMove(Vector3.New(x, y, 0), speed)
	end
	handler:SetEase(ease_type)
	handler:SetSpeedBased(true)
	handler:OnComplete(function ()
		if on_complete then on_complete() end
	end)
	anim_handler_dic[key] = handler
	return handler
end

function Anim.rotate(go,x,y,z,t,is_local,callback,ease)
	if fun.is_null(go) then if callback then callback() end return nil end
	local key = "rotate"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	handler = hh.rotate(go,x,y,z,t,is_local,function() anim_handler_dic[key]=nil if callback then callback() end end)
	anim_handler_dic[key] = handler
	if ease then
		handler:SetEase(ease);
	end
	return handler
end

function Anim.scale(go,x,y,z,t,is_local,callback)
	if fun.is_null(go) then if callback then callback() end return nil end
	local key = "scale"..go:GetHashCode()
	local handler = anim_handler_dic[key]
	if handler then
		handler:Kill()
		anim_handler_dic[key]=nil
	end
	handler = hh.Scale(go,x,y,z,t,is_local,function() anim_handler_dic[key]=nil if callback then callback() end end)
	anim_handler_dic[key] = handler
	return handler
end

function Anim.kill_all_tween_on_object(target)
	hh.Kill(target)
end

function Anim.ShakePosition(go,duration,vibrato,x,y,z)
	if fun.is_null(go) then return nil end
	hh.ShakePosition(go,duration,vibrato,x,y,z)
end

-- --三方向缩放，带回调
-- function Anim.do_ScaleXYZC(obj,x,y,z,time,callBack)
-- 	hh.AniDOScale(obj.gameObject,x,y,z,time,callBack)
-- end
-- --三方向缩放
-- function Anim.do_ScaleXYZ(obj,x,y,z,time)
-- 	hh.AniDOScale(obj.gameObject,x,y,z,time)
-- end
-- --打断一个动画，然后播放三方向缩放 带回调
-- function Anim.do_NScaleXYZC(obj,x,y,z,time,callBack)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleXYZC(obj.gameObject,x,y,z,time,callBack)
-- end
-- --打断一个动画，然后播放三方向缩放
-- function Anim.do_NScaleXYZ(obj,x,y,z,time)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleXYZ(obj.gameObject,x,y,z,time)
-- end

-- --两方向缩放，带回调
-- function Anim.do_ScaleXZC(obj,x,z,time,callBack)
-- 	hh.AniDOScale(obj.gameObject,x,z,time,callBack)
-- end
-- --两方向缩放
-- function Anim.do_ScaleXZ(obj,x,z,time)
-- 	hh.AniDOScale(obj.gameObject,x,z,time)
-- end
-- --打断一个动画，然后播放2方向缩放 带回调
-- function Anim.do_NScaleXZC(obj,x,z,time,callBack)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleXZC(obj.gameObject,x,z,time,callBack)
-- end
-- --打断一个动画，然后播放2方向缩放
-- function Anim.do_NScaleXZ(obj,x,z,time)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleXZ(obj.gameObject,x,z,time)
-- end
-- --单方向缩放，带回调,direction参数为Anim.Dire.xxx
-- function Anim.do_ScaleDirecC(obj,scale,time,direction,callBack)
-- 	hh.AniDOScale(obj.gameObject,scale,time,direction,callBack)
-- end
-- --单方向缩放,direction参数为Anim.Dire.xxx
-- function Anim.do_ScaleDirec(obj,scale,time,direction)
-- 	hh.AniDOScale(obj.gameObject,scale,time,direction)
-- end
-- --打断一个动画，然后播放1方向缩放 带回调
-- function Anim.do_NScaleDirecC(obj,scale,time,direction,callBack)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleDirecC(obj,scale,time,direction,callBack)
-- end
-- --打断一个动画，然后播放1方向缩放
-- function Anim.do_NScaleDirec(obj,scale,time,direction)
-- 	Anim.do_Kill(obj)
-- 	Anim.do_ScaleDirec(obj,scale,time,direction)
-- end

-- --立即完成动画
-- function Anim.do_Complete(obj)
-- 	hh.AniDoComplete(obj.gameObject)
-- end
-- --在变化过程中执行该方法，则物体慢慢的变回原样，如果变化已经完成，该方法无效
-- function Anim.do_Flip(obj)
-- 	hh.AniDOFlip(obj.gameObject)
-- end
-- --变化结束前调用该方法，物体回到原始位置
-- function Anim.do_Back(obj)
-- 	hh.AniDOBack(obj.gameObject)
-- end
-- --执行 下面方法则再次变化
-- function Anim.do_PlayForward(obj)
-- 	hh.AniDOPlayForward(obj.gameObject)
-- end
-- --渐变一个颜色
-- function Anim.do_Color(srcColor,targetColor,t)
-- 	hh.AniDoColor(srcColor,targetColor,t)
-- end
-- --停止当前变化
-- function Anim.do_Kill(tween)
-- 	hh.AniDOKill(tween)
-- end
-- --自身朝向坐标vec
-- function Anim.do_LookAt(obj,vec,time)
-- 	hh.AniDOLookAt(obj.gameObject,vec,time)
-- end
-- --暂停播放动画
-- function Anim.do_Pause(obj)
-- 	hh.AniDOPause(obj.gameObject)
-- end
-- --继续播放动画
-- function Anim.do_Play(obj)
-- 	hh.AniDOPlay(obj.gameObject)
-- end
-- --在变化结束之前，执行该方法，则重新开始变化
-- function Anim.do_Restart(obj)
-- 	hh.AniDORestart(obj.gameObject)
-- end




-- --播放改变物体透明度动画 tab=材质球table，percent=0-100百分比
-- function Anim.do_mat_alpha(mat_tab,percent,time)
-- 	return hh.AniDoMatAlpha(mat_tab,percent,time)
-- end

-- --重复播放改变物体透明度动画 tab=材质球table
-- function Anim.do_mat_alpha_yoyo(mat_tab,time)
-- 	return hh.AniDoMatAlphaYoyo(mat_tab,time)
-- end

-- --kill一组list动画
-- function Anim.do_kill_list(tween_tab)
-- 	hh.AniDOKillTable(tween_tab)
-- end

-- --手动设置材质球的透明度
-- function Anim.do_set_mat_alpha(mat_tab,percent)
-- 	hh.SetMatAlpha(mat_tab,percent)
-- end
-- --------------------------------------------------------