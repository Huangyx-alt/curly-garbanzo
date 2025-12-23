local ClubChatView =BaseView:New("ClubChatView","ClubAtlas")
local base64 = require "Common/base64"
local this = ClubChatView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Message_sys", --系统消息
    "Message_card", --卡牌消息
    "Message_Money",
    "Message_Package",  --礼包
    "Message_Text",
    "Content",   --聊天内容
    "btn_AskMoney", --请求资源按钮
    "btn_AskCard",  --请求卡牌按钮
    "btn_giftPacket",
    "ClubInfoPanel", --俱乐部信息
    "top_Item",
    "gfitPacketPanel",
    "chatView",
    "PanelChat",--聊天得总大小界面
    "btn_closeGift", --
    "btn_GiftTip",
}

this.giftIndex = 0
this.nativeContentRectHeight = 0
local ChatItemList={}

function ClubChatView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubChatView:Awake()
    self:on_init()
 
end


function ClubChatView:OnEnable()
   self:initdata()
   self.luabehaviour:AddScrollRectChange(self.chatView.gameObject, function(value)
    self:OnScrollValueChange(value)
    end)
   --刷新聊天得消息
   ModelList.ClubModel.C2S_ClubFetRoomInfo()
end

function ClubChatView:initdata()
    --个人信息界面
    if not this.ClubInfoView then 
        local review = require "View/ClubView/ClubInfoView"
        this.ClubInfoView = review:New()
        this.ClubInfoView:SkipLoadShow(self.ClubInfoPanel,true,nil)
    end 

    --礼盒发送界面
    if not this.gfitPacketView then 
        local review = require "View/ClubView/ClubPagGiftView"
        this.gfitPacketView = review:New()
        this.gfitPacketView:SkipLoadShow(self.gfitPacketPanel,true,nil)
        
    end 
    
    fun.set_active(self.gfitPacketPanel,false)
    fun.set_active(self.top_Item,false)
end

function ClubChatView:Updata()

    if this.ClubInfoView ~= nil then 
        this.ClubInfoView:Updata()
    end 

    if this.gfitPacketView ~= nil then 
        this.gfitPacketView:Updata()
    end 

    self:CheckResourecdTime()

    --初始化聊天信息
    local chatList =  ModelList.ClubModel.GetMessageList()
    local tmpchatList = {}
    local nativeContentRectHeight = 0 
    local nativemsgid = -1
    this.giftIndex = 0;

    for _,v in pairs(chatList) do 
        table.insert(tmpchatList,v)
    end

    table.sort(tmpchatList,function(a,b)
        return a.msgId < b.msgId
    end)

    for _,v in pairs(tmpchatList) do 
    
        if not ChatItemList[v.msgId]  then 
            if  v.msgUnix ==0 or  v.msgUnix >= os.time() then 

                if v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_SYSTEM then
                    local viewSys = require "View/ClubView/ChildView/ClubMessageSysItem"
                    local view_instance = nil
                    local item = fun.get_instance(self.Message_sys,self.Content)
                    view_instance = viewSys:New(v)
                    view_instance:SkipLoadShow(item)
                    ChatItemList[v.msgId] = view_instance
                    local show =  ChatItemList[v.msgId]:Updata()
                    fun.set_active(view_instance:GetTransform(),show,false)
                --请求资源
                elseif  v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_RESOURCE_ASK then
                    local viewMoney = require "View/ClubView/ChildView/ClubMessageMoneyItem"
                    local view_instance = nil
                    local item = fun.get_instance(self.Message_Money,self.Content)
                    view_instance = viewMoney:New(v)
                    view_instance:SkipLoadShow(item)
                    ChatItemList[v.msgId] = view_instance
                    local show =  ChatItemList[v.msgId]:Updata()
                    fun.set_active(view_instance:GetTransform(),show,false)

                    if show and (this.giftIndex == 0 or this.giftIndex > v.msgId) and v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_RESOURCE_ASK and ChatItemList[v.msgId]:CanGetReward() then --显示中
                        this.giftIndex =  v.msgId
                    end 

                --请求卡牌
                elseif v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_SEASON_CARD_ASK then
                    local viewcard = require "View/ClubView/ChildView/ClubMessageCardItem"
                    local view_instance = nil
                    local item = fun.get_instance(self.Message_card,self.Content)
                    view_instance = viewcard:New(v)
                    view_instance:SkipLoadShow(item)
                    ChatItemList[v.msgId] = view_instance
                    local show =  ChatItemList[v.msgId]:Updata()
                    fun.set_active(view_instance:GetTransform(),show,false)

                elseif v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET then
                    local viewcard = require "View/ClubView/ChildView/ClubMessageGiftPackItem"
                    local view_instance = nil
                    local item = fun.get_instance(self.Message_Package,self.Content)
                    view_instance = viewcard:New(v)
                    view_instance:SkipLoadShow(item)
                    ChatItemList[v.msgId] = view_instance
                    local show =  ChatItemList[v.msgId]:Updata()

                    fun.set_active(view_instance:GetTransform(),show,false)
                    if show and ( this.giftIndex == 0 or this.giftIndex > v.msgId) and v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET and ChatItemList[v.msgId]:CanGetReward() then --显示中
                        this.giftIndex =  v.msgId
                    end 
                elseif v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_TEXT then
                    local viewcard = require "View/ClubView/ChildView/ClubMessageTextItem"
                    local view_instance = nil
                    local item = fun.get_instance(self.Message_Text,self.Content)
                    view_instance = viewcard:New(v)
                    view_instance:SkipLoadShow(item)
                    ChatItemList[v.msgId] = view_instance
                    local show =  ChatItemList[v.msgId]:Updata()
                    fun.set_active(view_instance:GetTransform(),show,false)
                end  
            end 
        else 
            ChatItemList[v.msgId]:Updata()

            if ( this.giftIndex == 0 or this.giftIndex > v.msgId) 
            and (v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET or v.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_RESOURCE_ASK)  
            and ChatItemList[v.msgId]:CanGetReward() then 
                this.giftIndex =  v.msgId
            end     

        end 
    end 
  
    for k,v in pairs(ChatItemList) do 
        if v~= nil and v:GetTransform() ~= nil then 
            local activeSelf = fun.get_active_self(v:GetTransform())
            if activeSelf then
                local Height = fun.get_component(v:GetTransform(),fun.RECT).rect.height
                nativeContentRectHeight = nativeContentRectHeight + Height

                if nativemsgid < k then 
                    nativemsgid = k
                end 
            end 
        end 
    end 

    this.nativeContentRectHeight = nativeContentRectHeight
    --判断top_item 是否要出现
    local topPackage = ModelList.ClubModel.getTopPackage()

    if topPackage ~= nil and (fun.table_len(topPackage) >0) then 
        local topPackeItem = {level = 1,unix = os.time()+864000, index = 1}
        for k,v in pairs(topPackage) do 
            local decoded = base64.decode(v.msgBase64)
            local topInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
            local giftInfo =Csv.GetData("item",topInfo.itemId,"result")
            local Level = nil 
            if not giftInfo or not giftInfo[2] then 
                Level = 1 
            else 
                Level =giftInfo[2]
            end 
            
            if Level > topPackeItem.level or (Level == topPackeItem.level and topInfo.rewardUnix > topPackeItem.unix )then 
                topPackeItem.level = Level
                topPackeItem.unix = topInfo.rewardUnix
                topPackeItem.index = k
            end 
        end 

        if not this.top_itemView  then 
            local viewcard = require "View/ClubView/ChildView/ClubMessageGiftPackItem"
            local view_instance = nil
            view_instance = viewcard:New(topPackage[topPackeItem.index])
            view_instance:SkipLoadShow(self.top_Item)
            this.top_itemView = view_instance
            this.top_itemView:Updata(true)
        else 
            this.top_itemView:Updata(true,topPackage[topPackeItem.index])
        end 

        fun.set_active(self.top_Item, true)
    else 
        if this.top_itemView ~= nil  then 
            this.top_itemView:OnDestroy()
            this.top_itemView = nil
        end 
        fun.set_active(self.top_Item, false)
    end 
    
    self:updateRect(nativeContentRectHeight,nativemsgid)
    self:UpdataGiftCount()
end

function ClubChatView:OnScrollValueChange(value)
  
    local isInBox = self:CheckIsInboxGift()
    fun.set_active(self.btn_GiftTip,isInBox ~= 1)
    self:ChangeGiftArrow(isInBox)
   
end 

function ClubChatView:ChangeGiftArrow(isInBox)
    if isInBox ~= 1 then 
        local refer  = fun.get_component(self.btn_GiftTip,fun.REFER)
        local gameobject = refer:Get("arrow")
        if isInBox == 0 then 
            Anim.rotate(gameobject,0,0,0,0,true,nil,nil)
          --  gameobject.transform.localRotation.x = 0
        else
            Anim.rotate(gameobject,180,0,0,0,true,nil,nil)
          --  gameobject.transform.localRotation.x = 180
        end 
    end 

end

--判断是否在box中
function ClubChatView:CheckIsInboxGift()
    if this.giftIndex == 0 or not ChatItemList[this.giftIndex] then 
        return 1
    end 

    local y = self.Content.transform.localPosition.y -- 偏移量
    local rect = fun.get_component(self.chatView,fun.RECT)
    local isInBox = 0  -- 0 在上面， 1在中间 2在下面
    
    local topHight = y
    local downHight = y+ rect.rect.height 
    local boxY =math.abs(ChatItemList[this.giftIndex]:GetTransform().localPosition.y )  
     local boxrect = fun.get_component(ChatItemList[this.giftIndex]:GetTransform().gameObject,fun.RECT)
     boxY = boxY + (boxrect.rect.height/3)

    if boxY >topHight and downHight > boxY then 
        isInBox = 1
    elseif boxY <= topHight then 
        isInBox = 0
    elseif boxY >= downHight then 
        isInBox = 2
    end 
    return isInBox
end 

--动态变换尺寸
function ClubChatView:updateRect(nativeContentRectHeight,nativemsgid)
     --不要改布局不然有问题
     local PanelChat = fun.get_component(self.PanelChat,fun.RECT)
     local contentRect =  fun.get_component(self.Content,fun.RECT)
     local rect = fun.get_component(self.chatView,fun.RECT)

     if fun.get_active_self(self.top_Item) == true then 
         --变化框大小 
         local topRect = fun.get_component(self.top_Item,fun.RECT)
         rect.sizeDelta = Vector2.New(rect.sizeDelta.x, PanelChat.rect.height - topRect.rect.height)
     else 
         rect.sizeDelta = Vector2.New(rect.sizeDelta.x, PanelChat.rect.height)
     end 

    

    if this.giftIndex == 0 then 
        if nativeContentRectHeight - contentRect.rect.height < 10 then 
        return 
        end 

        if rect.rect.height - nativeContentRectHeight > 0  then 
        return 
        end

        fun.set_active(self.btn_GiftTip,false)
        Anim.move_ease(self.Content,0 ,nativeContentRectHeight -rect.rect.height  ,0,1,true,DG.Tweening.Ease.Flash,function()
         
        end)
    else 
        local isInBox = self:CheckIsInboxGift()
        fun.set_active(self.btn_GiftTip,isInBox ~= 1)

        self:ChangeGiftArrow(isInBox)
    end 

    
end

function ClubChatView:on_btn_AskMoney_click()
    if ModelList.ClubModel.CheckCanReqRes() == false then
        return 
    end 

    Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubReqResAskView)
end 

function ClubChatView:on_btn_AskCard_click()
    if ModelList.ClubModel.CheckCanReqCard() == false then
        return 
    end 
    Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubReqCardView)
    
    --出现请求卡牌
end 


function ClubChatView:on_btn_closeGift_click()
    fun.set_active(self.gfitPacketPanel,false)
    fun.set_active(self.btn_closeGift,false)
end

--点击往上
function ClubChatView:on_btn_GiftTip_click()
    if this.giftIndex == 0 or not ChatItemList[this.giftIndex] then 
        fun.set_active(self.btn_GiftTip,false)
        return 
    end 

    --反推偏移量
    local y =  math.abs(ChatItemList[this.giftIndex]:GetTransform().localPosition.y) 
    local rect = fun.get_component(ChatItemList[this.giftIndex]:GetTransform().gameObject,fun.RECT)
    local contentRect =  fun.get_component(self.Content,fun.RECT)
    y = y + (rect.rect.height/2)
    local ChatRect = fun.get_component(self.chatView,fun.RECT)
    
    if y > (contentRect.rect.height - ChatRect.rect.height) then 
        y =  this.nativeContentRectHeight ~= 0 and this.nativeContentRectHeight -ChatRect.rect.height or contentRect.rect.height - ChatRect.rect.height
    else 
        y =  math.abs(ChatItemList[this.giftIndex]:GetTransform().localPosition.y) 
        y = y - (rect.rect.height/2)
    end 

    log.g("反推偏移量"..tostring(y))
    Anim.move_ease(self.Content,0 ,y,0,1,true,DG.Tweening.Ease.Flash,function()

     end)
end 

function ClubChatView:on_btn_giftPacket_click()
   self:closeGiftPacket() 
  
end

function ClubChatView:closeGiftPacket() 
    local flag = fun.get_active_self(self.gfitPacketPanel)

    fun.set_active(self.gfitPacketPanel,not flag)
    fun.set_active(self.btn_closeGift,not flag )
    if false == flag then 
        if this.gfitPacketView ~= nil then 
            this.gfitPacketView:Updata()
        end 
    end 
end 

function ClubChatView:UpdateTime()
    for _,v in pairs(ChatItemList) do 
        if v ~= nil then 
            v:UpdateTime()
        end 
    end     
 
end 

function ClubChatView:CheckResourecdTime()

    self:StopCountdown()

    local refItem = fun.get_component(self.btn_AskMoney , fun.REFER)
    local Mask = refItem:Get("Mask")
    local cdTimeText = refItem:Get("cdTimeText")

    local refItemCard = fun.get_component(self.btn_AskCard , fun.REFER)
    local MaskCard = refItemCard:Get("Mask")
    local cdTimeTextCard = refItemCard:Get("cdTimeText")
    local RescdTime = ModelList.ClubModel.GetReqResCd()
    local CardcdTime = ModelList.ClubModel.GetReqCardCd()

    if RescdTime > os.time() then 
        fun.set_active(Mask,true)
        self.waitReqRescd = LuaTimer:SetDelayLoopFunction(0, 1, RescdTime - os.time(), function()

           local RescdTime = ModelList.ClubModel.GetReqResCd()
           
           cdTimeText.text = fun.SecondToStrFormat(RescdTime-os.time()) 


        end,function()
            fun.set_active(Mask,false)
        end,nil,LuaTimer.TimerType.UI)
    else 
        fun.set_active(Mask,false)
    end 

 
    if CardcdTime > os.time() then 
        fun.set_active(MaskCard,true)
        self.waitReqCardcd = LuaTimer:SetDelayLoopFunction(0, 1, CardcdTime -os.time(), function()
            local CardcdTime = ModelList.ClubModel.GetReqCardCd()
          
            cdTimeTextCard.text = fun.SecondToStrFormat(CardcdTime-os.time()) 
            -- cdTimeTextCard.fontSize = RescdTime-os.time() >3600 and 57 or 76

        end,function()
            fun.set_active(MaskCard,false)
        end,nil,LuaTimer.TimerType.UI)
    else 
        fun.set_active(MaskCard,false)
    end 
end

function ClubChatView:UpdataGiftCount()--获得礼盒总数的数量
    local data = {
        [1] ={
            level = 1,
        },
        [2] = {
            level = 2,
        },
        [3] = {
            level = 3,
        }
    }
    local count = 0
    for _,v in pairs(data) do 
        local pagdata = ModelList.ClubModel.getClubGiftPack(v.level)
        count = count + #pagdata
    end

    local refItem = fun.get_component(self.btn_giftPacket.gameObject , fun.REFER)
    local CountTip = refItem:Get("Count")
    local Text =  refItem:Get("Text")
    local GiftAni = refItem:Get("GiftAni")
    if count > 0 then 
        fun.set_active(CountTip,true)
        Text.text = tostring(count)
        GiftAni:Play("pick")
    else 
        fun.set_active(CountTip,false)
        GiftAni:Play("idle")
    end 

    if this.gfitPacketView ~= nil then 
        this.gfitPacketView:Updata()
    end 
end 

function ClubChatView:StopCountdown()
    if self.waitReqRescd then
        LuaTimer:Remove(self.waitReqRescd)
        self.waitReqRescd = nil
    end

    if self.waitReqCardcd then
        LuaTimer:Remove(self.waitReqCardcd)
        self.waitReqCardcd = nil
    end
end

--更新消息中的 
function ClubChatView:UpdataForMessage()
    this:Updata()
end 

function ClubChatView:UpdatePackageCount()
    self:UpdataGiftCount()
end

--增加list
function ClubChatView:AddMessageToList()

end

function ClubChatView:OnDestroy()
    if  this.ClubInfoView then 
        this.ClubInfoView:OnDestroy()
        this.ClubInfoView = nil
    end 

    if this.gfitPacketView then 
        this.gfitPacketView:OnDestroy()
        this.gfitPacketView = nil
    end 

    if this.top_itemView then 
        this.top_itemView:OnDestroy()
        this.top_itemView = nil
    end     

    for _,v in pairs(ChatItemList) do
        v:OnDestroy()
        v = nil 
    end

    self:StopCountdown()

    ChatItemList ={}

    local culbAssetList = require("Module/ClubAssetList")
    if culbAssetList then
        Cache.unload_ab_no_depen(culbAssetList["ClubChatView"],false)
    end
end

function ClubChatView:OnDisable()
    if  this.ClubInfoView then 
        this.ClubInfoView:OnDestroy()
        this.ClubInfoView = nil
    end 

    if this.gfitPacketView then 
        this.gfitPacketView:OnDestroy()
        this.gfitPacketView = nil
    end 

    if this.top_itemView then 
        this.top_itemView:OnDestroy()
        this.top_itemView = nil
    end     

    for _,v in pairs(ChatItemList) do
        v:OnDestroy()
        v = nil 
    end

    self:StopCountdown()

    ChatItemList ={}
end


return this