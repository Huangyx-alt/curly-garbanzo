---
--- 用于弹窗和界面入栈出栈的管理，back键功能，以及场景跳转和场景通用父物体的存储
--- Created by zlc.
--- DateTime: 2020/8/6 9:58
---
require "Utils.AssetList"

SceneViewManager = {}
local this = SceneViewManager
SceneViewManager.viewList = {}            --存储所有的view
SceneViewManager.cacheViewList = {}       --存储所有的bindview
SceneViewManager.sceneViewList = {}       --可以跨场景的UI
SceneViewManager.page_list = {}           --存储所有的界面和弹窗--当前场景名字
SceneViewManager.prev_scene_name = nil    --上一个场景名字
SceneViewManager.current_scene_name = nil --当前场景名字

SceneViewManager.rootCanvas = nil
SceneViewManager.page_layer = nil  ---UI root
SceneViewManager.gobal_layer = nil
SceneViewManager.BlackCamera = nil --跨场景用来刷新GL的cammer,防止花屏

local currentMachineDialogView = nil

SceneViewManager.ViewWhiteList = {
    "WaitLoadingView",
    "SceneLoadingGameView",
    "SceneLoadingHomeView",
}

--获取当前(最高层级)的对话界面，弹出界面等其他界面不算。
--有可能是nil，得看实际ui打开的情况，要获取上一个界面可以先用该方法保存起来，
--再打开另一界面，保存起来的界面就是上个界面
function SceneViewManager.GetCurMachineDialogView()
    return currentMachineDialogView
end

function CleanSceneRes(scene_name)
    if scene_name then
        local ab_name = AssetList[scene_name] --"luaprefab_scene"
        if ab_name then
            --Done LwangZg 资源卸载
            ResourcesManager:UnloadAsset(ab_name, true)
            -- resMgr:UnloadAssetBundle(ab_name, true)
            CanvasSortingOrderManager.Clean()
        else
            if scene_name ~="SceneLoading"  then
                log.r("ab_name is nil scene_name: " .. scene_name)
            end
        end
    end
end

function InitBlackCamera()
    if (SceneViewManager.BlackCamera == nil) then
        SceneViewManager.BlackCamera = fun.GameObject_find("BlackCamera")
    end
    if (SceneViewManager.BlackCamera) then
        fun.set_active(SceneViewManager.BlackCamera, true)
    end
end

function HideBlackCamera()
    if (SceneViewManager.BlackCamera == nil) then
        SceneViewManager.BlackCamera = fun.GameObject_find("BlackCamera")
    end
    if (SceneViewManager.BlackCamera) then
        fun.set_active(SceneViewManager.BlackCamera, false, 0.5)
    end
end

--加载场景loading  ,主要是loading场景
function LoadScene(scene_name, loadingView, isClean, procedure)
    Facade.SendNotification(NotifyName.ShowUI, loadingView, function()
        InitBlackCamera()
        if (isClean == nil) then
            isClean = true
        end

        SoundHelper.UnloadAllAudio()

        --SceneViewManager.prev_scene_name = SceneViewManager.current_scene_name
        --SceneViewManager.current_scene_name = scene_name
        --log.r("lxq 场景切换",tostring(SceneViewManager.prev_scene_name),">>>",tostring(SceneViewManager.current_scene_name))
        --UnityEngine.SceneManagement.SceneManager.LoadScene(scene_name)
        Util.ClearMemory()
        SceneViewManager.ClearView()
    end, nil, procedure)
end

function ImmediatelyLoadSceneByAb(scene_name, callback)
    if (AppConst.EditMode) then
        LoadScene(scene_name)
        if (callback) then
            callback()
        end
    else
        if (AppConst.EditMode and fun.IsEditor()) then
            LoadScene(scene_name) --编辑器模式直接跑Scene下面
            if (callback) then
                callback()
            end
        else
            local ab_name = AssetList[scene_name] --"luaprefab_scene"
            resMgr:LoadScene(ab_name, scene_name, function()
                if (callback) then
                    callback()
                end
                SceneViewManager.prev_scene_name = SceneViewManager.current_scene_name
                SceneViewManager.current_scene_name = scene_name
                log.r("lxq ImmediatelyLoadSceneByAb", tostring(SceneViewManager.prev_scene_name), ">>>",
                    tostring(SceneViewManager.current_scene_name))
                UnityEngine.SceneManagement.SceneManager.LoadScene(scene_name)
            end)
        end
    end
end

function LoadSceneEditor(scene_name, callback)
    SceneViewManager.prev_scene_name = SceneViewManager.current_scene_name
    SceneViewManager.current_scene_name = scene_name
    log.r("lxq 场景切换", tostring(SceneViewManager.prev_scene_name), ">>>", tostring(SceneViewManager.current_scene_name))
    local operation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(scene_name)
    callback(operation)
end

--[[
    @desc: load场影直接使用
    author:{author}
    time:2020-12-16 17:06:15
    --@scene_name:
	--@callback:
    @return:
]]
--异步读取一个场景
---@param scene_name string
---@param procedure any
---@param callback   fun(assetId:CS.SceneHandle|nil, err:string|nil)
---@param isActiveOnLoad bool|nil 是否加载完就激活
function LoadSceneAsync(scene_name, procedure, callback, isActiveOnLoad)
    isActiveOnLoad = isActiveOnLoad or false
    ProcedureManager.SetProcedure(procedure)
    if _G.ResourcesManager ~= nil then
        ResourcesManager:LoadSceneAsync(
            scene_name,
            function(handle, errMsg)
                if errMsg == nil then
                    print('ResourcesManager 去加载 %s ========================== ', scene_name)
                    callback(handle)
                end
            end,
            isActiveOnLoad
        )
    else
        --lpb这样做
        if (AppConst.IsEditorModel() and fun.IsEditor()) then
            LoadSceneEditor(scene_name, callback) --编辑器模式直接跑Scene下面
        else
            local ab_name = AssetList[scene_name] --"luaprefab_scene"
            if ab_name then
                log.g("LoadSceneAsync   LoadScene  " .. scene_name)
                resMgr:LoadScene(ab_name, scene_name, function()
                    SceneViewManager.prev_scene_name = SceneViewManager.current_scene_name
                    SceneViewManager.current_scene_name = scene_name
                    log.r("lxq 场景切换", tostring(SceneViewManager.prev_scene_name), ">>>",
                        tostring(SceneViewManager.current_scene_name))
                    local operation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(scene_name)
                    if callback then
                        callback(operation)
                    end
                end)
            else
                log.g("LoadSceneAsync   operation  " .. scene_name)
                local operation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(scene_name)
                if callback then
                    callback(operation)
                end
            end
        end
    end
end

function SceneViewManager.show_dialog(name)
    log.r("暂未实现")
    --Facade.SendNotification(NotifyName.ShowDialog,)
end

--[[
    @desc: 进游戏入口
    author:{author}
    time:2020-12-31 10:56:39
    --@machine_id:
    @return:
]]
function SceneViewManager.LoadSceneGameById(machine_id)
    --SceneViewManager.machineId =  machine_id
    --Facade.SendNotification(NotifyName.ShowUI,ViewList.SceneLoadingMachineView,function()
    --    Facade.SendNotification(NotifyName.LobbyCommand.PlayLobbyEffect,false)
    --    LoadScene("SceneLoadingGame")
    --end)
end

function SceneViewManager.SetCurrentSceneName(name)
    this.current_scene_name = name
end

function SceneViewManager.GetCurrentSceneName()
    return this.current_scene_name
end

function SceneViewManager.AddView(view, viewGo)
    if not view or type(view) ~= "table" then
        log.r("view is nil")
        return false
    end
    if not view:CanAddSceneViewManager() then
        return false
    end

    if view.viewType == CanvasSortingOrderManager.LayerType.Machine_Dialog then
        currentMachineDialogView = view
    end

    if (this.viewList[view.viewName]) then
        log.r("当前已经打开" .. view.viewName)
        return false
    end

    this.viewList[view.viewName] = view

    return true
end

function SceneViewManager.RemoveView(view)
    if view.viewName then
        this.viewList[view.viewName] = nil
    end
end

function SceneViewManager.ClearView()
    for i, v in pairs(this.viewList) do
        if (v and v.changeSceneClear and not SceneViewManager.IsCacheView(v.viewName)) then
            Facade.SendNotification(NotifyName.CloseUI, v)
        end
    end
    this.viewList = {}
end

function SceneViewManager.IsCacheView(name)
    for k, v in pairs(this.ViewWhiteList) do
        if (v == name) then
            return true
        end
    end
    return false
end

function SceneViewManager.on_back_pressed()
    if #this.page_list == 0 then
        return
    end
    local view = this.page_list[#this.page_list]
    if view.can_back_key_press_close == true then
        Facade.SendNotification(NotifyName.HideDialog, view)
    end
end

function SceneViewManager.AddPage(page)
    table.insert(this.page_list, page)
end

function SceneViewManager.PopPage()
    if #this.page_list == 0 then
        return
    end
    table.remove(this.page_list, #this.page_list)
end

-- sceneViewList
--[[
    @desc:
    author:{author}
    time:2020-12-23 09:59:04
    --@viewName:
    @return:
]]
function SceneViewManager.RemoveToGobalView(viewName)
    if (this.sceneViewList == nil) then
        this.sceneViewList = {}
    end
    local ret                    = this.sceneViewList[viewName]
    this.sceneViewList[viewName] = nil
    return ret
end

--[[
    @desc: 添加到全局VIEW,不会被场景销毁
    author:{author}
    time:2020-12-23 09:59:26
    --@viewGo:
    @return:
]]
function SceneViewManager.AddToGobalView(viewGo)
    if (this.sceneViewList == nil) then
        this.sceneViewList = {}
    end
    if (this.sceneViewList[viewGo.name]) then
        return
    end
    this.sceneViewList[viewGo.name] = viewGo
end

function SceneViewManager.RemoveToCache(viewName)
    if (this.cacheViewList == nil) then
        this.cacheViewList = {}
    end
    local ret                    = this.cacheViewList[viewName]
    this.cacheViewList[viewName] = nil
    return ret
end

function SceneViewManager.CheckViewIsCache(viewName)
    if (this.cacheViewList[viewName]) then
        return true
    end
    return false
end

function SceneViewManager.is_any_dialog_on()

end

function SceneViewManager.AddToCache(viewGo)
    if (this.cacheViewList == nil) then
        this.cacheViewList = {}
    end
    if (this.cacheViewList[viewGo.name]) then
        return
    end
    this.cacheViewList[viewGo.name] = viewGo
end

function SceneViewManager.IsLoadingScene()
    local sceneName = SceneViewManager.current_scene_name
    if (sceneName == "SceneHome" or sceneName == "SceneGame") then
        return false
    end
    return true
end

function SceneViewManager.IsGameScene()
    local sceneName = SceneViewManager.current_scene_name
    if (sceneName == "SceneGame") then
        return true
    end
    return false
end
