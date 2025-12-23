local MailModel = BaseModel:New("MailModel")

local MailItemList = {} --邮件列表   --按类型进行分类
local RedDot = false       --红点

local this = MailModel

-- local mailNowrecordId = nil

------------------------------------消息返回------------------------------------------

--邮件请求返回
function MailModel.S2C_GetMailList(code,data) 
    if(code == RET.RET_SUCCESS)then
        MailItemList = {}
        if #data.mailList >0 then 
            for _,v in pairs(data.mailList) do
                if not MailItemList[v.type] then 
                    MailItemList[v.type] = {}
                 end 

                MailItemList[v.type][v.recordId] = v
            end 
            
        end    

         --todo 界面刷新事件
         Facade.SendNotification(NotifyName.Mail.UpDateMailList)
         MailModel.checkHaveNew()
    end 
end

--邮件 更新状态，添加或者
function MailModel.S2C_GetMailDetail(code,data) 
    if(code == RET.RET_SUCCESS)then
        if not  MailItemList[data.mailInfo.type] then 
            MailItemList[data.mailInfo.type] = {}
        end 
        
        local isOldMail = true

        if not  MailItemList[data.mailInfo.type][data.mailInfo.recordId] then --新邮件
            isOldMail = false
        end 

        MailItemList[data.mailInfo.type][data.mailInfo.recordId] = data.mailInfo
        Facade.SendNotification(NotifyName.Mail.UpDateMailList)

       
        if  (data.mailInfo.type == EMAIL_TYPE.POP_EMAIL and isOldMail==false ) or isOldMail == true then 
            if data.mailInfo.isReceive == false or data.mailInfo.isRead == false then  -- 未读或未领得情况下才显示
                local tb = {RecordId = data.mailInfo.recordId}
            
                if data.mailInfo.type == EMAIL_TYPE.AMAZON_GIFT_CARD_EMAIL then 
                    Facade.SendNotification(NotifyName.Mail.ShopMailAmazonCard,tb)--发送显示邮件得详情提示
                    
                else 
                    Facade.SendNotification(NotifyName.Mail.ShopMailDialog,tb)--发送显示邮件得详情提示
                end 
            
            end 
        end 


        MailModel.checkHaveNew()
        Event.Brocast(EventName.Event_Refresh_Mail_Red)
    end 
end

--查看某封邮件
function MailModel.S2C_GetMailRead(code,data) 
    if code == RET.RET_SUCCESS then 
    
    end 
end

--领取邮件奖励
function MailModel.S2C_GetMailReward(code,data) 
    if code == RET.RET_SUCCESS then 
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
    end 
end

--邮件查询可回赠卡片
function MailModel.S2C_FetchFeedbackSeasonCards(code,data)
    if code == RET.RET_SUCCESS then 
        Facade.SendNotification(NotifyName.Mail.ShowMailGiveCard,data)
    end 
end

--邮件回赠后
function MailModel.S2C_SeasonCardFeedback(code,data)
    if code == RET.RET_SUCCESS then 
        Facade.SendNotification(NotifyName.Mail.HideMailGiveCard)
    end 
end

----------------------------------消息请求-----------------------------------------------------------

--请求邮件列表
function MailModel.C2S_RequestMailList(page)
    page = page or 1 

    this.SendMessage(MSG_ID.MSG_MAIL_LIST,{page=page})
end

--登录特定请求，返回相应协议号和包体，如为nil值则不处理
function MailModel.Login_C2S_RequestMailList(page)
    page = page or 1 
    return MSG_ID.MSG_MAIL_LIST,Base64.encode(Proto.encode(MSG_ID.MSG_MAIL_LIST,{page=page}))
end

--查看邮件列表
function MailModel.C2S_RequestMailRead(recordId)
    recordId = recordId or 1

    this.SendMessage(MSG_ID.MSG_MAIL_SET_READ,{recordId=recordId})
end

--领取邮件列表
function MailModel.C2S_RequestMailGetReward(recordId)
    recordId = recordId or 1
    this.SendMessage(MSG_ID.MSG_MAIL_REWARD_RECEIVE,{recordId=recordId})
end

--邮件地址确认
function MailModel.C2S_UserEmailSubmit()
    this.SendMessage(MSG_ID.MSG_USER_EMAIL_SUBMIT,{})
end

--邮件查询可回赠卡片
function MailModel.C2S_FetchFeedbackSeasonCards(recordId)
    this.SendMessage(MSG_ID.MSG_FETCH_FEEDBACK_SEASON_CARDS,{recordId= recordId})
end

--
function MailModel.C2S_SeasonCardFeedback(recordId,cardId,seasonId)
    this.SendMessage(MSG_ID.MSG_SEASON_CARD_FEEDBACK,{recordId= recordId,cardId =cardId,seasonId =seasonId})
end


----------------------------------对外接口（返回数据使用）-------------------------------------------
--是否有红点
function MailModel.haveReaDot()
    return RedDot
end

--todo 是否邮箱中有弹窗类型邮件
function MailModel.havePopMail()

    local mailRecordID = -1
   -- local isReward = ModelList.PlayerInfoModel.get_cur_daily_info()

    if not MailItemList[EMAIL_TYPE.POP_EMAIL] and not MailItemList[EMAIL_TYPE.UPDATE_EMAIL] then 
        return -1
    end 

    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()

    if  MailItemList[EMAIL_TYPE.POP_EMAIL] ~= nil then 
        --正常弹窗类型
        for _,v in pairs(MailItemList[EMAIL_TYPE.POP_EMAIL]) do
            if v.isReceive == false and (v.expireTime==0 or v.expireTime>= start_time) then 
                mailRecordID = v.recordId
            end 
        end
    end 
   
    if MailItemList[EMAIL_TYPE.UPDATE_EMAIL] ~= nil then 
        --更新提示类型 --一般只有一封
        for _,v in pairs(MailItemList[EMAIL_TYPE.UPDATE_EMAIL]) do
            local isForce =this.isForceMail(v.content)


            if  v.isReceive == false and not v.isForce then 
                mailRecordID = v.recordId
            end 

            if isForce == false  then 
                v.isForce = true
            end 
        end
        
    end 


    return mailRecordID 
end

--返回最新得邮件信息得id
-- function MailModel.GetMailNowRecordId()
--     return mailNowrecordId;
-- end

--[[{
    dec :更新提示的邮件需要做特殊处理 根据内容更新前更新后去返回参数
    data :{
        title :题目
        content : 内容 
        isUpdate : 是否已经更新
        URL : 链接
    }
--]]
function MailModel.GetUpdateMailCont(recordId)
    if not  MailItemList[EMAIL_TYPE.UPDATE_EMAIL] then 
        return nil 
    end 

    if not MailItemList[EMAIL_TYPE.UPDATE_EMAIL][recordId] then 
        return nil 
    end 

    local mailinfo = deep_copy(MailItemList[EMAIL_TYPE.UPDATE_EMAIL][recordId])
    local strs = string.split(mailinfo.content,"^")
    if #strs < 5 then 
        return nil 
    end 

    local tmpData = {}
    local str1 = string.split(mailinfo.title,"^") 
    local vestion =  UIUtil.get_client_version()
    local strVer = string.split(strs[3],".") 
    local strverNow = string.split(vestion,".") 
    tmpData.isForce = strs[4]

    if tonumber(strVer[2]) > tonumber(strverNow[2]) then  --还未更新
        tmpData.title = str1[1]
        tmpData.content = strs[1]
        tmpData.isUpdate = false 
        tmpData.URL = strs[5]
       
    else --已更新
        tmpData.title = str1[2] or "error title"  ---如果没有带update
        tmpData.content = strs[2] or "error content"
        tmpData.isUpdate = true 
        tmpData.URL =  strs[5] or "error url"
    end 
    
    return tmpData
end

---问卷调查要加uid
function MailModel.GetInterlinkMailCont(recordId)
    if not  MailItemList[EMAIL_TYPE.QUESTION_EMAIL] then 
        return nil 
    end 

    if not MailItemList[EMAIL_TYPE.QUESTION_EMAIL][recordId] then 
        return nil 
    end 

    local tmpData = {}
    local mailinfo = deep_copy(MailItemList[EMAIL_TYPE.QUESTION_EMAIL][recordId])
    local strs = string.split(mailinfo.content,"^")
    if #strs < 2 then 
        return nil 
    end 
    local playInfo = ModelList.PlayerInfoModel:GetUserInfo()

    tmpData.title = mailinfo.title
    tmpData.content = strs[1]
    tmpData.url = strs[2] .."?uid="..playInfo.uid

    return tmpData
end 

----------------------------------数据处理----------------------------------------------------------------

--按原本邮件recordID 从大到小
function MailModel.getMailItemListbyTime() 
    local tb ={}
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    for _,v in pairs(MailItemList) do 
        for _,v2 in pairs(v) do
            if v2.expireTime==0 or v2.expireTime>= start_time then  
                table.insert(tb,v2)
            end 
        end 
    end 

    table.sort(tb,function (a, b)
        return a.recordId < b.recordId
    end)

    return DeepCopy(tb) 
end

--检查是否有新的邮件，全部遍历
function MailModel.checkHaveNew()
    RedDot = false
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    for _,v in pairs(MailItemList) do 
        for _,v2 in pairs(v) do
            if (v2.isRead ==false or v2.isReceive ==false ) and 
	    (v2.expireTime== 0 or v2.expireTime>= start_time) then 
                RedDot = true
                break;
            end 
        end 
    end 
   
    RedDotManager:Refresh(RedDotEvent.mail_reddot_event)
end

function MailModel.GetMailInfo(recordId)
    for _,v in pairs(MailItemList) do 
        for _,v2 in pairs(v) do
            if v2.recordId == recordId then 
                return deep_copy(v2)
            end 
        end 
    end 

    return nil 
end

--是否是强更邮件，默认是强更类型
function MailModel.isForceMail(content)
    local strs = string.split(content,"^") 

    if #strs <5 then  
        return true 
    end 

    if(tonumber(strs[4]) == 1) then 
        return true
    end 

    return false
end

function MailModel.CheckMailExist()
    local tb =ModelList.MailModel.getMailItemListbyTime()
    local mailExist = false
    for k ,v in pairs(tb) do
        if v then
            if not v.isRead or not v.isReceive then
                mailExist = true
                break
            end
        end
    end
    return mailExist
end

-----------------------------------重载接口------------------------------------


this.MsgIdList = 
{
    { msgid = MSG_ID.MSG_MAIL_LIST, func = this.S2C_GetMailList },
    { msgid = MSG_ID.MSG_MAIL_DETAIL, func = this.S2C_GetMailDetail },
    { msgid = MSG_ID.MSG_MAIL_SET_READ, func = this.S2C_GetMailRead },
    { msgid = MSG_ID.MSG_MAIL_REWARD_RECEIVE, func = this.S2C_GetMailReward},
    { msgid = MSG_ID.MSG_FETCH_FEEDBACK_SEASON_CARDS, func = this.S2C_FetchFeedbackSeasonCards},
    { msgid = MSG_ID.MSG_SEASON_CARD_FEEDBACK, func = this.S2C_SeasonCardFeedback},
}

return this 