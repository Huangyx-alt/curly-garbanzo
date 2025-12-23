--本地推送 ，显示通知
LuaNotifications = {}
local ChannelId = "game_channel0"
local ReminderChannelId = "reminder_channel1"
local NewsChannelId = "news_channel2" 
local OneDayTime = 86400

local NotificationData = {
    ["Two"] ={ title ="⏰ Your number is being called",con ="miss an important number!!! Come back and daub it!🔥"}, --2分钟
    ["Five"] ={ title ="📞Your bingo buddy Lee is inviting you",con ="The next game is about to start, come back and compete with me!😏"}, --5分钟
    ["Thirty"] ={ title ="😁 It's still me! -Your bingo buddy Lee!",con ="Did you know: playing bingo games every day will sharpen your brain and focus!👓"}, --30分钟
    ["OneDay"] ={ title ="🥺 Your bingo buddy Lee is waiting for you",con ="Too busy today? It's okay, I'll take care of the coins and diamonds you didn't collect 👉👈"}    --一天
}

function LuaNotifications:Initialize()
   log.g("本地推送 定时器启用 Initialize")
    -- LuaCallNotificationsUtility.InitNotifications({
    --    {ChannelId,"Default Game Channel","Generic notifications"},
    --    {NewsChannelId,"News ChannelId","News feed notifications"},
    --    {ReminderChannelId,"Reminder ChannelId","Reminder notifications"}
    -- })
end

local logintime = nil 

function LuaNotifications:SetLoginNotification()
  LuaCallNotificationsUtility.CancelAllNotification()  --一开始登录的
  logintime = os.time()
  LuaCallNotificationsUtility.SendNotification(NotificationData["OneDay"].title,NotificationData["OneDay"].con,OneDayTime, ReminderChannelId)
end


function LuaNotifications:OnApplicationFocus(hasFocus)
  
end

function LuaNotifications:OnApplicationPause(hasFocus)
  LuaNotifications:RemoveAllDelayTimer()
  if hasFocus== false  then   
    log.g("本地推送 定时器销毁")
      -- 销毁定时器
     LuaCallNotificationsUtility.CancelAllNotification()
     LuaCallNotificationsUtility.DismissAllNotification()
     --可能会把24小时推送给取消了
    if logintime ~= nil then 
      local tmpTime = os.time() - logintime
      if OneDayTime > tmpTime then 
        log.g("定时器 24小时启用  --"..tmpTime)
        if fun.is_ios_platform() then --苹果系统
          LuaCallNotificationsUtility.NotificationMessage(NotificationData["OneDay"].con,NotificationData["OneDay"].title,OneDayTime-tmpTime,false)
        else
           LuaCallNotificationsUtility.SendNotification(NotificationData["OneDay"].title,NotificationData["OneDay"].con,OneDayTime-tmpTime, ReminderChannelId)
        end 

      end 

    end 
    
    -- 如果是通知栏进来的
    local string = LuaCallNotificationsUtility.GetLastNotificationIntent()

    if string ~= nil then 
        --log.g("上报通知栏打点"..string)
        Http.report_event("notifications_transparency",{titile = string})
    end 
  else
    log.g("本地推送 定时器启用")

    if fun.is_ios_platform() then --苹果系统
        --两分钟
        LuaCallNotificationsUtility.NotificationMessage(NotificationData["Two"].con,NotificationData["Two"].title,120,false)
        --5分钟
        LuaCallNotificationsUtility.NotificationMessage(NotificationData["Five"].con,NotificationData["Five"].title,300,false)

        --30分钟分钟
        LuaCallNotificationsUtility.NotificationMessage(NotificationData["Thirty"].con,NotificationData["Thirty"].title,1800,false)
    else 
        --两分钟
        LuaCallNotificationsUtility.SendNotification(NotificationData["Two"].title,NotificationData["Two"].con,120, ReminderChannelId)
        --5分钟
        LuaCallNotificationsUtility.SendNotification(NotificationData["Five"].title,NotificationData["Five"].con,300, ReminderChannelId)
        --30分钟分钟
        LuaCallNotificationsUtility.SendNotification(NotificationData["Thirty"].title,NotificationData["Thirty"].con,1800, ReminderChannelId)
    end 
    --
  end
end

function LuaNotifications:RemoveAllDelayTimer()
 
end

function LuaNotifications:SendTestNotification()

    --启用定时器

    --LuaCallNotificationsUtility.SendNotification("Jackpot Reminder","🎱JACKPOT is waiting for you to win! Come and join the unbeatable live party bingo!🎱",3 * 60, ReminderChannelId)
end