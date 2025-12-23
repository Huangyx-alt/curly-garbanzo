--用于管理用户打点可能用到的持久化数据

PlayerTrackerData = {}


function  PlayerTrackerData.init()

end


--安装后是否第一次打开的标志
function PlayerTrackerData.set_first_open_mark()
    UserData.set("first_open","false")
end

--记录破产时间
function PlayerTrackerData.save_game_break_time()
    UserData.set("break_time",fun.time_to_date_2(os.time()))
end

function PlayerTrackerData.get_game_break_time()
    return  UserData.get("break_time")
end

function PlayerTrackerData.del_game_break_time()
    fun.delete_value("break_time")
end

--第几天登陆
function PlayerTrackerData.set_login_days()
    if UserData.get("login_days_") then
        local last_login_time = UserData.get("continuous_login_")--上次登陆时间
        local login_time = fun.time_to_date_2(os.time())
        if os.difftime(login_time,last_login_time) < 1 then -- 登陆间隔小于一天、说明是当天登陆
            return
        end
        UserData.set("login_days_",tonumber(UserData.get("login_days_")+1))
    else
        UserData.set("login_days_",1)
    end
    if tonumber(UserData.get("login_days_") >1) and tonumber(UserData.get("login_days_")) <=7 then
        SDK.event_login_days(UserData.get("login_days_"))
    end
end


--连续登陆
function PlayerTrackerData.set_continuous_login_days()
    if UserData.get("continuous_login_")then --存在上次登陆时间

        local login_time = fun.time_to_date_2(os.time())--本次登陆时间

        if os.difftime(login_time,UserData.get("continuous_login_")) > 1 then --登陆间隔超过一天，中断连续

            UserData.set("continuous_login_",login_time)--登陆时间
            UserData.set("continuous_login_days_",1)--连续天数

        elseif os.difftime(login_time,UserData.get("continuous_login_")) == 1 then --登陆间隔为一天，确定为连续登陆


            UserData.set("continuous_login_",login_time)--登陆时间
            UserData.set("continuous_login_days_",tonumber(UserData.get("continuous_login_days_"))+1)--连续天数

        end
    else -- 不存在上次登陆时间，说明是第一次登陆

        UserData.set("continuous_login_",fun.time_to_date_2(os.time()))--登陆时间
        UserData.set("continuous_login_days_",1)--连续天数

    end
    if tonumber(UserData.get("continuous_login_days_")) == 7 then --连续登陆七天
        --埋点屏蔽
        --SDK.event_continuous_login()
    end

end

--付费标志
function PlayerTrackerData.set_first_pay_mark()
    UserData.set("first_pay","true")
end

--付费时间
function PlayerTrackerData.set_pay_time_180(money)
    if UserData.get("pay_time_180") then
        local time = fun.time_to_date_2(os.time())
        local temp = UserData.get("pay_time_180")
        local new_temp = {}
 
        if(type(temp)=="table")then 
            for i, v in pairs(temp) do
                if os.difftime(time,v[1]) <= 180 then
                    table.insert(new_temp,v)
                end
            end
        else
            log.r("temp is nil :"..temp)
 
        end
 
        temp = nil
        table.insert(new_temp,{time,money})
        local times = #new_temp
        local new_moneys = 0
        for i, v in pairs(new_temp) do
            new_moneys = new_moneys + v[2]
        end
        if times > 20 then
            return
        end
        UserData.set("pay_time_180",new_temp)
        UserData.set("pay_time_180_times",times)
        UserData.set("pay_money_180",new_moneys)
        if times == 2 or times == 3 or times == 5 or times == 10 or times == 20 then
            SDK.event_pay_times_180(times)
        end

        local moneys_list = {10,50,100,200,300,500,1000}
        for i = 2, #moneys_list do
            if new_moneys < i and new_moneys >= i-1 then
                if UserData.get(moneys_list[i-1]) then
                    return
                else
                    UserData.set(moneys_list[i-1],true)
                    SDK.event_buy_money_180(moneys_list[i-1])
                end

            end
        end

    else
        UserData.set("pay_time_180",{{fun.time_to_date_2(os.time()),money}})
        local temp = UserData.get("pay_time_180")
        local times = #temp
        UserData.set("pay_time_180_times",times)
        UserData.set("pay_money_180",money)
    end
end

--付费时间
function PlayerTrackerData.set_pay_time_7()
    if UserData.get("pay_time_7") then
        local time = fun.time_to_date_2(os.time())
        local temp = UserData.get("pay_time_7")
        local new_temp = {}
        if(type(temp)=="table")then 
            for i, v in pairs(temp) do
                if os.difftime(time,v) <= 7 then
                    table.insert(new_temp,v)
                end
            end
        else
            log.r("table is string:"..temp)
        end 
        temp = nil
        table.insert(new_temp,time)
        local times = #new_temp
        UserData.set("pay_time_7",new_temp)
        UserData.set("pay_time_7_times",times)

        if times == 2 or times == 3 or times == 5 or times == 7 then
            SDK.event_pay_times_7(times)
        end

    else
        UserData.set("pay_time_7",{fun.time_to_date_2(os.time())})
        local temp = UserData.get("pay_time_7")
        local times = #temp
        UserData.set("pay_time_7_times",times)
    end
end



