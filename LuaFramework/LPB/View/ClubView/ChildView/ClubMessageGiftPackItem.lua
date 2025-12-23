---礼盒得消息
---
local ClubMessageBaseItem = require "View/ClubView/ChildView/ClubMessageBaseItem"
local ClubMessageGiftPackItem = ClubMessageBaseItem:New("ClubMessageGiftPackItem")
local base64 = require "Common/base64"
local this = ClubMessageGiftPackItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "HeadObjPrefab",          --点击
    "imageFrame",
    "nameTxt",
    "timeTxt",
    "btn_open",
    "HeadList",
    "LHIcon",
    "item",
    "bg",
    "Node",
    "tipTxt",
    "logBg",
    "open_text",
    "bg"
} 

function ClubMessageGiftPackItem:New(data)
    local o = {}
    self.__index = self
    self.data = data
    setmetatable(o,self)
    return o
end

function ClubMessageGiftPackItem:Awake()
    self:on_init()
end

function ClubMessageGiftPackItem:OnEnable(data)

    if data then 
        self.data = data
    end 
    
end

function ClubMessageGiftPackItem:Updata(istop,data)
    --初始化系统信息
    local chatList =  ModelList.ClubModel.GetMessageList()

    if self.data.type == CLUB_CHAT_MESSAGE_TYPE.CHAT_TYPE_PACKET then 
        if data ~= nil then 
            self.data =data
        end 
     
        --更新消息
        if chatList[self.data.msgId] ~= nil then 
            self.data = chatList[self.data.msgId] 
        end 

        local decoded = base64.decode(self.data.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
        local cdtime = ChatInfo.rewardUnix - os.time()
        local msgUnix = self.data.msgUnix - os.time()
        self.data.rewardUnix = ChatInfo.rewardUnix --暂存时间戳

        if self.data.status == 1 or self.data.status == 2 
         or cdtime <= 0 or msgUnix <= 0 then 
            fun.set_active(self.go,false)
            return false
        end 

        if not istop then 
            --是自己还是
            if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
                --设置头像位置
                self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(420, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
                self.Node.gameObject.transform.localPosition =  Vector3.New(-348, self.Node.gameObject.transform.localPosition.y, 0)
                fun.set_gameobject_scale(self.bg,-1,1,1)
            else 
                --设置
                self.Node.gameObject.transform.localPosition =  Vector3.New(-424, self.Node.gameObject.transform.localPosition.y, 0)
                self.HeadObjPrefab.gameObject.transform.localPosition =  Vector3.New(-421, self.HeadObjPrefab.gameObject.transform.localPosition.y, 0)
                fun.set_gameobject_scale(self.bg,1,1,1)
            end 
        else 
            if self.tipTxt ~= nil then
                self.tipTxt.text = Csv.GetDescription(30094)
            end 
            if self.logBg ~= nil then
                local itemResult = Csv.GetData("item", ChatInfo.itemId,"result")
                local level = 1 
                local tmpTB = {
                    [1] = "clubgonghuiliaotian34",
                    [2] = "clubgonghuiliaotian33",
                    [3] = "clubgonghuiliaotian32",
                }
                if itemResult and itemResult[2]  then
                    level = itemResult[2] 
                end 
                self.logBg.sprite = AtlasManager:GetSpriteByName("ClubAtlas",tmpTB[level])    
            end 
             --clubgonghuiliaotian8  clubgonghuiliaotian1
             if self.bg ~= nil then 
                if self.data.info.uid == ModelList.PlayerInfoModel:GetUid() then 
                    self.bg.sprite = AtlasManager:GetSpriteByName("ClubAtlas","clubgonghuiliaotian1")    
                else 
                    self.bg.sprite = AtlasManager:GetSpriteByName("ClubAtlas","clubgonghuiliaotian8" )    
                end 
             end 

        end 

        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(self.data.info.avatar)
        local GiftIconSprite = Csv.GetItemOrResource(ChatInfo.itemId, "icon")
        local playerOpenCount = fun.table_len(ChatInfo.packetInfo)
        local isShow = true 
        local index = 1

       -- self.imageFrame.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)  
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imageFrame)
        --初始化名字
        self.nameTxt.text = self.data.info.nickname
        --初始化时间戳
        self.timeTxt.text = fun.SecondToStrFormat(cdtime) 
      
        --如果是人数满或者已经领取过的情况 btn_open 隐藏
        if playerOpenCount >= ChatInfo.maxOpenNum then 
            isShow = false 
        end 

        self.LHIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas",GiftIconSprite)    
    
        for i =1 ,fun.get_child_count(self.HeadList) do
            local item = fun.find_child(self.HeadList,"item"..tostring(index))
            if item ~= nil then 
                local refItem = fun.get_component(item , fun.REFER)
                local headImg = refItem:Get("imgHead")
                fun.set_active(headImg,false)
            end 
            index = index + 1
        end 

        index = 1
        for _,v in pairs(ChatInfo.packetInfo) do
            if v.player.uid == ModelList.PlayerInfoModel:GetUid() then 
                isShow = false 
            end 
            local item = fun.find_child(self.HeadList,"item"..tostring(index))
            if item ~= nil then 
                local refItem = fun.get_component(item , fun.REFER)
                local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(v.player.avatar)
               
                local headImg = refItem:Get("imgHead")
                fun.set_active(headImg,true)
             --   headImg.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)
                ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, headImg)
                index = index + 1
            end 
          
        end 

        if isShow then 
            fun.set_active(self.btn_open,true)
            self.open_text.text ="OPEN"
            self.isList = false
        else 
            fun.set_active(self.btn_open,true)
            self.open_text.text ="LIST"
            self.isList = true
        end 
    
    end
    return true
end

--打开
function ClubMessageGiftPackItem:on_btn_open_click()
    --判断是否可以打开 
    if  not self.isList then 
        ModelList.ClubModel.C2S_ClubGiftPackageOpen(self.data.msgId)
    else 
        Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubOpenPackGiftGetListView,nil,nil,self.data.msgId)
    end 
    
end

--有可能需要更新相关时间
function ClubMessageGiftPackItem:UpdateTime()
    if  self.data~= nil and  
        self.data.rewardUnix ~= nil and 
        self.timeTxt ~= nil then 
        local time =self.data.rewardUnix - os.time()

        if time<= 0 then 
            fun.set_active(self.go,false)
            return 
        end 

        --初始化时间戳
        self.timeTxt.text = fun.SecondToStrFormat(time > 0 and time or 0) 
    end 
end 

function ClubMessageGiftPackItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function ClubMessageGiftPackItem:ShowAnima()
    if fun.get_active_self(self.go) == false then 
        return;
    end 

    if self.Node then 
        local anima = fun.get_component(self.Node,fun.ANIMATOR)
        if anima then
            AnimatorPlayHelper.Play(anima,{"strat","ClubMainViewqipao"},false,function()
        
            end)
        end
    end 
end

function ClubMessageGiftPackItem:CanGetReward()
    local chatList =  ModelList.ClubModel.GetMessageList()

    if chatList[self.data.msgId] ~= nil then 
        self.data = chatList[self.data.msgId] 
    end 

    local decoded = base64.decode(self.data.msgBase64)
    local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
    local flag = true;
    for _,v in pairs(ChatInfo.packetInfo) do
        if v.player.uid == ModelList.PlayerInfoModel:GetUid() then 
            flag = false 
        end 
    end 
    return flag  
end 

return this 