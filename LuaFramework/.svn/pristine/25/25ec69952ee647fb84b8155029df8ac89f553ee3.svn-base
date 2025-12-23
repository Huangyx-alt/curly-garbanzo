-- require "Logic.Http" --大改网络模块 by LwangZg
FirebaseTracker = Clazz()

local event_prefix = "firebase_event_"

function FirebaseTracker.create()
    local instance = FirebaseTracker:new()
    local bool = AppConst.DevMode
    instance.is_dev = AppConst.IsDevMode()
    --FirebaseHelper.FirebaseInitAsync()
    FirebaseHelper.SendTokenToLua(FirebaseTracker.get_device_token)
    return instance
end

function FirebaseTracker:track_event(event_name)

    if(self.is_dev==false)then
        FirebaseHelper.TrackEvent(event_name)
    end
    log.i("FirebaseTracker:track_event:"..event_name)
    if string.find(event_name, "ad_") == 1 then
        Http.report_event(event_name)
    end
end

function FirebaseTracker:first_event(event_name)
    local key = event_prefix..event_name
    local value = fun.read_value(key,0)
    if value == 0 then
        value = 1
        self:track_event(event_name)
        fun.save_value(key,value)
    end
end

--当日首次打点事件
function FirebaseTracker:day_first_event(event_name)
    local key = event_prefix..event_name.. ModelList.PlayerInfoModel.server_date_str
    local value = fun.read_value(key, 0)
    if value == 0 then
        value = 1
        self:track_event(event_name)
        fun.save_value(key,value)
    end
end

--安装后第一次打开
function FirebaseTracker:event_first_open() self:track_event("first_open") end

--开发者
function FirebaseTracker:event_developer() self:track_event("developer") end
--登录
function FirebaseTracker:event_login() self:track_event("login") end
function FirebaseTracker:event_facebooklogin_succeeded() self:track_event("facebookLogin_succeeded") end
function FirebaseTracker:event_facebooklogin_failed() self:track_event("facebookLogin_failed") end
--注册
function FirebaseTracker:event_register() self:track_event("signup") end
function FirebaseTracker:event_facebookregister() self:track_event("facebook_signup") end
function FirebaseTracker:event_guestregister() self:track_event("guest_signup") end


--事件
function FirebaseTracker:event_download_begin() self:track_event("download_begin") end --下载机台
function FirebaseTracker:event_download_end() self:track_event("download_end") end --下载机台
function FirebaseTracker:event_into() self:track_event("enter_slotsroom") end --进入机台


function FirebaseTracker:event_bankrupt() self:track_event("game_break") end --破产（持有金币<当前机台最小bet）
--安装后第一次spin
function FirebaseTracker:event_spin() self:track_event("game_spin") end 

--facebook用户每日登录
function FirebaseTracker:event_day_fb_login() self:day_first_event("fb_login") end 

--游客用户每日登录
function FirebaseTracker:event_day_guest_login() self:day_first_event("guest_login") end 

--每日首次进入大厅
function FirebaseTracker:event_enter_lobby() self:track_event("enter_lobby") end 


-- wheel_open	首次出现转盘
function FirebaseTracker:event_first_wheel_open() self:first_event("wheel_open") end 
-- wheel_spin	首次点击spin转盘
function FirebaseTracker:event_first_wheel_spin() self:first_event("wheel_spin") end 
-- wheel_collect	首次获得转盘奖励
function FirebaseTracker:event_first_wheel_collect() self:first_event("wheel_collect") end 
-- wheel_end	首次结束转盘
function FirebaseTracker:event_first_wheel_end() self:first_event("wheel_end") end 

-- day_wheel_open	每日首次出现转盘
function FirebaseTracker:event_day_wheel_open() self:day_first_event("day_wheel_open") end 
-- day_wheel_spin	每日首次点击spin转盘
function FirebaseTracker:event_day_wheel_spin() self:day_first_event("day_wheel_spin") end 
-- day_wheel_collect	每日首次获得转盘奖励
function FirebaseTracker:event_day_wheel_collect() self:day_first_event("day_wheel_collect") end 
-- day_wheel_end	每日首次结束转盘
function FirebaseTracker:event_day_wheel_end() self:day_first_event("day_wheel_end") end 


--达到等级
function FirebaseTracker:event_level(user_level)
    self:track_event("level up")
    if user_level == 2  or user_level==3 or user_level==4 or user_level==6 or user_level==7 or user_level==8 or user_level==9 or (user_level>= 5 and user_level <= 100 and user_level%5 ==0)
            or(user_level>= 100 and user_level <= 420 and user_level%10 ==0) then
        self:track_event("level"..user_level)
    end
end

--破产后购买
function FirebaseTracker:event_game_break_payments(days)
    self:track_event("game_break_payments_in"..days.."d")
end

--登陆天数
function FirebaseTracker:event_login_days(days)
    self:track_event("login_"..days.."d")
end

--连续七天登陆
function FirebaseTracker:event_continuous_login()
    self:track_event("login_all_seven")
end

function FirebaseTracker:event_quit()
    self:track_event("game_exit")
end

--第一次付费
function FirebaseTracker:event_new_payer()
    self:track_event("New_payer")
end


--180天内付费次数
function FirebaseTracker:event_pay_times_180(pay_times)
    self:track_event("pay"..pay_times.."in180d")
end

--7天内付费次数
function FirebaseTracker:event_pay_times_7(pay_times)
    self:track_event("pay"..pay_times.."in7d")
end

--购买
function FirebaseTracker:event_buy(money)
    self:track_event("store_"..money)
end

--累积购买
function FirebaseTracker:event_buy_money_180(money)
    self:track_event("Store"..money.."in180d")
end

-- 区分插屏和激励视频广告.
function FirebaseTracker:request_adi()
    -- 插屏视频请求记录
    self:track_event("ad_video_interstitial_request")
end

function FirebaseTracker:request_adv()
    -- 激励视频请求记录
    self:track_event("ad_video_rewarded_request")
end

---- 之前ad_video_request没有做插屏和激励的区分
--function FirebaseTracker:request_ad()
--    self:track_event("ad_video_request")
--end

function FirebaseTracker:show_adi()
    self:track_event("ad_interstitial_show")
end
function FirebaseTracker:show_adv()
    self:track_event("ad_video_show")
end
function FirebaseTracker:show_ad_i(ad_banner)
    --if force then
    --    self:track_event("ad_interstitial_forced")
    --    if ad_banner then
    --        self:track_event("ad_interstitial_"..ad_banner.."_forced")
    --    end
    --else
        self:track_event("ad_interstitial_video") 
        if ad_banner then
            self:track_event("ad_interstitial_"..ad_banner) 
        end
    --end
end

function FirebaseTracker:show_ad_v(ad_banner)
    --if force then
    --    self:track_event("ad_rewarded_forced")
    --    if ad_banner then
    --        self:track_event("ad_rewarded_"..ad_banner.."_forced")
    --    end
    --else
        self:track_event("ad_rewarded_video") 
        if ad_banner then
            self:track_event("ad_rewarded_"..ad_banner)
        end
    --end
end

function FirebaseTracker:event_click_ad()
    self:track_event("ad_video_click") 
end

function FirebaseTracker:event_ad_reward()
    self:track_event("ad_video_reward")
end

function FirebaseTracker:event_dismiss_ad_i()
    self:track_event("ad_interstitial_pause")
end

function FirebaseTracker:event_wake_up()
    self:track_event("wake_up")
end


function FirebaseTracker:set_user_id(user_id)
    if(AppConst.is_amazon_pay)then

        return 
    end
    if FirebaseTracker then
        FirebaseHelper.SetUserId(user_id)
    end
end

function FirebaseTracker.get_device_token()
    --local deviceToken = fun.read_value("DeviceToken","")
    if SDK and SDK.post_token then
        SDK.post_token()
    end
end