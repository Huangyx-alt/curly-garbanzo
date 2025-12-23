--系统消息
local ClubMessageBaseItem = require "View/ClubView/ChildView/ClubMessageBaseItem"
local base64 = require "Common/base64"
local ClubMessageSysItem = ClubMessageBaseItem:New("ClubMessageSysItem")
local this = ClubMessageSysItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Text",          --点击
} 

function ClubMessageSysItem:New(data)
    local o = {}
    self.__index = self
    self.data = data
    setmetatable(o,self)
    return o
end

function ClubMessageSysItem:Awake()
    self:on_init()
end

function ClubMessageSysItem:OnEnable(data)
    if data then 
        self.data = data
    end 
    
end

function ClubMessageSysItem:Updata()
     --初始化系统信息
     local chatList =  ModelList.ClubModel.GetMessageList()
     if self.data.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_SYSTEM then 
        if chatList[self.data.msgId] ~= nil then 
            self.data = chatList[self.data.msgId] 
        end 
        
        local decoded = base64.decode(self.data.msgBase64)
         local sysChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_SYSTEM,decoded)
        log.w("ClubMessageSysItem"..self.data.msgId..sysChatInfo.text )
        self.Text.text = sysChatInfo.text 
    end 

    return true
end

function ClubMessageSysItem:UpdateTime()
    local time = self.data.msgUnix - os.time()

    if time<= 0 then 
        fun.set_active(self.go,false)
        return 
    end 
end

function ClubMessageSysItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--判断是否可以领取 
function ClubMessageSysItem:CanGetReward()
    return false 
end

return this