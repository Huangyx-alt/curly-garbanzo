AppPauseUtil = {}

local focus_losed = true

local focusCoroutine = nil
local pauseCoroutine = nil
local client_version = nil

function AppPauseUtil:GetFocus()
    return focus_losed
end


-- android 使用手势操作关掉APP 不触发OnApplicationQuit
function AppPauseUtil.OnApplicationFocus(focus)

    focus_losed = focus
    --[[
    if(IAPHelper.is_purchase == true)then
        -- 支付过程中不处理事件
        return
    end
    --]]
    log.y("OnApplicationFocus")
    if not client_version  and   UIUtil ~= nil  then
            client_version = UIUtil.get_client_version()
    end
    if UIUtil ~= nil then
        Http.report_event("on_application_focus", {view = "",version = client_version or "1.17.0",state = focus and "true" or "false"})
    end
    if focus then
        Facade.SendNotification(NotifyName.Net.CheckNetState)
        Facade.SendNotification(NotifyName.Net.CheckNetFocus)
        if focus and  UnityEngine.Application.platform  ~= UnityEngine.RuntimePlatform.WindowsEditor then
            -- Http.fetch_reward_info()  TODO 更新奖励原tripleiwin逻辑
            --NotificationUtil.cancel_all_notifications()
        end
    else
        Network.focus_time = os.time()
    end
    --if focus == true then
    if focusCoroutine then
        coroutine.stop(focusCoroutine)
    end
    focusCoroutine=  coroutine.start(function()
        coroutine.wait(0.3)
        local view_list = GetActivatedViewList()
        local version = client_version
        for key, value in pairs(view_list) do
            if value and fun.is_not_null(value.go) and value.OnApplicationFocus  then
                local viewName = "no"
                if value.bundleName then
                    viewName = value.bundleName
                elseif  value.go and fun.is_not_null(value.go) then
                    viewName = value.go.name
                end
                if UIUtil ~= nil then
                    Http.report_event("on_application_focus_view", {view = viewName,version = version or "1.17.0"})
                end
                --log.r("OnApplicationFocus "..viewName)
                value:OnApplicationFocus(focus)
            end
        end
        focusCoroutine = nil
    end)
    --else
    --    local view_list = GetActivatedViewList()
    --    for key, value in pairs(view_list) do
    --        if value and fun.is_not_null(value.go) and value.OnApplicationFocus  then
    --            value:OnApplicationFocus(focus)
    --        end
    --    end
    --end
end

AppPauseUtil.pausetime =  0

function AppPauseUtil.OnApplicationPause(pause)

    --log.y("OnApplicationPause",pause)
    if not client_version  and UIUtil ~= nil then
        client_version = UIUtil.get_client_version()
    end
    if UIUtil ~= nil then
        Http.report_event("on_application_pause", {view = "",version = client_version or "1.17.0" ,state = pause and "true" or "false"})
    end
    if LuaNotifications ~= nil then
        LuaNotifications:OnApplicationPause(pause)
    end
    if(pause == false)then  --后台切换回来
        --AdUtil.app_wakeup(os.time() - AppPauseUtil.pausetime)
        Facade.SendNotification(NotifyName.Net.CheckNetFocus)
        AppPauseUtil.SendResumeMsg()
    else                      -- 后台暂停
        AppPauseUtil.pausetime = os.time()
        AppPauseUtil.SendPauseMsg()
        --NotificationUtil.send_notifications()
    end
    --if pause == false then --后台切换回来 ,延迟刷新
    if pauseCoroutine then
        coroutine.stop(pauseCoroutine)
    end
    pauseCoroutine=  coroutine.start(function()
        coroutine.wait(0.3)
        local view_list = GetActivatedViewList()
        local version = client_version
        for key, value in pairs(view_list) do
            if value and fun.is_not_null(value.go) and value.OnApplicationPause  then
                local viewName = "no"
                if value.bundleName then
                    viewName = value.bundleName
                elseif  value.go and fun.is_not_null(value.go) then
                    viewName = value.go.name
                end
                if UIUtil ~= nil then
                    Http.report_event("on_application_pause_view", {view = viewName,version = version})
                end
                value:OnApplicationPause(pause)
            end
        end
    end)
    --else
    --    local view_list = GetActivatedViewList()
    --    for key, value in pairs(view_list) do
    --        if value and fun.is_not_null(value.go) and value.OnApplicationFocus  then
    --            value:OnApplicationPause(pause)
    --        end
    --    end
    --end



end

function AppPauseUtil.SendPauseMsg()
end

function AppPauseUtil.SendResumeMsg()
end


function AppPauseUtil.OnApplicationQuit()
    log.r(" AppPauseUtil.OnApplicationQuit()")
    --NotificationUtil.send_notifications()
    local view_list = GetActivatedViewList()
    for key, value in pairs(view_list) do
        value:OnApplicationQuit()
    end

end
