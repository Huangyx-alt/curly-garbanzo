--感谢或者聊天话

local ClubMessageBaseItem = require "View/ClubView/ChildView/ClubMessageBaseItem"
local ClubMessageTextItem = ClubMessageBaseItem:New("ClubMessageTextItem")
local base64 = require "Common/base64"
local this = ClubMessageTextItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "HeadObjPrefab",          --点击
    "imageFrame",
    "nameTxt",
    "timeTxt",
    "LHIcon",
    "bg",
    "strTxt",
    "NodeAnimator",
    "Upvote" --点赞
} 

function ClubMessageTextItem:New(data)
    local o = {}
    self.__index = self
    self.data = data
    setmetatable(o,self)
    return o
end

function ClubMessageTextItem:Awake()
    self:on_init()
end

function ClubMessageTextItem:OnEnable(data)

    if data then 
        self.data = data
    end 
    
end

function ClubMessageTextItem:Updata(istop)
    --初始化系统信息
    local chatList =  ModelList.ClubModel.GetMessageList()

    if self.data.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_TEXT then 
        if chatList[self.data.msgId] ~= nil then 
            self.data = chatList[self.data.msgId] 
        end 
        local decoded = base64.decode(self.data.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_TEXT,decoded)
        self.data.ChatInfo = deep_copy(ChatInfo) 
        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(self.data.info.avatar)

        if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
            --设置头像位置
            self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(427, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            self.nameTxt.gameObject.transform.localPosition = Vector3.New(700, self.nameTxt.gameObject.transform.localPosition.y, 0)
            self.NodeAnimator.gameObject.transform.localPosition = Vector3.New(-351, self.NodeAnimator.gameObject.transform.localPosition.y, 0)
            fun.set_gameobject_scale(self.bg,-1,1,1)
            fun.set_active(self.Upvote ,false)
        else 
            --设置 
            self.nameTxt.gameObject.transform.localPosition = Vector3.New(60, self.nameTxt.gameObject.transform.localPosition.y, 0)
            self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(-424, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            self.NodeAnimator.gameObject.transform.localPosition = Vector3.New(-428, self.NodeAnimator.gameObject.transform.localPosition.y, 0)
            fun.set_gameobject_scale(self.bg,1,1,1)

            if ChatInfo.info and ChatInfo.info.uid and ChatInfo.info.uid ~= 0 and ChatInfo.info.uid == ModelList.PlayerInfoModel:GetUid()  then 
                fun.set_active(self.Upvote ,true)
            else 
                fun.set_active(self.Upvote ,false)
            end 
        end    
        
        --初始化头像
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imageFrame)
        self.strTxt.text = ChatInfo.text
        self.nameTxt.text = self.data.info.nickname
    end
    return true
end

--有可能需要更新相关时间
function ClubMessageTextItem:UpdateTime()
    local time = self.data.msgUnix - os.time()

    if time<= 0 then 
        fun.set_active(self.go,false)
        return 
    end 
end 

function ClubMessageTextItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--展示动画 子类复写
function ClubMessageTextItem:ShowAnima()
    if self.go == nil or fun.get_active_self(self.go) == false then 
        return;
    end 

    if self.NodeAnimator then 
        AnimatorPlayHelper.Play(self.NodeAnimator,{"strat","ClubMainViewqipao"},false,function()
      
        end)
    end 
end

--判断是否可以领取 
function ClubMessageTextItem:CanGetReward()
    return false 
end

return this 