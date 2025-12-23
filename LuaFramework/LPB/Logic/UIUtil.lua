--require "Logic/IAPHelper"
require "Utils/Locker"

local json = require "cjson"

UIUtil = {}
UIUtil.ScreenWidth = 1080
UIUtil.ScreenHeight = 1920
UIUtil.BaseCameraSize = 960
UIUtil.parent = nil
UIUtil.top_ctrl = nil
UIUtil.machine_ctrl = nil
UIUtil.common_coin_end_obj = nil
UIUtil.common_diamond_end_obj = nil
UIUtil.HOME_LOADING_DELAY = 1.2
UIUtil.is_verticle = false --是否竖版

UIUtil.PRIVACY_URL = "http://www.triwingames.com/privacy_policy.html"
UIUtil.SERVICE_URL = "http://www.triwingames.com/terms_of_service.html"
-- ！！！！！！！上线前需要修改！！！！！！！！！！！
-- UIUtil.RATEAPP_URL = (AppConst.HTTP_SERVER_IP or "" ).. "version/gotoAppStore"
UIUtil.FAN_URL = "https://www.facebook.com/TripleWinSlots/"
UIUtil.EXP_SMOOTH_TIME = 0.3
UIUtil.SPIN_SMOOTH_TIME = 0.3
UIUtil.COMMON_COIN_SCROLL_TIME = 2--金币滚动时间
--WAVE
UIUtil.WAVE_TIME = 1.3--飞的时间
UIUtil.WAVE_DELAY_TIME = 0.05--生成间隔时间
UIUtil.WAVE_SUM = 10--生成数量
UIUtil.WAVE_SUM_DIAMOND = 3 -- 生成钻石数量
UIUtil.FACEBOOK_PORTRAIT = nil
UIUtil.FACEBOOK_PORTRAIT_KEY_IN_PLAYERPREFS = "fb portrait"
UIUtil.NOTIFICATION_KEY_IN_PLAYERPREFS = "notification"
UIUtil.delay_loading = 0.25 -- 超时后出loading条的时间
UIUtil.loading_time = 1.25
UIUtil.IS_FIRST_JUMP_HOME = false --只有第一次正常进入home时会出帘子

UIUtil.coin_timers = {}
UIUtil.flying_coins = {}
UIUtil.flying_coin_tweeners = {}
UIUtil.flying_coins_type = "ef_coinprize_coin"
UIUtil.flying_particle_type = "ef_coinprize_particle"
UIUtil.easter_egg_hammer_icon_pos = nil

UIUtil.COIN_POSITION = {
    DEFAULT = 1,
    TOPRIGHT = 2,
    CENTER = 3,
    FLUID = 4,
    BOTTOMRIGHT = 5,
    BOTTOMMIDDLE = 6,
    LEVELUP = 7,
    BigWin = 8,
    MegaWin = 9,
    LegendaryWin = 10,
    StarFishType = 11,
    SevenDayReturn = 12
}

UIUtil.mail_get_award_click = false         -- 邮件Reward奖励.
UIUtil.open_online_reward = false           -- Instant Reward


function UIUtil.init(topview, start_coin_obj, start_diamond_obj)
    UIUtil.parent = SceneViewManager.effect_layer
    UIUtil.common_coin_end_obj = start_coin_obj
    UIUtil.coin_end_obj_pos = start_coin_obj.position
    UIUtil.common_diamond_end_obj = start_diamond_obj
    UIUtil.diamond_end_obj_pos = start_diamond_obj.position
    UIUtil.img_requst_coroutine = {}
    UIUtil.coroutine_index = 0
    UIUtil.top_ctrl = topview
    Panel.reg_exit_callback(function()
        UIUtil.clear_all_coins()
        UIUtil.clear_coroutine()
    end)

    UIUtil.FACEBOOK_PORTRAIT = fun.read_value(UIUtil.FACEBOOK_PORTRAIT_KEY_IN_PLAYERPREFS)
    UIUtil.fake_lobby_show_request = 0
end

function UIUtil.clear_all_coins()
    for k, v in pairs(UIUtil.coin_timers) do
        v:Stop()
    end
    UIUtil.coin_timers = {}

    for k, v in pairs(UIUtil.flying_coin_tweeners) do
        v:Kill()
    end
    UIUtil.flying_coin_tweeners = {}

    for k, v in pairs(UIUtil.flying_coins) do
        Destroy(v)
    end
    UIUtil.flying_coins = {}
end
--按照贝塞尔曲线运动
function UIUtil.BezierMove(sourceObj, EndPosObj, x_factor, y_factor, speed, path_type, ease, completeFunction)

    local startPos = fun.get_gameobject_pos(sourceObj, false)
    local endPos = fun.get_gameobject_pos(EndPosObj, false)
    local distance = math.abs(startPos.x - endPos.x) + math.abs(startPos.y - endPos.y)
    local path = {}
    path[1] = fun.calc_new_position_between(startPos, endPos, x_factor, y_factor, 0)
    path[#path + 1] = endPos
    Anim.bezier_move(sourceObj, path, distance / speed, 0, path_type, ease, completeFunction)
end
function UIUtil.ThrowMove(sourceObj, EndPosObj, x_factor, y_factor, speed, completeFunction)
    local startPos = fun.get_gameobject_pos(sourceObj, false)
    local endPos = fun.get_gameobject_pos(EndPosObj, false)
    local distance = math.abs(startPos.y - endPos.y)
    local path = {}
    path[1] = startPos
    path[2] = fun.calc_new_position_between(startPos, endPos, x_factor, y_factor, 0)
    path[3] = endPos
    Anim.throw_move(sourceObj, path, distance / speed, completeFunction)
end
--贝塞尔曲线运动
function UIUtil.BezierBaseMove(sourceObj, controlObj, EndPosObj, deltaTime, ease, completeFunction)

    local startPos = fun.get_gameobject_pos(sourceObj, false)
    local endPos = fun.get_gameobject_pos(EndPosObj, false)
    local controlPos = fun.get_gameobject_pos(controlObj, false)
    local path = {}
    path[1] = controlPos
    path[2] = endPos
    Anim.bezier_move(sourceObj, path, deltaTime, 0, 1, ease, completeFunction)
end

--飘金币 coin_asset=要飘得金币obj init_pos=金币初始化位置 pos_tbl=飘动时经过的点 wave_time=每个金币飘动时间 coin_sum=飘动的金币总数量 create_delay=实例化每个金币的延迟
function UIUtil.wave_move_multi_coins(coin_asset, init_pos, radius, from_scalex, from_scaley, to_scale, pos_tbl, wave_time, coin_sum, create_delay, parent, callback)
    for i = 1, coin_sum do
        Invoke(function()

            local coin = SceneGame.CM:create(AssetList.M19999Effects, coin_asset)
            fun.set_parent(coin, parent)
            local child_go = fun.get_child(coin, 0).gameObject
            fun.set_gameobject_scale(coin, 1, 1, 1)
            fun.set_gameobject_scale(child_go, from_scalex, from_scaley, from_scalex)
            Anim.scale(child_go, to_scale, to_scale, to_scale, wave_time, true)
            local x = init_pos.x + (math.random() * 2 - 1) * radius
            local y = init_pos.y + (math.random() * 2 - 1) * radius
            fun.set_gameobject_pos(coin, x, y, init_pos.z, false)
            local tweener = Anim.bezier_move(coin, pos_tbl, wave_time, 0, 1, 2, function()
                --UISound.play("coin_add")
                SceneGame.CM:remove_cell_effect(coin, true)
                if callback then
                    callback(i / coin_sum)
                end
            end)

            tweener:SetUpdate(false)
        end, create_delay * i)
    end
end

--飘金币 coin_asset=要飘得金币obj init_pos=金币初始化位置 pos_tbl=飘动时经过的点 wave_time=每个金币飘动时间 coin_sum=飘动的金币总数量 create_delay=实例化每个金币的延迟
function UIUtil.wave_coin(coin_asset, init_pos, pos_tbl, wave_time, coin_sum, create_delay, parent, callback, unscale_time)
    local timer = InvokeRepeat(function()
        local coin = fun.get_instance(coin_asset)
        fun.set_parent(coin, parent, true)
        fun.set_active(coin, true)
        fun.set_gameobject_scale(coin, 1, 1, 1)
        fun.set_gameobject_rot(coin, 0, 0, 0)
        fun.set_gameobject_pos(coin, init_pos.x, init_pos.y, init_pos.z, false)

        table.insert(UIUtil.flying_coins, coin)
        local tweener = Anim.bezier_move(coin, pos_tbl, wave_time, 0, 1, 5, function()
            --UISound.play("coin_add")
            fun.remove_table_item(UIUtil.flying_coins, coin)
            Destroy(coin) --直接删除金币如果美术觉得特效立即消失不好就先隐藏coin,然后定时destroy
            if callback then
                callback()
            end
            fun.remove_table_item(UIUtil.flying_coin_tweeners, tweener)
        end)

        tweener:SetUpdate(unscale_time or false)

        table.insert(UIUtil.flying_coin_tweeners, tweener)
    end, create_delay, coin_sum)
    table.insert(UIUtil.coin_timers, timer)
end

--big win 飞金币动画
function UIUtil.common_wave_to_top_and_show_tip(start_position, path, position, is_diamond, coinCnt, winType)
    log.r("start_position", start_position)
    local para = ArtConfig.COIN_FLY_PARAMETER[position]
    local duration = para.time
    local coin_count = para.count
    local interval = para.interval

    local end_pos
    if is_diamond then
        end_pos = UIUtil.diamond_end_obj_pos
    else
        end_pos = UIUtil.coin_end_obj_pos
    end

    if #path == 0 then
        path[1] = fun.calc_new_position_between(start_position, end_pos, 0.45, 1, 0)
    end
    path[#path + 1] = end_pos

    --UIUtil.judge_fly_coins_type(winType)
    local ef_bigwin_prize_loop = nil
    local ef_bigwin_prize_loop_child = nil
    UIUtil.wave_move_multi_coins(UIUtil.flying_coins_type, start_position, 540, 2, 2, 1, path, duration, coin_count, interval, SceneViewManager.effect_layer, function(scale)
        if ef_bigwin_prize_loop == nil then

            ef_bigwin_prize_loop = Cache.create(AssetList.M19999Effects, "ef_bigwin_prize_loop")

            fun.set_parent(ef_bigwin_prize_loop, SceneViewManager.effect_layer)
            fun.set_gameobject_pos(ef_bigwin_prize_loop, end_pos.x, end_pos.y, end_pos.z, false)
            fun.set_gameobject_scale(ef_bigwin_prize_loop, 1, 1, 1)
            ef_bigwin_prize_loop_child = {}
            for i = 0, fun.get_child_count(ef_bigwin_prize_loop) - 1 do
                table.insert(ef_bigwin_prize_loop_child, fun.get_child(ef_bigwin_prize_loop, i))
            end
        end

        local endScale = 2.5
        local startScale = 1
        local value = (endScale - startScale) * scale + startScale
        for i = 1, #ef_bigwin_prize_loop_child do
            fun.set_gameobject_scale(ef_bigwin_prize_loop_child[i], value, value, value)
        end

    end)

    UIUtil.wave_move_multi_coins(UIUtil.flying_particle_type, start_position, 700, 0.8, 1.5, 0.3, path, duration, coin_count / 2, interval * 2, SceneViewManager.effect_layer)

    Invoke(function()
        Destroy(ef_bigwin_prize_loop)
        local ef_bigwin_prize_end = Cache.create(AssetList.M19999Effects, "ef_bigwin_prize_end")
        fun.set_parent(ef_bigwin_prize_end, SceneViewManager.effect_layer)
        fun.set_gameobject_pos(ef_bigwin_prize_end, end_pos.x, end_pos.y, end_pos.z, false)
        fun.set_gameobject_scale(ef_bigwin_prize_end, 1, 1, 1)
        Invoke(function()
            Destroy(ef_bigwin_prize_end)
        end, 1.5)
    end, duration + interval * coin_count)

end

function UIUtil.move_to_table_pos(obj, tab_pos, time)
    local delay_time_start = 0.1
    -- local average_time = time / #tab_pos
    local average_time = 0.3

    local tween_type = DG.Tweening.Ease.Flash
    for i = 1, #tab_pos do

        Invoke(function()
            if i == #tab_pos then
                local tween = obj.transform:DOLocalMove(tab_pos, average_time):SetEase(tween_type):OnComplete(function()
                    -- Destroy(obj)
                    log.log("到达最后目标")
                end)
            else
                local tween = obj.transform:DOLocalMove(tab_pos, average_time):SetEase(tween_type)
            end
        end, delay_time_start + 0.1 * i)


    end
end

function UIUtil.animate_coin_to(parent, from, callback, to_obj)

    local num = 20;
    local particleNum = 40;
    local deltaTime = 2;
    local deltaTime2 = 0.3;
    local startR = 10;
    local endR = 350;
    local PendR = 450;
    local ScaleR = 0.6;
    local PscaleR = 0.4;
    local ease = DG.Tweening.Ease.OutQuint;

    local during = 1;
    local duringScale = 0.4;
    local flyEase = DG.Tweening.Ease.InCirc;

    local startEffect = Cache.create(AssetList.M19999Effects, "ef_collect_coin_start")

    if (fun.is_null(startEffect)) then
        if callback then
            callback()
        end
        log.r("startEffect is nil ")
        return
    end

    fun.set_parent(startEffect, SceneViewManager.effect_layer)
    startEffect.transform.position = from.transform.position
    fun.set_gameobject_scale(startEffect, 1, 1, 1)

    -- local to  = UIUtil.common_coin_end_obj
    local to = to_obj or UIUtil.common_coin_end_obj
    local end_pos = to.transform.position
    local ef_bigwin_prize_loop = nil
    local ef_bigwin_prize_loop_child = nil
    local EndScale = 1.5
    local effect_end_tab = {}
    local has_creat_end_effect = false
    local to_delete = false

    local creat_end = function()
        if has_creat_end_effect then
            return
        end

        has_creat_end_effect = true
        local delay_time = 0

        for i = 1, 3 do
            Invoke(function()
                local end_effect = Cache.create(AssetList.M19999Effects, "ef_LoginReward_prize_end")
                fun.set_parent(end_effect, SceneViewManager.effect_layer)
                fun.set_gameobject_pos(end_effect, end_pos.x, end_pos.y, end_pos.z, false)
                fun.set_gameobject_scale(end_effect, 1, 1, 1)
                effect_end_tab = effect_end_tab or {}
                local cout = GetTableLength(effect_end_tab)
                effect_end_tab[cout + 1] = end_effect
            end, delay_time + i * 0.2)
        end
    end

    local time1 = UIUtil.animate_boom_fly_to(parent, from, to, "ef_coinprize_coin", num, startR, ScaleR, endR, deltaTime, deltaTime2, ease, during, duringScale, flyEase, function(num)
        UISound.play("coinup_fast")
    end, 0.3)

    local time2 = UIUtil.animate_boom_fly_to(parent, from, to, "ef_coinprize_particle_small", particleNum, 0, PscaleR, PendR, deltaTime, deltaTime2, ease, during, duringScale, flyEase, function()
        UISound.play("coinup_fast")
        creat_end()
    end, 0.3)

    local time = math.max(time1, time2)

    Invoke(function()
        Invoke(function()
            for i = 1, #effect_end_tab do
                Destroy(effect_end_tab[i])
            end
            effect_end_tab = nil
        end, 1)

        Invoke(function()
            to_delete = true
            Destroy(startEffect)
            -- Destroy(ef_bigwin_prize_end)
            Destroy(ef_bigwin_prize_loop)
        end, 0.6)

        if callback then
            callback()
        end
    end, time)

end

function UIUtil.animate_boom_fly_to(parent, from, to, asset_name, num, startR, ScaleR, endR, deltaTime, flydelay, ease, flyduring, flyduringscale, flyease, callBack, destroy_time)

    local getRandom = function(r)
        local scale = math.random(-1000, 1000)
        local ans = scale / 1000 * r
        return ans
    end
    local getScale = function(r)
        return (getRandom((1.0 - r) / 2.0) + r + (1.0 - r) / 2.0);
    end
    local getR = function(r)
        local x = getRandom(r);
        local y = math.sqrt(r * r - x * x);
        if math.random(0, 1) < 0.5 then
            y = -y;
        end
        return Vector3.New(x, y, 0);
    end
    local maxTime = 0
    local count = 0

    for i = 1, num do
        local can_play = nil
        if i == 1 then
            can_play = true
        else
            can_play = false
        end
        local item = Cache.create(AssetList.M19999Effects, asset_name);
        fun.set_parent(item, parent)
        fun.set_active(item, true)
        item.transform.position = from.transform.position
        local pos = item.transform.localPosition
        item.transform.localPosition = Vector3.New(getRandom(startR) + pos.x, getRandom(startR) + pos.y, pos.z);
        local scale = getScale(ScaleR);
        local tween = item.transform:DOLocalMove(pos + getR(endR) * scale, deltaTime):SetEase(ease):OnComplete(function()
            if callBack and can_play then
                callBack()
            end
        end)

        local flyTime = flyduring * getScale(flyduringscale)
        if (flyTime >= maxTime) then
            maxTime = flyTime
        end

        Invoke(function()
            tween:Kill()
            local destroy_time = destroy_time or 0.6
            item.transform:DOMove(to.transform.position, flyTime):SetEase(flyease):OnComplete(function()
                Invoke(function()
                    Destroy(item)
                end, destroy_time)
                if callBack and can_play then
                    callBack()
                end
            end)
        end, flydelay)
    end
    return maxTime + flydelay
end

function UIUtil.animate_diamond_to(target, time, callback)

end

function UIUtil.play_electric_effect(from_go, to_go, offset)
    --龙凤机台 播放闪电特效  offset 为相对to_go的距离
    UISound.play("el_retrigger")
    local effect_go = UIUtil.play_A2B_effect("ef_Jackpot_lighting", from_go, to_go, 0.3, offset)
    return effect_go
end

function UIUtil.play_chilli_fire_effect(from_go, to_go, offset, callBackFunction)
    --辣椒人机台 播放火焰特效 offset 为相对to_go的距离
    local effect_go = UIUtil.play_A2B_effect("ef_rapidchilli_jackpot_fireline", from_go, to_go, 1, offset, callBackFunction)
    return effect_go
end

function UIUtil.play_A2B_effect(effect_name, from_go, to_go, destroy_delay_time, offset, callBackFunction)
    --播放从A点连接B点的特效
    local effect_go = SceneGame.CM:create_cell_effect(effect_name)
    local imageUVChangeAnimation = fun.get_component(effect_go, fun.IMAGEUVCHANGEANIMATION)
    fun.set_parent(effect_go, from_go, true)
    if offset == nil then
        offset = Vector3.New(0, 0, 0)
    end

    if callBackFunction ~= nil then
        Invoke(callBackFunction, imageUVChangeAnimation.playTime)
    end

    imageUVChangeAnimation:playAnimation(from_go, to_go, offset)
    Invoke(function()
        SceneGame.CM:remove_cell_effect(effect_go, true)
    end, destroy_delay_time)
    return effect_go
end

function UIUtil.normalize_angle(angle)
    while angle < 0 do
        angle = angle + 360
    end

    while angle > 360 do
        angle = angle - 360
    end

    return angle
end

function UIUtil.reconnect()
    Facade.SendNotification(NotifyName.Common.Reconnection)
end

function UIUtil.return_to_login(callback)
    UIUtil.LoadLogin(callback)
end

function UIUtil.return_to_scenehome()
    LuaTimer:Clear()
    Event.Brocast(Notes.QUIT_BATTLE)
    local scene = fun.get_active_scene()
    if scene.name ~= "SceneHome" then
        LoadScene("SceneHome", ViewList.SceneLoadingHomeView, true)
    else
        Facade.SendNotification(NotifyName.SceneLoading.ExitLoadingGame)
        --LoadScene("SceneHome",ViewList.SceneLoadingHomeView,true)
    end
end

function UIUtil.LoadLogin(callback)
    if fun.get_active_scene().name == "SceneGame" or fun.get_active_scene().name == "SceneHangUp" then
        LuaTimer:Clear()
        Event.Brocast(Notes.QUIT_BATTLE)
    end
    Http.init()
    LoadSceneAsync("SceneLoading", ProcedureCommonLoading:New(),function(operation)
        if (callback) then
            callback()
        end
        -- operation.allowSceneActivation = true
        
    end,true)
    ModelList.GuideModel:Close()
    ModelList.PopupModel:RemoveAllPopup()
    Network.ResetReconnect()
end

function UIUtil.request_url_portrait(url, callback, server_md5)
    if not url then
        return nil
    end

    local downloader = SuperDownloader.create("", url, 0, server_md5)
    local loader = WWWSpriteLoader.create()
    downloader:add_event_listener(SuperDownloader.DownloadSuccess, function(arg)
        loader:run(arg.LocalPath, function(sprite)
            if not sprite then
                log.r("头像请求失败，路径：" .. arg.LocalPath)
                return nil
            end
            callback(sprite)
        end)
    end)
    downloader:add_event_listener(SuperDownloader.DownloadFail, function(arg)
        log.r(arg.LocalPath .. " 尝试加载失败 " .. arg.Error.ErrorMsg)
    end)

    downloader:run()
    return downloader, loader
end

function UIUtil.fix_path(path)
    --if UnityEngine.Application.platform  == UnityEngine.RuntimePlatform.Android then
    return [[file://]] .. path
    --else
    --    return path
    -- end
end

function UIUtil.clear_coroutine()
    UIUtil.coroutine_index = 0
    for i, v in pairs(UIUtil.img_requst_coroutine) do
        fun.stop(v)
    end
end


-- 判断路径是否为网络url
function UIUtil.is_url(text)

    local prefix = "http"
    local min_char_count = #prefix

    if #text < min_char_count then
        return false
    end

    return string.sub(text, 1, min_char_count) == prefix
end

function UIUtil.cache_facebook_portrait()
    -- FB头像地址是url格式
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if UIUtil.is_url(userInfo.avatar) then
        UIUtil.FACEBOOK_PORTRAIT = userInfo.avatar
        fun.save_value(UIUtil.FACEBOOK_PORTRAIT_KEY_IN_PLAYERPREFS, userInfo.avatar)
    end
end

function UIUtil.get_facebook_portrait()
    return fun.read_value(UIUtil.FACEBOOK_PORTRAIT_KEY_IN_PLAYERPREFS)
end

function UIUtil.copy_text_to_clipboard(text)
    PlatformTool.CopyTextToClipboard(text)
end

function UIUtil.get_clipboard_text()
    return PlatformTool.GetTextOnClipboard()
end

function UIUtil.get_client_version()
    return LuaHelper.GameVersion
end


--超过delay时间后显示loading
function UIUtil.begin_loading_delay(delay)
    UIUtil.stop_loading_delay()
    if delay == 0 then
        fun.set_active(Panel.loading_mask, false)
    end
    UIUtil.loading_delay = Invoke(function()
        Panel.show_loading()
        UIUtil.loading_delay = nil
        UIUtil.showing_loading = true
        UIUtil.begin_loading_time = now_millisecond()
    end, delay)
end

function UIUtil.stop_loading_delay(callback)
    if UIUtil.loading_delay then
        UIUtil.loading_delay:Stop()
        UIUtil.loading_delay = nil
    end
    if UIUtil.showing_loading then
        local cur_time = now_millisecond()
        local time = (cur_time - UIUtil.begin_loading_time) / 1000
        if UIUtil.hide_loading then
            UIUtil.hide_loading:Stop()
            UIUtil.hide_loading = nil
        end
        if time > UIUtil.loading_time then
            Panel.hide_loading()
            UIUtil.showing_loading = nil
            if callback then
                callback()
            end
        else
            log.y("UIUtil.stop_loading_delay-invoke1", UIUtil.loading_time - time)
            local delay = UIUtil.loading_time - time
            if (delay <= 0) then
                delay = UIUtil.loading_time
            elseif (delay > UIUtil.loading_time) then
                delay = UIUtil.loading_time
            end
            log.y("UIUtil.stop_loading_delay-delay", delay)
            UIUtil.hide_loading = Invoke(function()
                Panel.hide_loading()
                UIUtil.showing_loading = nil
                if callback then
                    callback()
                end
            end, delay)
        end
    else
        if callback then
            callback()
        end
    end
end

function UIUtil.show_common_tip(msg)
    SceneViewManager.show_dialog("CommonTips", { message = msg })
end

function UIUtil.fade_in(go, duration, delay, callback)
    delay = delay or 0
    local canvas_group = fun.get_component(go, "CanvasGroup")
    canvas_group.alpha = 0
    local to = 1
    Anim.canvas_fade(canvas_group, to, duration, delay, function()
        if callback then
            callback()
        end
    end)
end

function UIUtil.anim_preload_slider(from, to, time, callback)
    local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    local load_slider_obj = fun.find_child(game_ui, "PreloadPanel/GameSlider")
    local load_slider = fun.get_component(load_slider_obj, fun.SLIDER)
    local load_percentage = fun.get_component(fun.find_child(game_ui, "PreloadPanel/GameSlider/txt_percent"), fun.TEXT)

    load_slider.value = from
    load_percentage.text = (from * 100) .. "%"

    Anim.slide_to(load_slider, load_percentage, to * 100, time, function()
        if callback then
            callback()
        end
    end)
end

function UIUtil.get_big_version()
    return UnityEngine.Application.version
end

function UIUtil.get_small_version()
    return MyGame.VersionReader.GetLobbyVersion()
end

function UIUtil.get_install_version()
    return UnityEngine.Application.version .. "." .. MyGame.VersionReader.GetLobbyVersionInPack()
end

--设备分数
function UIUtil.get_phone_score()
    return UnityEngine.PlayerPrefs.GetInt("mobile_score", -1)
end

--内存大小
function UIUtil.get_memory_size()
    return UnityEngine.SystemInfo.systemMemorySize;
end

--通用弹窗
function UIUtil.show_common_popup_with_options(options)
    options = options or {}
    options.okType = 1
    if options.isSingleBtn ~= nil and not options.isSingleBtn then
        options.okType = 0
    end
    
    local popupView
    options.returnCb = function(view) popupView = view end
    Facade.SendNotification(NotifyName.Common.PopupDialogCustom, options)
    return popupView
end

--通用弹窗   Popup_Dialog    层级 2000
function UIUtil.show_common_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
    if ModelList.GuideModel:GetIns():GetCfgID() ~= 0 then
        UIUtil.show_common_global_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
        return
    end

    local type = 1
    if isSingleBtn ~= nil and not isSingleBtn then
        type = 0
    end
    local popupView = nil
    local returnPopupView = function(view)
        popupView = view
    end
    Facade.SendNotification(NotifyName.Common.PopupDialog, contentId, type, sureCallBack, cancelCallBack, returnPopupView,...)
    if contentId == 8011  then
        SDK.error_report_window()
    end
    return popupView
end

--通用弹窗，错误提示-     ErrorDialog   层级 4000,
function UIUtil.show_common_error_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
    if ModelList.GuideModel:GetIns():GetCfgID() ~= 0 then
        UIUtil.show_common_global_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
        return
    end
    local type = 2
    local popupView = nil
    local returnPopupView = function(view)
        popupView = view
    end
    if isSingleBtn ~= nil and not isSingleBtn then
        type = 3
    end
    Facade.SendNotification(NotifyName.Common.PopupDialog, contentId, type, sureCallBack, cancelCallBack,returnPopupView, ...)
    if contentId == 8006 or contentId == 8007 then
        SDK.error_report_window()
    end
    return popupView
end

--全局通用弹窗
function UIUtil.show_common_global_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
    --log.r("show_common_global_popup  1   "..contentId)
    Facade.SendNotification(NotifyName.Common.GlobalPopup, 1, contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
    if contentId == 8011  then
        SDK.error_report_window()
    end
end


--通用弹窗   Popup_Dialog    层级 2000 带有倒计时
function UIUtil.show_common_popup_count_down(contentId, isSingleBtn, sureCallBack, cancelCallBack,countDownTime ,  ... )
    log.log("提示弹窗出现" , contentId)
    if ModelList.GuideModel:GetIns():GetCfgID() ~= 0 then
        UIUtil.show_common_global_popup(contentId, isSingleBtn, sureCallBack, cancelCallBack, ...)
        return
    end

    local type = 1
    if isSingleBtn ~= nil and not isSingleBtn then
        type = 0
    end
    local popupView = nil
    local returnPopupView = function(view)
        popupView = view
    end
    -- Facade.SendNotification(NotifyName.Common.PopupDialog, contentId, type, sureCallBack, cancelCallBack, returnPopupView,...)
    Facade.SendNotification(NotifyName.Common.PopupDialogCountDown, contentId, type, sureCallBack, cancelCallBack, returnPopupView, countDownTime,...)
    if contentId == 8011  then
        SDK.error_report_window()
    end
    return popupView
end
