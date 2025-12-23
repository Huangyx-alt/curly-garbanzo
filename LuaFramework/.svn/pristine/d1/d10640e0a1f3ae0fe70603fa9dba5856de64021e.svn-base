--后端主动通知前端展示消息
--用于以下情况：
--1、后端通知前端展示弹窗消息
--2、待拓展
--.......

local ServerNotifyModel = BaseModel:New('ServerNotifyModel')

local this = ServerNotifyModel
local private = {}

function ServerNotifyModel:InitData()
    this.customPopUp = {}
end

function ServerNotifyModel:SetLoginData(data)
    this.customPopUp = data.customPopUp or {}
end

function ServerNotifyModel:ShowServerNotify(cb)
    this.allShowCompleteCb = cb
    private.ShowNextServerNotify()
end

----------------------给后端发消息接口-----------------------------
function ServerNotifyModel:C2S_CustomPopUpView(popUpData)
    if popUpData and popUpData.type then
        this.SendMessage(MSG_ID.MSG_VIEW_CUSTOM_POP_UP, {type = popUpData.type})  
    end
end

----------------------接收后端消息接口-----------------------------
--收到服务器-推送客户端-自定义弹框
function ServerNotifyModel.S2C_OnPopUp(code, data)
    if code == RET.RET_SUCCESS then
        this.customPopUp = this.customPopUp or {}
        table.each(data.customPopUp, function(data)
            table.insert(this.customPopUp, data)
        end)
    end
end

function ServerNotifyModel.S2C_On_CustomPopUpViewShowComplete(code, data)
    if code == RET.RET_SUCCESS then

    end
end

----------------------Private Func-----------------------------
--顺序展示所有服务器推送的自定义弹框
function private.ShowNextServerNotify()
    local popUpData = table.remove(this.customPopUp or {}, 1)
    if popUpData then
        private.ShowNotify(popUpData)
    else
        if this.allShowCompleteCb then
            this.allShowCompleteCb()
        end
    end
end

function private.ShowNotify(popUpData)
    if popUpData.type == CUSTOM_POP_UP_TYPE.TYPE_CLUB_QUIT_PASSIVE then
        UIUtil.show_common_popup_with_options({
            isSingleBtn = true,
            contentText = popUpData.msg,
            sureCb = function() private.OnNotifyShowComplete(popUpData) end,
            cancel_cb = function() private.OnNotifyShowComplete(popUpData) end,
        })
    else
        private.ShowNextServerNotify()
    end
end

--某个弹窗展示完成之后
function private.OnNotifyShowComplete(popUpData)
    this:C2S_CustomPopUpView(popUpData)
    private.ShowNextServerNotify()
end

this.MsgIdList =
{
    { msgid = MSG_ID.MSG_CUSTOM_POP_UP, func = this.S2C_OnPopUp},
    { msgid = MSG_ID.MSG_VIEW_CUSTOM_POP_UP, func = this.S2C_On_CustomPopUpViewShowComplete},
}

return this 