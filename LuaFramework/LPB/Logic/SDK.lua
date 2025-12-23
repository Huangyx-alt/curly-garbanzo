require "Logic.SDK.AppFlyerTracker"
require "Logic.SDK.FirebaseTracker"
require "Logic.SDK.TriwinBiTracker"
require "Logic.SDK.TapTicManager"
require "Logic.SDK.MaxAdTracker"
SDK = {}
SDK.af_tracker = AppFlyerTracker.create()
SDK.fb_tracker = FirebaseTracker.create()
SDK.bi_tracker = TriwinBiTracker.create()
SDK.max_ad_tracker = MaxAdTracker.create()
SDK.facebook = FaceBookHelper.Instance
SDK.AppleSign = AppleSignInHelper.Instance
SDK.ThinkingAppid = "2cde4b64fd7c4c099a29076726e76497"
SDK.ThinkingUrl = "https://tareport.triwingames.com"

SDK.last_send_error_time = -1


function SDK.login(callback)
    if fun.is_ios_platform() then --  and not SDK.facebook:CheckAttAuthorized() then
        SDK.limitLogin(callback)
    else
        SDK.facebook:Login(callback)
    end

    log.r("SDK.login")
end

function SDK.limitLogin(callback) SDK.facebook:LimitLogin(callback) end

function SDK.AppleSignlogin(callback)
    SDK.AppleSign:Login(callback)
    log.r("SDKAppleSignlogin.login")
end

--登录时带了邮箱地址
function SDK.SetFirebaseAnalyticsMail(mailAdress)
    SDK.AppleSign:SetFirebaseAnalyticsMail(mailAdress)
end

--引导评分
function SDK.AppleSignSocre()
    SDK.AppleSign:GoToComment()
end

function SDK.initThinkingData()
    --ThinkingAnalyticsHelper.Instance:initThinkingData(SDK.ThinkingAppid,SDK.ThinkingUrl) --打点
end

function SDK.refresh_access_token(callback) SDK.facebook:RefreshAccessToken(callback) end

function SDK.logout()
    SDK.facebook:LogOut()
end

function SDK.request_player_head_photo(callback) SDK.facebook:RequestUserPhoto(callback) end

function SDK.ShareLink(Url, title, content, photoUrl, callback)
    SDK.facebook:Share2Friend(Url, title, content, photoUrl,
        callback)
end

function SDK.InviteFriend(Url, callback) SDK.facebook:InviteFriend(Url, callback) end

function SDK.LogFbPurchase(packageName, priceAmount, priceCurrency)
    SDK.facebook:LogPurchaseFb(packageName, priceAmount, priceCurrency)
end

SDK.ad_played = false
SDK.ad_banner = nil
SDK.is_ad_playing = false

-- appflyer打点	含义解释
-- [C#]firstopen	首次启动
-- [C#]open	启动
-- login	登录
-- facebookregister	facebook注册用户
-- guestregister	游客注册用户
-- af_purchase	付费
-- [C#]remove	卸载
-- [C#]reward_video	激励视频
-- [C#]interstitial_video	插屏


--开发者标签，测试通知使用
function SDK.event_send_dev()
    --SDK.af_tracker:event_developer()
    SDK.fb_tracker:event_developer()
end

--登录
function SDK.event_login()
    --SDK.af_tracker:event_login()
    SDK.fb_tracker:event_login()
end

function SDK.event_login()
    --SDK.af_tracker:event_login()
    SDK.fb_tracker:event_login()
end

function SDK.event_facebooklogin_succeeded()
    --SDK.af_tracker:event_facebooklogin_succeeded()
    SDK.fb_tracker:event_facebooklogin_succeeded()
end

function SDK.event_facebooklogin_faileded()
    --SDK.af_tracker:event_facebooklogin_failed()
    SDK.fb_tracker:event_facebooklogin_failed()
end

--注册
function SDK.event_register()
    --SDK.af_tracker:event_register()
    SDK.fb_tracker:event_register()
end

function SDK.event_register_facebook()
    --SDK.af_tracker:event_facebookregister()
    SDK.fb_tracker:event_facebookregister()
end

function SDK.event_register_guest()
    --SDK.af_tracker:event_guestregister()
    SDK.fb_tracker:event_guestregister()
end

--进入大厅
function SDK.event_enter_lobby()
    local mark = fun.read_value("first_open")
    --log.r(" mark   "..tostring(mark))
    if mark ~= "false" then
        --没有标志位，说明是第一次登陆
        --PlayerTrackerData.set_first_open_mark()
        fun.save_value("first_open", "false")
        --af打点_安装后第一次打开
        --SDK.af_tracker:event_first_open()
        --SDK.fb_tracker:event_first_open()
        SDK.bi_tracker:first_open()
    end


    --SDK.af_tracker:event_day_first_lobby()
    --SDK.af_tracker:event_first_enter_lobby()
    --SDK.fb_tracker:event_enter_lobby()
    SDK.bi_tracker:enter_lobby()
end

--安装后第一次打开
function SDK.event_first_open()
    local mark = fun.read_value("first_open")
    if mark ~= "false" then
        --没有标志位，说明是第一次登陆
        --PlayerTrackerData.set_first_open_mark()
        fun.save_value("first_open", "false")
        --af打点_安装后第一次打开
        --SDK.af_tracker:event_first_open()
        --SDK.fb_tracker:event_first_open()
        SDK.bi_tracker:first_open()
    end
    --SDK.bi_tracker:app_open()
end

--第一次购买
function SDK.event_new_payer()
    local mark = UserData.get("first_pay")
    if not mark then
        --没有标志，说明是第一次消费
        PlayerTrackerData.set_first_pay_mark()
        UserData.set("first_pay", "false")
        --SDK.af_tracker:event_new_payer()
        SDK.fb_tracker:event_new_payer()
    end
end

--180天内付费次数
function SDK.event_pay_times_180(pay_times)
    SDK.fb_tracker:event_pay_times_180(pay_times)
    --SDK.af_tracker:event_pay_times_180(pay_times)
end

--7天内付费次数
function SDK.event_pay_times_7(pay_times)
    SDK.fb_tracker:event_pay_times_7(pay_times)
    --SDK.af_tracker:event_pay_times_7(pay_times)
end

function SDK.event_buy_money_180(money)
    --SDK.af_tracker:event_buy_money_180(money)
    SDK.fb_tracker:event_buy_money_180(money)
end


--事件
function SDK.event_download_begin(machine_id)
    --SDK.af_tracker:event_download_begin()
    SDK.bi_tracker:machine_download(machine_id)
end --下载机台

function SDK.event_download_end()
    --SDK.af_tracker:event_download_end()
end --下载机台

function SDK.event_into()
    --SDK.af_tracker:event_into()
    SDK.fb_tracker:event_into()
end --进入机台

function SDK.event_quit()
    SDK.fb_tracker:event_quit()
end

function SDK.event_bankrupt()
    --SDK.af_tracker:event_bankrupt()
    SDK.fb_tracker:event_bankrupt()
end --破产（持有金币<当前机台最小bet）

function SDK.event_game_break_payments(days)
    --SDK.af_tracker:event_game_break_payments(days)
    SDK.fb_tracker:event_game_break_payments(days)
end

--登陆天数
function SDK.event_login_days(days)
    --SDK.af_tracker:event_login_days(days)
    SDK.fb_tracker:event_login_days(days)
end

--连续登陆七天
function SDK.event_continuous_login()
    SDK.fb_tracker:event_continuous_login()
    --SDK.af_tracker:event_continuous_login()
end


--facebook用户每日登录
function SDK.event_day_fb_login()
    --SDK.af_tracker:event_day_fb_login()
end

--游客用户每日登录
function SDK.event_day_guest_login()
    --SDK.af_tracker:event_day_guest_login()
end

--每日首次进入大厅
--function SDK.event_enter_lobby()
--    SDK.af_tracker:event_day_first_lobby()
--    SDK.af_tracker:event_first_enter_lobby()
--    SDK.fb_tracker:event_enter_lobby()
--    SDK.bi_tracker:enter_lobby()
--end

-- wheel_open	首次出现转盘
function SDK.event_first_wheel_open()
    --SDK.af_tracker:event_first_wheel_open()
end

-- wheel_spin	首次点击spin转盘
function SDK.event_first_wheel_spin()
    --SDK.af_tracker:event_first_wheel_spin()
end

-- wheel_collect	首次获得转盘奖励
function SDK.event_first_wheel_collect()
    --SDK.af_tracker:event_first_wheel_collect()
end

-- wheel_end	首次结束转盘
function SDK.event_first_wheel_end()
    --SDK.af_tracker:event_first_wheel_end()
end

-- day_wheel_open	每日首次出现转盘
function SDK.event_day_wheel_open()
    --SDK.af_tracker:event_day_wheel_open()
end

-- day_wheel_spin	每日首次点击spin转盘
function SDK.event_day_wheel_spin()
    --SDK.af_tracker:event_day_wheel_spin()
end

-- day_wheel_collect	每日首次获得转盘奖励
function SDK.event_day_wheel_collect()
    --SDK.af_tracker:event_day_wheel_collect()
end

-- day_wheel_end	每日首次结束转盘
function SDK.event_day_wheel_end()
    --SDK.af_tracker:event_day_wheel_end()
end

--达到等级
function SDK.event_level(user_level)
    --SDK.af_tracker:event_level(user_level)
    SDK.fb_tracker:event_level(user_level)
    QuickQuestManager:collect(QuickQuestID.LevelUp)
end

-- 领取instant reward
function SDK.event_instant_reward()
    QuickQuestManager:collect(QuickQuestID.CollectInstant)
    QuestUtil.task_sync()
end

-- 领取store gift
function SDK.event_store_git()
    QuickQuestManager:collect(QuickQuestID.CollectStore)
    QuestUtil.task_sync()
end


function SDK.thought_DeepLinkopen(deeplink, adid, deviceid)
    SDK.bi_tracker:thought_DeepLinkopen(deeplink, adid, deviceid)
end

--01 26 direct_popup_show，direct_popup_close，direct_popup_button，direct_banne 事件关闭不打点上报


--导流弹窗奖励
function SDK.thought_DeepLinkRewardPush(dpRewardCodeID)
    SDK.bi_tracker:thought_DeepLinkRewardPush(dpRewardCodeID)
end


function SDK.OnAdIDismiss(str)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnAdIDismiss", str1)
    SDK.fb_tracker:event_dismiss_ad_i()
    AdUtil.use_ad_i_chances()
    AdUtil.reset_cd("ad_i")
    SDK.is_ad_playing = false
    Event.Brocast(EventName.Event_OnAdIDismiss)
    -- Panel.close_dialog_by_name("ADBreak")
end


function SDK.OnAdVShown(arg1)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnAdVShown", arg1)

    SDK.is_ad_playing = false
    SDK.pre_load_ad_v()
    Event.Brocast(EventName.Event_OnAdVShown)
    -- Panel.close_dialog_by_name("ADBreak")
end

function SDK.OnAdIFailed(arg1, arg2)
    SDK.is_ad_playing = false
    Event.Brocast(EventName.Event_OnAdIFailed)
    SDK.on_adi_faild()
    -- Panel.close_dialog_by_name("ADBreak")
    SDK.update_sdk_error(ErrorReport.ADI_LOAD_FAILD, arg1, arg2)
end

function SDK.update_sdk_error(error_type, arg1, arg2)
    local msg = ""
    if (arg1 ~= nil) then
        msg = msg .. "   arg1:" .. tostring(arg1)
    end
    if (arg2 ~= nil) then
        msg = msg .. "   arg2:" .. tostring(arg2)
    end
    log.y(error_type, msg)

    if (os.time() - SDK.last_send_error_time > 5) then
        SDK.last_send_error_time = os.time()
        Http.report_error(error_type, msg)
    end
end

function SDK.OnAdVFailed(arg1, arg2)
    SDK.is_ad_playing = false
    Event.Brocast(EventName.Event_OnAdVFailed)
    SDK.on_adv_faild()
    -- Panel.close_dialog_by_name("ADBreak")
    SDK.update_sdk_error(ErrorReport.ADV_LOAD_FAILD, arg1, arg2)
end

function SDK.OnAdVClick()
    SDK.fb_tracker:event_click_ad()
    SDK.is_ad_playing = false
    -- Panel.close_dialog_by_name("ADBreak")
end

function SDK.OnAdIClick(str1)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnAdIClick", str1)
    SDK.fb_tracker:event_click_ad()
    SDK.is_ad_playing = false
    -- Panel.close_dialog_by_name("ADBreak")
end

--C#调用接口


function SDK.event_ad_reward()
    SDK.fb_tracker:event_ad_reward()
end

function SDK.event_track_ad_popup(event_name)
    SDK.fb_tracker:track_event(event_name)
end

function SDK.OnAdVClose(str)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnAdVClose", str)
    Event.Brocast(EventName.Event_ad_close)
end

function SDK.TrackEvent_interstitial_video_loaded(str)
    SDK.fb_tracker:track_event("ad_interstitial_video_loaded")
end

function SDK.TrackEvent_reward_video_loaded(str)
    SDK.fb_tracker:track_event("ad_reward_video_loaded")
end

--- C#回调广告收入入口.jsonstr
-- jsonstr,mopub回调内容
-- {
--     "id": "1e4daf4b5e0b4712993c171ef0430138_002ecd1f009307d0",
--     "country": "HK",
--     "network_placement_id": "rewarded_low",
--     "adgroup_id": "a1767805a65d487394e78c50b92b2dd8",
--     "app_version": "1.0",
--     "adgroup_priority": 1,
--     "adunit_format": "Rewarded Video",
--     "adunit_name": "Rewarded",
--     "adgroup_type": "network",
--     "publisher_revenue": 5.0000000000000002e-05,
--     "network_name": "unity",
--     "precision": "publisher_defined",
--     "currency": "USD",
--     "adgroup_name": "unity_low",
--     "adunit_id": "48211b9af3774592aaa8822ff54c4ce4"
-- }
--[[
    @desc: 后期可以做为统计高价值用户使用
    author:{author}
    time:2021-03-19 17:14:12
    --@jsonstr:
    @return:
]]
function SDK._SaveTackData(jsonstr)
    local jasonstr_data = JsonToTable(jsonstr)
    local ad_revenue_rec = {}
    ad_revenue_rec.adunit_name = tostring(jasonstr_data.adunit_name)
    ad_revenue_rec.publisher_revenue = tonumber(jasonstr_data.publisher_revenue)
    ad_revenue_rec.id = tostring(jasonstr_data.id)
    ad_revenue_rec.timestamp = os.time()

    --- 判断广告类型 处理插屏和激励视频
    if ad_revenue_rec.adunit_name == "Satic" then
        --- 处理插屏广告
        GameUtil.log("AdUtil.SaveADIRecs(ad_revenue_rec)")
        -- AdUtil.SaveADIRecs(ad_revenue_rec)
    elseif ad_revenue_rec.adunit_name == "Rewarded" then
        --- 处理激励视频广告
        GameUtil.log("AdUtil.SaveADVRecs(ad_revenue_rec)")
        -- AdUtil.SaveADVRecs(ad_revenue_rec)
    end
end

function SDK.OnAdImpressionTracked(jsonstr)
    local data = {
        adType = SDK.last_adtype,
        adPos = SDK.last_adbanner,
        all = jsonstr
    }
    --事件打点_广告_观看广告
    SDK.bi_tracker:adView(data.adType, data.adPos, data.all)
    -- Http.report_event("adView", data)
end

function SDK.OnInterstitialShownEvent(str)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnInterstitialShownEvent", str)
end

function SDK.OnInterstitialExpiredEvent(str)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnInterstitialExpiredEvent", str)
end

function SDK.OnImpressionTrackedEvent(str)
    log.y("+++++++++++++++++++++++++++++++++++++++++++++++OnImpressionTrackedEvent", str)
end

SDK.last_adv_name = ""
SDK.last_adi_name = ""



function SDK.dis_adv(dialog)
    if (dialog) then
        SDK.fb_tracker:track_event("adi_dis" .. dialog)
    else
        log.y("+++++++++++++++++++++++++++++++++++++++++++++++dialog is nil")
    end
end

function SDK.on_adv_open(dialog)
    if (dialog) then
        SDK.last_adv_name = dialog
        SDK.last_adi_name = nil
        SDK.fb_tracker:track_event("adv_open_" .. dialog)
    else
        log.y("+++++++++++++++++++++++++++++++++++++++++++++++dialog is nil")
    end
end

function SDK.on_adi_open(dialog)
    if (dialog) then
        SDK.last_adv_name = nil
        SDK.last_adi_name = dialog

        SDK.fb_tracker:track_event("adi_open_" .. dialog)
    else
        log.r("dialog is nil")
    end
end

function SDK.on_adi_faild()
    if (SDK.last_adi_name) then
        SDK.fb_tracker:track_event("adi_faild_" .. SDK.last_adi_name)
        SDK.last_adi_name = nil
    else
        log.r("dialog is nil")
    end
end

function SDK.on_adv_faild()
    if (SDK.last_adv_name) then
        SDK.fb_tracker:track_event("adv_faild_" .. SDK.last_adv_name)
        SDK.last_adi_name = nil
    else
        log.y("+++++++++++++++++++++++++++++++++++++++++++++++dialog is nil")
    end
end

function SDK.banner_click(dialog)
    SDK.fb_tracker:track_event("banner_click_" .. dialog)
    SDK.bi_tracker:click_lobby_banner(dialog)
end

function SDK.show_promotion_dialog(dialog)
    if (dialog and dialog ~= "CtrlBase") then
        SDK.fb_tracker:track_event("show_" .. dialog)
        SDK.bi_tracker:open_Pannel(dialog)
    else
        log.y("+++++++++++++++++++++++++++++++++++++++++++++++dialog is nil")
    end
end

function SDK.close_promotion_dialog(dialog)
    if (dialog and dialog ~= "CtrlBase") then
        Event.Brocast(EventName.Event_Click_Close_Dialog, dialog)
        SDK.fb_tracker:track_event("close_" .. dialog)
    else

    end
end

function SDK.pay_success_promotion_dialog(dialog)
    if (dialog and dialog ~= "CtrlBase") then
        SDK.fb_tracker:track_event("pay_success_" .. dialog)
    else

    end
end

function SDK.pay_faild_promotion_dialog(dialog)
    if (dialog and dialog ~= "CtrlBase") then
        SDK.fb_tracker:track_event("pay_faild_" .. dialog)
    else

    end
end

function SDK.click_bonus_dialog(dialog)
    if (dialog and dialog ~= "CtrlBase") then
        SDK.fb_tracker:track_event("click_bonus_" .. dialog)
    else

    end
end

function SDK.spin_big_win()

end

function SDK.spin_feature()

end

function SDK.set_firebase_user_id(user_id)
    --local bool = AppConst.DevMode
    if (not AppConst.IsDevMode()) then
        SDK.fb_tracker:set_user_id(user_id)
    end
end

function SDK.wake_up_event()
    SDK.fb_tracker:event_wake_up()
end

--deeplink参数回调
function SDK.onAppOpenAttribution(str)
    log.y("------SDK.onAppOpenAttribution----", str)
    -- local para = JsonToTable(str)
    -- if(fun.read_value("DP_IsFirstLunch")=="true")then
    --     log.y("------DP_IsFirstLunch_tue----")
    --     fun.save_value("DP_IsFirstLunch","false")
    --     fun.save_value("InviteUser",para)
    -- end
end

function SDK.onConversionDataSuccess(str)
    log.y("------SDK.onConversionDataSuccess----", str)
    --local data = JsonToTable(str)
    --fun.save_value("DP_IsFirstLunch", data.is_first_launch)
    --str = Base64.encode(str)
    UnityEngine.PlayerPrefs.SetString("ConversionData", str)
    log.e("t.conversion2 = " .. str)
    --fun.save_value("ConversionData", str)
end

--[[
function SDK.send_deeplink()

    log.y("SDK.open_attribution_str:",AppConst.DeepLinkStr)
    if(AppConst.DeepLinkStr ~= nil and  string.len(AppConst.DeepLinkStr)>0)then
        Http.send_deep_link(AppConst.DeepLinkStr,function()
            AppConst.DeepLinkStr = ""
        end)
    end
end
--]]


function SDK.send_net_timeout()
    SDK.fb_tracker:track_event("http_net_timeout")
end

function SDK.open_game()
    SDK.bi_tracker:first_open()
    SDK.bi_tracker:app_open()
end

function SDK.auto_spin()
    SDK.bi_tracker:auto_spin()
end

function SDK.trigger_auto_spin(status)
    SDK.bi_tracker:trigger_auto_spin(status)
end

function SDK.click_max_bet(playType)
    SDK.bi_tracker:click_max_bet(playType)
end

function SDK.increase_bet(playType, chooseLevel)
    SDK.bi_tracker:increase_bet(playType, chooseLevel)
end

function SDK.decrease_bet(playType, chooseLevel)
    SDK.bi_tracker:decrease_bet(playType, chooseLevel)
end

function SDK.click_card_icon(playerLevel)
    SDK.bi_tracker:click_card_icon(playerLevel)
end

function SDK.enter_machine(machineid)
    --SDK.af_tracker:event_into()
    SDK.bi_tracker:enter_machine(machineid)
end

function SDK.machine_download_failed(machineid)
    SDK.bi_tracker:machine_download_failed(machineid)
end

function SDK.machine_download_cancel(machineid)
    SDK.bi_tracker:machine_download_cancel(machineid)
end

function SDK.machine_download_success(machineid)
    SDK.bi_tracker:machine_download_success(machineid)
end

function SDK.click_lobby_banner(machineid, isInActivity, state)
    SDK.bi_tracker:click_lobby_banner(machineid, isInActivity, state)
end

function SDK.click_piggy_icon(isInActivity, state)
    SDK.bi_tracker:click_piggy_icon(isInActivity, state)
end

function SDK.click_piggy_post(isFinalDay)
    SDK.bi_tracker:click_piggy_post(isFinalDay)
end

function SDK.adView(adType, adPos, all)
    SDK.bi_tracker:adView(adType, adPos, all)
end

function SDK.open_coins_shop()
    SDK.bi_tracker:open_coins_shop()
end

function SDK.open_diamond_shop()
    SDK.bi_tracker:open_diamond_shop()
end

function SDK.open_piggy_bank()
    SDK.bi_tracker:open_piggy_bank()
end

function SDK.open_vip()
    SDK.bi_tracker:open_vip()
end

function SDK.open_vip_benefits()
    SDK.bi_tracker:open_vip_benefits()
end

function SDK.open_activity(name)
    SDK.bi_tracker:open_activity()
end

function SDK.open_view(name, sceneName)
    for i, v in pairs(AssetList.M99998) do
        if AssetList[name] == v then
            SDK.bi_tracker:open_view(name, sceneName)
        end
    end
end

function SDK.click_view(name, sceneName)
    --[[
    for i, v in pairs(AssetList.M99998) do
        if AssetList[name] == v then
            SDK.bi_tracker:click_view(name,sceneName)
        end
    end
    --]]
end

function SDK.click_view_exit(name, sceneName)
    SDK.bi_tracker:click_view_exit(name, sceneName)
end

function SDK.OnAppTracking(state, idfa)
    Http.report_event("AppTrackingTransparency", { state = state, idfa = idfa })
end

function SDK.GetAppFlyerId()
    return SDK.af_tracker:GetAppFlyerId()
end

function SDK.LoadMaxAd(uid, segament)
    SDK.max_ad_tracker:InitializeSdk(uid, segament)
    local received_reward = function(ad_info)
        --广告回调
        if ModelList and ModelList.AdModel and not fun.is_null(CS.NetworkManager) and CS.NetworkManager.Connected then
            log.y("广告完成领取奖励")
            ModelList.AdModel:SetAdState(false)
            Event.Brocast(Notes.RECEIVE_MAX_REWARD, ad_info)
        else

        end
    end
    SDK.max_ad_tracker:SetRewardReceivedCallBack(received_reward)

    local received_rewardAdMiss = function(ad_info)
        if ModelList.AdModel:GetAdState() then
            log.y("广告中途退出了")
            Event.Brocast(Notes.RECEIVE_MAX_REWARD_ADMISS, ad_info)
        end
        fun.save_value("last_reward_play_time", os.time())
    end
    SDK.max_ad_tracker:SetRewardAdMissCallBack(received_rewardAdMiss)

    local revenue_paid_reward = function(ad_info)
        Event.Brocast(Notes.RECEIVE_MAX_REVENUE_PAID_REWARD, ad_info)
        fun.save_value("last_reward_play_time", os.time())
        log.y("revenue_paid_reward 广告回调")
        ModelList.AdModel.ReqRefreshAdCount()
    end
    SDK.max_ad_tracker:SetRewardRevenuePaidCallBack(revenue_paid_reward)

    local hiddenCallback = function(ad_info)
        Event.Brocast(EventName.Event_Interstitial_Show_Over)
        --Event.Brocast(Notes.RECEIVE_MAX_AD_HIDDEN_EVENT,ad_info)
        log.y("hiddenCallback 广告回调")
        ModelList.AdModel.ReqRefreshAdCount()
    end
    SDK.max_ad_tracker:SetAdHiddenEventCallBack(hiddenCallback)

    local playFailedCallBack = function(ad_info)
        Event.Brocast(EventName.Event_Interstitial_Show_Over)
        --Event.Brocast(Notes.RECEIVE_MAX_AD_PLAYFAILED,ad_info)
        log.y("playFailedCallBack 广告回调")
        ModelList.AdModel.ReqRefreshAdCount()
    end
    SDK.max_ad_tracker:SetAdDisplayFailedEventCallBack(playFailedCallBack)


    local biTrackerCallBack = function(eventType, ...)
        if eventType == 1 then
            local eventName, adType = select(1, ...)
            SDK.send_ad_message_to_bi(eventName, adType)
        elseif eventType == 2 then
            local adPosData, Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage, AdLoadFailureInfo =
                select(1, ...)
            local data = nil
            if adPosData then
                data = JsonToTable(adPosData)
            end
            local adPos = nil
            if data and data.adPos then
                adPos = data.adPos
            else
                adPos = adPosData
            end
            SDK.send_ad_fail_message_to_bi(adPos, Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage,
                AdLoadFailureInfo)
        elseif eventType == 3 then
            local eventName, adPosData = select(1, ...)
            local data = nil
            if adPosData then
                data = JsonToTable(adPosData)
            end
            local adPos = nil
            if data and data.adPos then
                adPos = data.adPos
            else
                adPos = adPosData
            end
            SDK.send_ad_inter_message_to_bi(eventName, adPos)
        elseif eventType == 4 then
            --local adinfo = select(1,...)
            --SDK.max_ad_tracker:FirstFillAdinfoOfReward(adinfo)
        end
    end
    SDK.max_ad_tracker:SetAdBiEventCallBack(biTrackerCallBack)
end

--插屏奖励广告
function SDK.FirstFillAdinfoOfReward()
    --SDK.FirstFillAdinfoOfReward(adPos, Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage, AdLoadFailureInfo)
end

--插屏奖励广告
function SDK.IsRewardedAdReady()
    --直接屏蔽SDK by LwangZg
    return true
    -- if GameUtil.is_windows_editor() then
    --     return true
    -- end

    -- if (fun.is_android_platform() and fun.is_android_low_memory()) then
    --     --低端android 内存小于3G，可用内存小于100M不播放
    --     return false
    -- end
    -- return SDK.max_ad_tracker:IsRewardedAdReady()
end

function SDK.ShowRewardedAd(placement, adEvents)
    Http.report_event("ad_click", { adPos = tostring(adEvents), level = tostring(ModelList.PlayerInfoModel:GetLevel()) })
    ModelList.AdModel:SaveCurrId(adEvents)
    local params = { level = tostring(ModelList.PlayerInfoModel:GetLevel()), adPos = tostring(adEvents) }
    local para = TableToJson(params)
    local customData = { level = tostring(ModelList.PlayerInfoModel:GetLevel()) }
    local customData2 = TableToJson(customData)
    return SDK.max_ad_tracker:ShowRewardedAd(para, customData2)
end

--插屏广告
function SDK.IsInterstitialAdReady()
    return true
    --直接屏蔽SDK by LwangZg
    -- if GameUtil.is_windows_editor() then
    --     return true
    -- end

    -- if (fun.is_android_platform() and fun.is_android_low_memory()) then
    --     --低端android 内存小于3G，可用内存小于100M不播放
    --     return false
    -- end

    -- return SDK.max_ad_tracker:IsInterstitialReady()
end

function SDK.ShowInterstitialAd(id, adEvent, adType, params)
    ModelList.AdModel.ReqMSG_AD_START(id, adEvent, adType, params)
    local param = {
        level = tostring(ModelList.PlayerInfoModel:GetLevel()),
        adPos = tostring(AD_EVENTS
            .AD_EVENTS_PLAY_GAME)
    }
    local para = TableToJson(param)
    local customData = { level = tostring(ModelList.PlayerInfoModel:GetLevel()) }
    local customData2 = TableToJson(customData)
    fun.save_value("last_intertitial_play_time", os.time())
    return SDK.max_ad_tracker:ShowInterstitial(para, customData2)
end

function SDK.ShowAdDebugger()
    return SDK.max_ad_tracker:ShowDebugger()
end

function SDK.open_pop_gift(sceneName, giftId, isAuto)
    SDK.bi_tracker:open_pop_gift(sceneName, giftId, isAuto)
end

function SDK.open_buy_shop(sceneName)
    SDK.bi_tracker:open_buy_shop(sceneName)
end

function SDK.open_powerups_shop(sceneName)
    SDK.bi_tracker:open_powerups_shop(sceneName)
end

function SDK.purchase_exception(data)
    SDK.bi_tracker:purchase_exception(data)
end

function SDK.purchase_click(data)
    SDK.bi_tracker:purchase_click(data)
end

function SDK.purchase_cancel(data)
    SDK.bi_tracker:purchase_cancel(data)
end

function SDK.purchase_failed(data)
    SDK.bi_tracker:purchase_failed(data)
end

function SDK.post_token()
    SDK.bi_tracker:post_token()
end

function SDK.puzzle_open(data)
    SDK.bi_tracker:puzzle_open(data)
end

function SDK.food_open(data)
    SDK.bi_tracker:food_open(data)
end

function SDK.giftpack_open(data)
    SDK.bi_tracker:giftpack_open(data)
end

function SDK.double_window_open(data)
    SDK.bi_tracker:double_window_open(data)
end

function SDK.error_report_window()
    SDK.bi_tracker:error_report_window()
end

function SDK.login_event(eventName)
    SDK.bi_tracker:login_event(eventName)
end

function SDK.upload_settle_data(eventName)
    SDK.bi_tracker:upload_settle_data(eventName)
end

function SDK.click_giftpack(itempos)
    SDK.bi_tracker:click_giftpack(itempos)
end

function SDK.click_download_extrapac(packageName)
    SDK.bi_tracker:click_download_extrapac(packageName)
end

---packageName 分包名称
---type 0:下载成功   1:下载失败
function SDK.extrapac_end(packageName, type)
    SDK.bi_tracker:extrapac_end(packageName, type)
end

function SDK.BI_Event_Tracker(eventName, data)
    log.r("[SDK] BI_Event_Tracker, eventName:", eventName)
    log.r("[SDK] BI_Event_Tracker, data:", data)
    SDK.bi_tracker:BI_Event_Tracker(eventName, data)
end

function SDK.extrapac_open(packageName)
    SDK.bi_tracker:extrapac_open(packageName)
end

function SDK.send_ad_message_to_bi(eventName, adType)
    SDK.bi_tracker:send_ad_message_to_bi(eventName, adType)
end

function SDK.send_ad_fail_message_to_bi(adPos, Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage,
                                        AdLoadFailureInfo)
    SDK.bi_tracker:send_ad_fail_message_to_bi(adPos, Code, Message, MediatedNetworkErrorCode, MediatedNetworkErrorMessage,
        AdLoadFailureInfo)
end

function SDK.send_ad_inter_message_to_bi(eventName, adPos)
    SDK.bi_tracker:send_ad_inter_message_to_bi(eventName, adPos)
end

function SDK.ReportFirstLoadAdVSuccess(adInfoJson)
    local adSaveName = "FirstFill_AdInfo_v"
    if ModelList.PlayerInfoModel:GetUid() ~= 0 and SDK.CheckFirstSendLoadAD(adSaveName) then
        UserData.set(adSaveName, 1)
        local adInfoTable = JsonToTable(adInfoJson)
        Util.RequestIDFA(function(idfa)
            Http.report_event(adSaveName, {
                adUnitIdentifier = adInfoTable.AdUnitIdentifier or "",
                adFormat = adInfoTable.AdFormat or "",
                networkName = adInfoTable.NetworkName or "",
                networkPlacement = adInfoTable.NetworkPlacement or "",
                creativeIdentifier = adInfoTable.CreativeIdentifier or "",
                placement = adInfoTable.Placement or "",
                Revenue = adInfoTable.Revenue or "",
                revenuePrecision = adInfoTable.RevenuePrecision or "",
                uid = ModelList.PlayerInfoModel:GetUid(),
                afid = SDK.af_tracker:GetAppFlyerId() or "",
                traceAdId = SDK.af_tracker:GetAppFlyerId() or "",
                idfa = idfa or "",
                version = UIUtil.get_client_version(),
                data = {
                    device = UnityEngine.SystemInfo.deviceUniqueIdentifier,
                    msg = "",
                    msg2 = "",
                }
            })
        end)
    end
end

---c#调用
function SDK.ReportFirstLoadAdISuccess(adInfoJson)
    local adSaveName = "FirstFill_AdInfo_i"
    if ModelList.PlayerInfoModel:GetUid() ~= 0 and SDK.CheckFirstSendLoadAD(adSaveName) then
        UserData.set(adSaveName, 1)
        local adInfoTable = JsonToTable(adInfoJson)
        Util.RequestIDFA(function(idfa)
            Http.report_event(adSaveName, {
                adUnitIdentifier = adInfoTable.AdUnitIdentifier or "",
                adFormat = adInfoTable.AdFormat or "",
                networkName = adInfoTable.NetworkName or "",
                networkPlacement = adInfoTable.NetworkPlacement or "",
                creativeIdentifier = adInfoTable.CreativeIdentifier or "",
                placement = adInfoTable.Placement or "",
                Revenue = adInfoTable.Revenue or "",
                revenuePrecision = adInfoTable.RevenuePrecision or "",
                uid = ModelList.PlayerInfoModel:GetUid(),
                afid = SDK.af_tracker:GetAppFlyerId() or "",
                traceAdId = SDK.af_tracker:GetAppFlyerId() or "",
                idfa = idfa or "",
                version = UIUtil.get_client_version(),
                data = {
                    device = UnityEngine.SystemInfo.deviceUniqueIdentifier,
                    msg = "",
                    msg2 = "",
                }
            })
        end)
    end
end

function SDK.send_change_user_groups(groupIds)
    SDK.bi_tracker:send_change_user_groups(groupIds)
end

function SDK.send_error_log_to_server(msg)
    SDK.bi_tracker:send_error_log_to_server(msg)
end

function SDK.DeferredDeeplinkCallback(deeplinkURL)
    log.r("Lua DeeplinkURL " .. deeplinkURL)
    --这个作为协议完全发给后端
    ModelList.PlayerInfoModel:DeferredDeeplinkCallback(deeplinkURL)
end

function SDK.CheckFirstSendLoadAD(adSaveName)
    local lastUseTimeStamp = UserData.read_nocache(adSaveName, -1)
    if lastUseTimeStamp == -1 then
        return true
    end
    return false
end

--- 上传广告展示事件
function SDK.ADShow(adPos)
    Http.report_event("ad_show", { adPos = adPos, level = tostring(ModelList.PlayerInfoModel:GetLevel()) })
end

--- 上传广告点击事件
function SDK.ADClick(adPos)
    Http.report_event("ad_click", { adPos = adPos, level = tostring(ModelList.PlayerInfoModel:GetLevel()) })
end

function SDK.TrackEvent(eventName, eventData)
    return --暂时屏蔽数数打点
    -- if(type(eventData)=="table")then
    --     ThinkingAnalyticsHelper.Instance:TrackEvent(eventName,TableToJson(eventData))
    -- elseif(type(eventData)=="string")then
    --     ThinkingAnalyticsHelper.Instance:TrackEvent(eventName,{eventData = eventData})
    -- end
end

function SDK.TrackWebEvent(eventName, eventData)
    Http.report_event(eventName, eventData)
end
