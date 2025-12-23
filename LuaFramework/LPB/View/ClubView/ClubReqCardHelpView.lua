--请求卡牌界面 帮忙
--传参 cardid msd 

local ClubReqCardHelpView = BaseView:New("ClubReqCardHelpView","ClubAtlas")
local SeasonCardClownCardExchangeItem = require "View/CommonView/SeasonCardClownCardExchangeItem"

local this = ClubReqCardHelpView
local base64 = require "Common/base64"

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_claim",  --请求发送
    "btn_close",  --关闭
    "imgHead",     --初始化头像
    "CardItem",    --加载一张卡牌
}

function ClubReqCardHelpView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubReqCardHelpView:Awake()
    self:on_init()
end


function ClubReqCardHelpView:OnEnable(msgid)

    if this.seasonCarditem then 
        this.seasonCarditem:OnDestroy()
        this.seasonCarditem = nil 
    end 

    local messageInfo = ModelList.ClubModel.getMessageForid(msgid)
 
    if messageInfo ~= nil then 
        local decoded = base64.decode(messageInfo.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_SEASON_CARD_ASK,decoded)
        local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(messageInfo.info.avatar)
        local data = {index = 1, parent = self, cardId = ChatInfo.cardId}
        ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, self.imgHead)
      --  self.imgHead.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)
       --   初始化卡牌id
        self.msgid = msgid
        --初始化头像
        this.seasonCarditem = SeasonCardClownCardExchangeItem:New()
        this.seasonCarditem:SetData(data)
        this.seasonCarditem:SetOnlyShowBasicInfo()
        this.seasonCarditem:SkipLoadShow(self.CardItem)
        this.seasonCarditem:SetClickEnable(false) 
      --  CardDi03 加载在此节点下
        
    end 

end
 
function ClubReqCardHelpView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ClubReqCardHelpView:on_btn_claim_click()

    if self.msgid ~= nil then 
        --卡牌帮助
        ModelList.ClubModel.C2S_ClubSeasonCardAskHelp(self.msgid)
        Facade.SendNotification(NotifyName.CloseUI,this)
    end 
end

function ClubReqCardHelpView:OnDisable()
    if this.seasonCarditem then 
        this.seasonCarditem:OnDestroy()
        this.seasonCarditem = nil 
    end 

end

function ClubReqCardHelpView.OnDestroy()
    if this.seasonCarditem then 
        this.seasonCarditem:OnDestroy()
        this.seasonCarditem = nil 
    end 

    this:Destroy()
end

return this