NotificationUtil = {}

NotificationUtil.IDs = {
    DailyWheel = 101,
    LeaveForOneDay = 102,
    LeaveFor5Minute =103,
    OnlineAward = 104,
}
NotificationUtil.testid = 1

 
function NotificationUtil.send_notification_for_timebonus_ready()

    local model = ModelList.timeBonusModel
    local total_info = model:GetTimeBonusInfo()

    if(total_info and total_info[2])then 
        local bonus_info = total_info[2]  --取中间奖励
        if(not bonus_info.isReady)then 
            local readyTime =  bonus_info.readyTime-os.time()
            log.r("send_notification_for_timebonus_ready",readyTime)
            NotificationManager.Instance:SendDelay(NotificationUtil.IDs.DailyWheel,readyTime,
            " 🌟Bonus Time! 🌟",
            "Daily Wheel 👈 is ready 🥂 , tap to collect your Daily Reward! 🤑",
            "")
        end  
    end

    
end

function NotificationUtil.send_notification_for_5_minute()
    NotificationManager.Instance:Cancel(NotificationUtil.IDs.LeaveFor5Minute)
    NotificationManager.Instance:SendDelay(NotificationUtil.IDs.LeaveFor5Minute, 60*5,
            "Keep it up! 💪",
            "You are almost there!😆 Keep spinning and win big!",
            "")
end





function NotificationUtil.cancel_all_notifications()
    NotificationManager.Instance:CancelAll()
    --玩家手动清除
end

--24小时通知由服务器发送，客户端不干预，这版本废弃
function NotificationUtil.send_notification_for_leave_one_day()
    NotificationManager.Instance:SendDelay(NotificationUtil.IDs.LeaveForOneDay, 60*60*4,
        "🎰 Spend the day with us! 🎰",
        "Come back and crank up the fun! 🎰 Spin with us today! 🥂 ",
        "")
end



function NotificationUtil.test_send_notification()
    log.y("test_send_notification")
    NotificationUtil.testid = NotificationUtil.testid + 1
    NotificationManager.Instance:SendDelay(NotificationUtil.testid, 10,
            "this is test notifications1",
            "Come back and crank up the fun🎰 !",
            "")
end


function NotificationUtil.test_send_now_notification()
    log.y("test_send_now_notification")
    NotificationUtil.testid = NotificationUtil.testid + 1
    NotificationManager.Instance:SendNow(NotificationUtil.testid ,
            "Test",
            "这是开发版本的测试效果，正式不会出现!~",
            "")
end






function NotificationUtil.send_notifications()
    NotificationUtil.send_notification_for_5_minute()
    NotificationUtil.send_notification_for_timebonus_ready()
     
end