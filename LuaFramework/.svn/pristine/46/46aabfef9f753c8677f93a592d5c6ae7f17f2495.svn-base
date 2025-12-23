local ClubMessageBaseItem = require "View/ClubView/ChildView/ClubMessageBaseItem"
local SeasonCardClownCardExchangeItem = require "View/CommonView/SeasonCardClownCardExchangeItem"
local ClubMessageCardItem = ClubMessageBaseItem:New("ClubMessageCardItem")
local base64 = require "Common/base64"

local this = ClubMessageCardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "HeadObjPrefab",          --点击
    "other",
    "self",
    "btn_help",
    "imgHead",
} 

function ClubMessageCardItem:New(data)
    local o = {}
    self.__index = self
    self.data = data
    setmetatable(o,self)
    return o
end

function ClubMessageCardItem:Awake()
    self:on_init()
end

function ClubMessageCardItem:OnEnable(data)
    if data then 
        self.data = data
    end 
    
end
  
function ClubMessageCardItem:Updata()

    -- if self.seasonCarditem then 
    --     self.seasonCarditem:OnDestroy()
    --     self.seasonCarditem = nil 
    -- end 

    --初始化系统信息
    local chatList =  ModelList.ClubModel.GetMessageList()

    --初始化系统信息
    if self.data.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_SEASON_CARD_ASK then 
        if chatList[self.data.msgId] ~= nil then 
            self.data = chatList[self.data.msgId] 
        end 
        
        local decoded = base64.decode(self.data.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_SEASON_CARD_ASK,decoded)
        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(self.data.info.avatar == "" and "2" or self.data.info.avatar)
        local cdtime = ChatInfo.rewardUnix - os.time()
        local msgUnix = self.data.msgUnix - os.time()
        local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
        if self.data.status == 1 or self.data.status == 2 
        or cdtime <= 0 or msgUnix <= 0 then 
           fun.set_active(self.go,false)
           return false
        end 
        
        --不是本赛季的卡牌，直接过滤掉不显示
        if ChatInfo.seasonId ~= curSeasonId then 
            return false 
        end 

        if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
            fun.set_active(self.self,true)
            fun.set_active(self.other,false)
            local refItem = fun.get_component(self.self,fun.REFER)
            local nameTxt = refItem:Get("nameTxt")
            local carditem = refItem:Get("carditem")
            local tipTxt = refItem:Get("tipTxt")
            local countTxt = refItem:Get("countTxt")
            local timeTxt =  refItem:Get("timeTxt")

            self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(416, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            timeTxt.text = fun.SecondToStrFormat(ChatInfo.rewardUnix - os.time()) 

            --初始化头像
            --self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName) 
            ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
            local data = {index = 1, parent = self, cardId = ChatInfo.cardId}
            
            if not self.seasonCarditem  then 
                self.seasonCarditem = SeasonCardClownCardExchangeItem:New()
                self.seasonCarditem:SetData(data)
                self.seasonCarditem:SetOnlyShowBasicInfo()
                self.seasonCarditem:SkipLoadShow(carditem)
                self.seasonCarditem:SetClickEnable(false)    
            end 
            --初始化头像
            
        else 
            fun.set_active(self.self,false)
            fun.set_active(self.other,true)
            local refItem = fun.get_component(self.other,fun.REFER)
            local nameTxt = refItem:Get("nameTxt")
            local tipTxt = refItem:Get("tipTxt")
            local countTxt = refItem:Get("countTxt")
            local carditem = refItem:Get("carditem")
            local timeTxt = refItem:Get("timeTxt")
            local data = {index = 1, parent = self, cardId = ChatInfo.cardId}

            self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(-422, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
            timeTxt.text = fun.SecondToStrFormat(ChatInfo.rewardUnix - os.time()) 
            --初始化头像
            --self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName) 
            ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
            if not self.seasonCarditem then 
                self.seasonCarditem = SeasonCardClownCardExchangeItem:New()
                self.seasonCarditem:SetData(data)
                self.seasonCarditem:SetOnlyShowBasicInfo()
                self.seasonCarditem:SkipLoadShow(carditem)
                self.seasonCarditem:SetClickEnable(false)    
            end 
       
            --初始化名字
            nameTxt.text = self.data.info.nickname
            countTxt.text = "0/1"
            local flag = ModelList.SeasonCardModel:GetCardCount(ChatInfo.cardId) > 1
            
            --帮助置灰
            Util.SetImageColorGray(self.btn_help,not flag)
            fun.enable_button(self.btn_help,flag)
        end 
   end 

   return true
end

function ClubMessageCardItem:on_btn_help_click()
    local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    --判断是否可以帮助
    local decoded = base64.decode(self.data.msgBase64)
    local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_SEASON_CARD_ASK,decoded)

    if curSeasonId ~= ChatInfo.seasonId then 
        --弹个通用弹窗
        Util.SetImageColorGray(self.btn_help,not flag)
        fun.enable_button(self.btn_help,flag)
    else 
        if ModelList.SeasonCardModel:GetCardCount(ChatInfo.cardId) > 1  then 
            Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubReqCardHelpView,nil,nil, self.data.msgId)
        end 
    end 
    
end


--有可能需要更新相关时间
function ClubMessageCardItem:UpdateTime()
    local time = self.data.msgUnix - os.time()

    if time<= 0 and self.data.msgUnix ~= 0 then 
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

function ClubMessageCardItem:OnDisable()
    if self.seasonCarditem then 
        self.seasonCarditem:OnDestroy()
        self.seasonCarditem = nil 
    end 
end 


function ClubMessageCardItem:OnDestroy()
    if self.seasonCarditem then 
        self.seasonCarditem:OnDestroy()
        self.seasonCarditem = nil 
    end 
end

function ClubMessageCardItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function ClubMessageCardItem:ShowAnima()
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

function ClubMessageCardItem:CanGetReward()
    return false 
end 

return this 