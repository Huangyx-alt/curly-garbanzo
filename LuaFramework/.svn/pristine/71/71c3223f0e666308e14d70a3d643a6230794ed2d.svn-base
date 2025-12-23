local ClubMessageBaseItem = require "View/ClubView/ChildView/ClubMessageBaseItem"
local base64 = require "Common/base64"
local ClubMessageMoneyItem = ClubMessageBaseItem:New("ClubMessageMoneyItem")

local this = ClubMessageMoneyItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "HeadObjPrefab",          --点击
    "other",
    "self",
    "btn_help",
    "btn_open",
    "imgHead",
} 

function ClubMessageMoneyItem:New(data)
    local o = {}
    self.__index = self
    self.data = data
    setmetatable(o,self)
    return o
end

function ClubMessageMoneyItem:Awake()
    self:on_init()
end

function ClubMessageMoneyItem:OnEnable(data)
    if data then 
        self.data = data
    end 
    
end

function ClubMessageMoneyItem:Updata()
    --初始化系统信息
    local chatList =  ModelList.ClubModel.GetMessageList()

    if self.data.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_RESOURCE_ASK then 
    
        if chatList[self.data.msgId] ~= nil then 
            self.data = chatList[self.data.msgId] 
        end 

        local decoded = base64.decode(self.data.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK, decoded)
        local cdtime = ChatInfo.rewardUnix - os.time()
        local msgUnix = self.data.msgUnix - os.time()
        self.data.rewardUnix = ChatInfo.rewardUnix --暂存时间戳

        if self.data.status == 1 or self.data.status == 2 
         or cdtime <= 0 or msgUnix <= 0 then 
            fun.set_active(self.go,false)
            return false
        end 

        self.data.ChatInfo = deep_copy(ChatInfo) 
        self.data.ChatInfo.players = deep_copy(ChatInfo.players) 
        self.data.rewardUnix = ChatInfo.rewardUnix
        local itemIconSprite = Csv.GetItemOrResource(ChatInfo.itemId, "icon")
        local itemName = Csv.GetData("resources",ChatInfo.itemId, "name") 
        local desc = string.format(Csv.GetDescription(30064),itemName) 
        
        if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
            fun.set_active(self.self,true)
            fun.set_active(self.other,false)
            local refItem = fun.get_component(self.self,fun.REFER)
            local ItemIcon = refItem:Get("icon")
            local nameTxt = refItem:Get("nameTxt")
            local countTxt = refItem:Get("countTxt")
            local timeTxt = refItem:Get("timeTxt")
            local name2Txt = refItem:Get("name2Txt")
            local Slider = refItem:Get("Slider")
            local PlayerCount = fun.table_len(ChatInfo.players) or 0
            local process = PlayerCount/ChatInfo.target
            local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(self.data.info.avatar == "" and "2" or self.data.info.avatar)
            
            --设置头像位置
            self.HeadObjPrefab.gameObject.transform.localPosition = Vector3.New(424, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            
            --初始化头像
            --self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName) 
            ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
            --初始化名字
            nameTxt.text = self.data.info.nickname
            name2Txt.text = desc
            ItemIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)

            --初始化 进度条
            Slider.fillAmount = process
            countTxt.text = tostring(PlayerCount).."/"..tostring(ChatInfo.target)

            timeTxt.text = fun.SecondToStrFormat(ChatInfo.rewardUnix - os.time()) 

            --帮助置灰
            Util.SetImageColorGray(self.btn_open,PlayerCount ~= ChatInfo.target)
            fun.enable_button(self.btn_open,PlayerCount == ChatInfo.target and PlayerCount ~= 0)
        else 
            fun.set_active(self.self,false)
            fun.set_active(self.other,true)
            local refItem = fun.get_component(self.other,fun.REFER)
            local ItemIcon = refItem:Get("icon")
            local nameTxt = refItem:Get("nameTxt")
            local countTxt = refItem:Get("countTxt")
            local timeTxt = refItem:Get("timeTxt")
            local name2Txt = refItem:Get("name2Txt")
            local Slider = refItem:Get("Slider")
            local PlayerCount = fun.table_len(ChatInfo.players) or 0
            local process = PlayerCount/ChatInfo.target
            local haveHelp = false
            local cdtime = ChatInfo.rewardUnix - os.time()
            for _,v in pairs(ChatInfo.players) do
                if v.uid == ModelList.PlayerInfoModel:GetUid() then 
                    haveHelp = true 
                    break;
                end 
            end

            local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(self.data.info.avatar == "" and "2" or self.data.info.avatar)

            --设置
            self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(-421, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            
            --初始化头像
          --  self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName) 
            ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
            --初始化名字
            nameTxt.text = self.data.info.nickname
            name2Txt.text = desc
            --初始化请求资源
            ItemIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)

            --初始化进度条
            Slider.fillAmount = process
            countTxt.text = tostring(PlayerCount).."/"..tostring(ChatInfo.target)
            
            --初始化时间
            timeTxt.text = fun.SecondToStrFormat(cdtime) 

            if cdtime <= 0 or process == 1 then 
                haveHelp = true;
            end 


            --帮助置灰
            Util.SetImageColorGray(self.btn_help,haveHelp)
            fun.enable_button(self.btn_help,not haveHelp)
        end 
   end 
   return true
end

function ClubMessageMoneyItem:on_btn_help_click()
    --判断是否可以帮助
   if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
        return 
   end 

   if self:HaveHelpOther() then 
        return
   end

   ModelList.ClubModel.C2S_ClubRoomAskResHelp(self.data.msgId)
end

--检查是否帮助过
function ClubMessageMoneyItem:HaveHelpOther()
  local haveHelp = false
  local decoded = base64.decode(self.data.msgBase64)
  local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK,decoded)
  if not ChatInfo or not ChatInfo.players then 
    return  false
  end
    --判断帮助得按钮是否可以出现
    for _,v in pairs(ChatInfo.players) do
                
        if v.uid == ModelList.PlayerInfoModel:GetUid() then 
            haveHelp = true 
            break;
        end 
    end
    return haveHelp
end

--打开
function ClubMessageMoneyItem:on_btn_open_click()
    --判断是否可以打开
    if self.data.info.uid ~= ModelList.PlayerInfoModel:GetUid() then 
        return 
    end 

    --展示一个奖励界面
    local decoded = base64.decode(self.data.msgBase64)
    local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK,decoded)
    
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,ChatInfo.reward,function()
        ModelList.ClubModel.C2S_ClubRoomAskResOpen(self.data.msgId)
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
       
    end)

end

--有可能需要更新相关时间
function ClubMessageMoneyItem:UpdateTime()
    local time = self.data.msgUnix - os.time()
    local rewardunix = self.data.rewardUnix - os.time()
    if time<= 0 or rewardunix <= 0 then 
        fun.set_active(self.go,false)
        return 
    end 

    if self.self ~= nil and fun.get_active_self(self.self) == true and self.data.msgUnix then 
        local refItem = fun.get_component(self.self,fun.REFER)
        local timeTxt = refItem:Get("timeTxt")
        timeTxt.text = fun.SecondToStrFormat(time >0 and time or 0) 
    end 

    if self.other ~= nil and fun.get_active_self(self.other) == true and self.data.msgUnix then 
        local refItem = fun.get_component(self.other,fun.REFER)
        local timeTxt = refItem:Get("timeTxt")
        timeTxt.text = fun.SecondToStrFormat(time >0 and time or 0) 
    end 
end 

function ClubMessageMoneyItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function ClubMessageMoneyItem:ShowAnima()
    if fun.get_active_self(self.go) == false then 
        return;
    end 
    if fun.get_active_self(self.self) == true then 
        local anima = fun.get_component(self.self,fun.ANIMATOR)
        if anima then 
            AnimatorPlayHelper.Play(anima,{"strat","ClubMainViewqipao"},false,function()
      
            end)
        end 
    end 

    if fun.get_active_self(self.other) == true then 
        local anima = fun.get_component(self.other,fun.ANIMATOR)
        if anima then 
            AnimatorPlayHelper.Play(anima,{"strat","ClubMainViewqipao"},false,function()
      
            end)
        end 
    end 
end

--是否可以领取奖励
function ClubMessageMoneyItem:CanGetReward()
    local chatList =  ModelList.ClubModel.GetMessageList()
    local data  = nil
  
    if chatList[self.data.msgId] ~= nil  then 
        data = chatList[self.data.msgId] 
    end 

    if not data or fun.get_active_self(self.go) == false then 
        return false
    end 

    if self.data.status == 1 or self.data.status == 2 then 
       return false
   end 

    local decoded = base64.decode(self.data.msgBase64)
    local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK,decoded)
    if data.info.uid == ModelList.PlayerInfoModel:GetUid() and fun.table_len(ChatInfo.players) == ChatInfo.target then 
        return true;
    end 

    if data.info.uid ~= ModelList.PlayerInfoModel:GetUid() then 
        local haveHelp = false
        
        if fun.table_len(ChatInfo.players) < ChatInfo.target then 
            for _,v in pairs(ChatInfo.players) do
                if v.uid == ModelList.PlayerInfoModel:GetUid() then 
                    haveHelp = true 
                    break;
                end 
            end
        else 
            haveHelp = true 
        end 

        return not haveHelp;
    end 

    return false
end 

return this