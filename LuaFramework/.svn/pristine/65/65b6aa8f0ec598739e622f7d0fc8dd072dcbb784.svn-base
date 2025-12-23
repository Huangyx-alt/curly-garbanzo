--请求资源界面
local ClubReqResAskView = BaseView:New("ClubReqResAskView","ClubAtlas")

local this = ClubReqResAskView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_claim",  --请求发送
    "btn_close",  --关闭
    "toggle_Coin",     --请求金币
    "toggle_Diamand",   --请求钻石
    "toggle_Rocket", --请求火箭
    "Anima"  --动画
}

function ClubReqResAskView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubReqResAskView:Awake()
    self:on_init()
end

function ClubReqResAskView:OnEnable()
   --初始化
    this.itemId = 1
   

    self.luabehaviour:AddToggleChange(self.toggle_Coin.gameObject, function(go,check)
        if(check== true) then 
            this.itemId = 1

            self.toggle_Diamand.isOn = false
            self.toggle_Rocket.isOn = false

        end 
    end)
    
    self.luabehaviour:AddToggleChange(self.toggle_Diamand.gameObject, function(go,check)
        if(check== true) then 
            this.itemId = 2

            self.toggle_Coin.isOn = false
            self.toggle_Rocket.isOn = false
        end 
    end)
    self.luabehaviour:AddToggleChange(self.toggle_Rocket.gameObject, function(go,check)
        if(check== true) then 
            this.itemId = 3

            self.toggle_Coin.isOn = false
            self.toggle_Diamand.isOn = false
        end 
    end)

    self.toggle_Coin.isOn = true 
    self.toggle_Diamand.isOn = false
    self.toggle_Rocket.isOn = false
end

function ClubReqResAskView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle_Rocket.gameObject)
    self.luabehaviour:RemoveClick(self.toggle_Diamand.gameObject)
    self.luabehaviour:RemoveClick(self.toggle_Coin.gameObject)
end

--发送请求
function ClubReqResAskView:on_btn_claim_click()
    ModelList.ClubModel.C2S_ClubRoomAskResource(this.itemId)
    AnimatorPlayHelper.Play(self.Anima,{"end","ClubReqCardView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

--查看成员列表
function ClubReqResAskView:on_btn_close_click()

    AnimatorPlayHelper.Play(self.Anima,{"end","ClubReqCardView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
 
end  


function ClubReqResAskView.OnDestroy()
    this:Destroy()
    local culbAssetList = require("Module/ClubAssetList")
    if culbAssetList then
        Cache.unload_ab_no_depen(culbAssetList["ClubReqResAskView"],false)        
    end
end


return this