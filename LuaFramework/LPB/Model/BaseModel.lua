--region BaseModel.lua
--业务逻辑基类
--endregion
local setmetatable = setmetatable;
BaseModel = {};
local this = BaseModel;
this.__index = this;


--创建Model对象
function BaseModel:New(name)
    return setmetatable({name = name }, this);
end

function BaseModel:CancelInitData()

end

--[[
    @desc: 需要重写,
    author:{author}
    time:2021-05-20 14:44:21
    @return:
]]
function BaseModel:InitData()
    --log.r("需要重写此方法,用于切帐号时初始化数据  "..tostring(self.name))
end

--需要时重写
function BaseModel:SetLoginData(data)

end

--需要时重写
function BaseModel:SetDataUpdate(data,params)

end
function BaseModel:SendDataToBase64(id,data)
    return id,Base64.encode(Proto.encode(id,data))
end

function BaseModel:ClearCache()
    self.cache_data = nil
end
function BaseModel:SaveToCache(key,value)
    if(self.cache_data==nil)then 
        self.cache_data = {}
    end
    if(value and type(value)=="table" and GetTableLength(value)==0)then 
        return --空数据
    end
    self.cache_data[key] = deep_copy(value) 
end

function BaseModel:GetDataByCache(key)
    if(self.cache_data==nil)then 
       return nil 
    end
    return self.cache_data[key] 
end

function BaseModel:IsExistCache()
    if self.cache_data == nil or GetTableLength(self.cache_data)==0 then 
        return false 
    end
    return true 
end

local function pack_request_data(msg_id,tbl)
	return Base64.encode(Proto.encode(msg_id,tbl))
end


--发送网络消息--
function BaseModel.SendMessage(msgId,msgBodyTb,noNeedRespone,needResend)
	-- local strBody =Base64.encode(Proto.encode(msgId,msgBodyTb))

    -- if(msgId~= MSG_ID.MSG_USER_PING)then 
    --     log.r('@--------Send Network Message, Id>>: ' .. msgId .. ', data content>>: ' ,msgBodyTb);
    -- end
    -- CS.NetworkManager:SendMessage(msgId,strBody);
    return Network.SendMessage(msgId,msgBodyTb,noNeedRespone,needResend)
end

--发送通知--
function BaseModel.SendNotification(notifyName, ...)
	Facade.SendNotification(notifyName, ...);
end


function BaseModel:RegEvent()
    if self.name == "BaseGameModel" then
        log.log("dghdgh00001 BaseGameModel RegEvent")
    end
    if(self.MsgIdList )then
        for k1, v1 in ipairs(self.MsgIdList) do
            if v1.msgid then Message.AddMessage(v1.msgid, v1.func) end
        end
    end

    if(self.BaseMsgIdList )then
        for k1, v1 in ipairs(self.BaseMsgIdList) do
            if v1.msgid then Message.AddMessage(v1.msgid, v1.func) end
        end
    end
end

function BaseModel:unRegEvent()
    if self.name == "BaseGameModel" then
        log.log("dghdgh00001 BaseGameModel unRegEvent")
    end
    if(self.MsgIdList )then
        for k1, v1 in ipairs(self.MsgIdList) do
            if v1.msgid then Message.RemoveMessage(v1.msgid) end
        end
    end
    if(self.BaseMsgIdList )then
        for k1, v1 in ipairs(self.BaseMsgIdList) do
            if v1.msgid then Message.RemoveMessage(v1.msgid) end
        end
    end
end


--释放Model对象--
function BaseModel:Destroy()
    self:unRegEvent()
    setmetatable(self, {});
end

-- 等级变化时调用
function BaseModel:OnLevelChange()

end
return this;