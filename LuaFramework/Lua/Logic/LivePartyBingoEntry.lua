local Main = {}
local MainStartLogic = require "Logic.MainStartLogic"
os.time_ = os.time --莫名奇妙的设置

-- 模块局部变量
local isInit = nil
local lastLevelNoInit = nil
local lastTrackbackMsg = nil
local exit_scene = nil

-- 错误处理函数（保持全局） by LwangZg xpall会绕过报错
function __G__TRACKBACK__(msg)
    -- 保留原有错误处理逻辑
    msg = Main.ProcessTrackbackMsg(msg)
    -- if fun.IsEditor() then
    -- log.e("__G__TRACKBACK__ ".. msg)
    -- print("__G__TRACKBACK__  " .. msg)
    Util.LogError("__G__TRACKBACK__  " .. msg)
    -- else
    --     if log.enabled then
    --         print("__G__TRACKBACK__  "..msg)
    --     end
    -- end

    -- if SDK and SDK.TrackEvent and lastTrackbackMsg ~= msg then
    --     lastTrackbackMsg = msg
    --     SDK.send_error_log_to_server(msg)
    --     SDK.TrackEvent("client_error_msg", msg)
    --     Util.EditorDisplayDialog()
    -- end

    if ModelList.GMModel:IsGMAutoBattle() then
        Util.EditorPause()
    end
end

-- 封装原有功能到模块
function Main.SetInit()
    isInit = true
    if lastLevelNoInit then
        Main.OnLevelWasLoaded(lastLevelNoInit)
        print(' SetInit==================== Main.OnLevelWasLoaded !!')
        lastLevelNoInit = nil
    end
end

function Main.MainRun()
    Main.SetInit()
end

function Main.RemoveRequiredByName(preName)
    for key, _ in pairs(package.preload) do
        if string.find(tostring(key), preName) == 1 then
            package.preload[key] = nil
        end
    end
    for key, _ in pairs(package.loaded) do
        if string.find(tostring(key), preName) == 1 then
            package.loaded[key] = nil
        end
    end
end

function Main.ProcessTrackbackMsg(msg)
    -- if Proto and Proto.is_decoding() then
    -- 	local decodingProtocal = Proto.get_decoding_protocal()
    -- 	local pack = Proto.get_decoding_protocal_pack()
    -- 	if decodingProtocal then
    -- 		msg = " decoding " .. decodingProtocal .. " " .. msg
    -- 	end
    -- 	if pack then
    -- 		msg = " pack: " .. pack .. "   end  " .. msg
    -- 	end

    -- 	if UIUtil then
    -- 		msg = " version: " .. UIUtil.get_client_version() .. msg
    -- 	end
    -- end

    return msg
end

function Main.ReLoadLoading(allUpdateLua)
    MainStartLogic.UnRegCmd()
    local cout = allUpdateLua.Count
    for i = 0, cout - 1 do
        local name = allUpdateLua[i]
        if (name ~= "Main") then
            Main.RemoveRequiredByName(name)
        end
    end
    Main.MainFunc()
end

function xp_call(func)
    --暂时屏蔽 by LwangZg
    --[[ if(AppConst.DevMode== true  or log.enabled == false) then
		return function()
			xpcall(
					func,
					__G__TRACKBACK__
			)
		end
	else
		return func
	end ]]
    return function()
        xpcall(
            func,
            __G__TRACKBACK__
        )
    end
end

--[[
    @desc: 用于在黑屏环境下加载lua
    author:{author}
    time:2021-04-22 19:18:33
    @return:
]]
function Main.RequireLua()
    print(" ====== RequireLua 开始 ")
    MainStartLogic.RequireLua()
    MainStartLogic.InitAllModul()
    print(" ====== RequireLua  ProcedureManager:Start() ")
    ProcedureManager:Start()
    Main.SetInit()
    print(" ====== RequireLua 完成 ")
end

function Main.MainRequireLua(go)
    print(" ====== MainRequireLua ====== ")
    xpcall(Main.RequireLua, __G__TRACKBACK__)
end

function Main.ReloadScene()
    Facade.SendNotification(NotifyName.Common.Reconnection)
end

function Main.OnBackPressed()
    --SceneViewManager.on_back_pressed()
end

function Main.OnSceneUnloaded(sceneName)
    if isInit then
        exit_scene = sceneName
        Main.on_sence_exit(sceneName)
    end
end

function Main.on_sence_exit(scene_name, on_panel_init_callback)
    --[[
	log.r("on_sence_enter "..scene_name)
	if _G[scene_name] == nil then
		require("Scene/"..scene_name)
	end
	if _G[scene_name] ~= nil and _G[scene_name].OnLevelWasUnLoaded then
		_G[scene_name].OnLevelWasUnLoaded()
	end
	--]]
end

--场景切换通知
function Main.OnLevelWasLoaded(sceneName)
    if isInit then
        if exit_scene ~= sceneName then
            CleanSceneRes(exit_scene)
        end
        SceneViewManager.ClearView()
        collectgarbage("collect")
        Time.timeSinceLevelLoad = 0
        ProcedureManager:on_sence_enter(sceneName)
    else
        lastLevelNoInit = sceneName
    end
end

function Main.on_sence_enter(scene_name, on_panel_init_callback)
    log.r("on_sence_enter " .. scene_name)
    if _G[scene_name] == nil then
        require("Scene/" .. scene_name)
    end
    SceneViewManager.ClearView()
    collectgarbage("collect")
    Time.timeSinceLevelLoad = 0
    ---TODO 之后整理资源
    _G[scene_name].OnLevelWasLoaded()
end

function Main.MainFunc(go)
    xpcall(Main.MainRun, __G__TRACKBACK__)
end

--对c#开放的接口，监听后退按钮事件
function Main.OnKeyDownEscape()
    xpcall(Main.OnBackPressed, __G__TRACKBACK__)
end

-- 注册到全局，Csharp调用
_G.MainRequireLua = Main.MainRequireLua
_G.ReLoadLoading = Main.ReLoadLoading
_G.OnSceneUnloaded = Main.OnSceneUnloaded
_G.OnKeyDownEscape = Main.OnKeyDownEscape
_G.OnLevelWasLoaded = Main.OnLevelWasLoaded
_G.RemoveRequiredByName = Main.RemoveRequiredByName
-- print("注册到全局，Csharp调用")
return Main
