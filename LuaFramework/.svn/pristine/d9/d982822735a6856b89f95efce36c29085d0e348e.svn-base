AppFlyerTracker = Clazz()

function AppFlyerTracker.create()
    local instance = AppFlyerTracker:new()
    return instance
end

function AppFlyerTracker:track_event(event_name)
    if AppFlyerHelper ~=nil then
         AppFlyerHelper.TrackEvent(event_name)
    end
   
    log.i("AppFlyerTracker:track_event:"..event_name)
end

function AppFlyerTracker:first_event(event_name)
    local key = event_name
    local value = fun.read_value(key, 0)
    if value == 0 then
        value = 1
        self:track_event(event_name)
        fun.save_value(key,value)
    end
end

--当日首次打点事件
function AppFlyerTracker:day_first_event(event_name)
    local key = event_name.. ModelList.PlayerInfoModel.server_date_str
    local value = fun.read_value(key,0)
    if value == 0 then
        value = 1
        self:track_event(event_name)
        fun.save_value(key,value)
    end
end


function AppFlyerTracker:GetAppFlyerId()
     if AppFlyerHelper ~= nil then
        return AppFlyerHelper.GetAppFlyerId()
     end
end


--开发者
function AppFlyerTracker:event_developer() self:track_event("developer") end
--登录
function AppFlyerTracker:event_login() self:track_event("login") end
function AppFlyerTracker:event_facebooklogin_succeeded() self:track_event("facebookLogin_succeeded") end
function AppFlyerTracker:event_facebooklogin_failed() self:track_event("facebookLogin_failed") end

--注册
function AppFlyerTracker:event_register() self:track_event("register") end
function AppFlyerTracker:event_facebookregister() self:track_event("facebookregister") end
function AppFlyerTracker:event_guestregister() self:track_event("guestregister") end


--事件
function AppFlyerTracker:event_download_begin() self:first_event("download_begin") end --下载机台
function AppFlyerTracker:event_download_end() self:first_event("download_end") end --下载机台
function AppFlyerTracker:event_into() self:track_event("into") end --进入机台


function AppFlyerTracker:event_bankrupt() self:track_event("game_break") end --破产（持有金币<当前机台最小bet）
--安装后第一次进大厅
function AppFlyerTracker:event_first_enter_lobby() self:first_event("first_lobby") end 
--安装后第一次spin
function AppFlyerTracker:event_first_spin() self:first_event("first_spin") end

--安装后第一次打开
function AppFlyerTracker:event_first_open() self:track_event("first_open") end

--facebook用户每日登录
function AppFlyerTracker:event_day_fb_login() self:day_first_event("fb_login") end 

--游客用户每日登录
function AppFlyerTracker:event_day_guest_login() self:day_first_event("guest_login") end 

--每日首次进入大厅
function AppFlyerTracker:event_day_first_lobby() self:day_first_event("day_first_lobby") end 

-- wheel_open	首次出现转盘
function AppFlyerTracker:event_first_wheel_open() self:first_event("wheel_open") end 
-- wheel_spin	首次点击spin转盘
function AppFlyerTracker:event_first_wheel_spin() self:first_event("wheel_spin") end 
-- wheel_collect	首次获得转盘奖励
function AppFlyerTracker:event_first_wheel_collect() self:first_event("wheel_collect") end 
-- wheel_end	首次结束转盘
function AppFlyerTracker:event_first_wheel_end() self:first_event("wheel_end") end 

-- day_wheel_open	每日首次出现转盘
function AppFlyerTracker:event_day_wheel_open() self:day_first_event("day_wheel_open") end 
-- day_wheel_spin	每日首次点击spin转盘
function AppFlyerTracker:event_day_wheel_spin() self:day_first_event("day_wheel_spin") end 
-- day_wheel_collect	每日首次获得转盘奖励
function AppFlyerTracker:event_day_wheel_collect() self:day_first_event("day_wheel_collect") end 
-- day_wheel_end	每日首次结束转盘
function AppFlyerTracker:event_day_wheel_end() self:day_first_event("day_wheel_end") end 


--达到等级
function AppFlyerTracker:event_level(user_level)
    self:track_event("level up")
    if user_level == 2  or user_level==3 or user_level==4 or user_level==6 or user_level==7 or user_level==8 or user_level==9 or (user_level>= 5 and user_level <= 100 and user_level%5 ==0 )
            or(user_level>= 100 and user_level <= 420 and user_level%10 ==0) then
        self:track_event("level"..user_level)
    end
end

--破产后购买
function AppFlyerTracker:event_game_break_payments(days)
    self:track_event("game_break_payments_in"..days.."d")
end

--登陆天数
function AppFlyerTracker:event_login_days(days)
    self:track_event("login_"..days.."d")
end

--连续七天登陆
function AppFlyerTracker:event_continuous_login()
    self:track_event("login_all_seven")
end

--第一次付费
function AppFlyerTracker:event_new_payer()
    self:track_event("New_payer")
end

--180天内付费次数
function AppFlyerTracker:event_pay_times_180(pay_times)
    self:track_event("pay"..pay_times.."in180d")
end

--7天内付费次数
function AppFlyerTracker:event_pay_times_7(pay_times)
    self:track_event("pay"..pay_times.."in7d")
end

--购买
function AppFlyerTracker:event_buy(money)
    self:track_event("store_"..money)
end

--累积购买
function AppFlyerTracker:event_buy_money_180(money)
    self:track_event("Store"..money.."in180d")
end


--激励广告播放完
function AppFlyerTracker:rewarded()
    self:track_event("rewarded")
end

--插屏广告播放完
function AppFlyerTracker:interstitial()
    self:track_event("interstitial")
end
